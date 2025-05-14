import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:geodesy/geodesy.dart' as geo;
import 'package:gina_app_4/features/patient_features/find/0_model/city_model.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/bloc/home_bloc.dart';

class FindController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuthException? error;
  bool working = false;

  Future<Either<Exception, List<DoctorModel>>> getDoctors() async {
    try {
      final doctorSnapshot = await firestore
          .collection('doctors')
          .where('doctorVerificationStatus', isEqualTo: 1)
          .get();

      if (doctorSnapshot.docs.isNotEmpty) {
        final doctorList = doctorSnapshot.docs
            .map((doctor) => DoctorModel.fromJson(doctor.data()))
            .toList();

        return Right(doctorList);
      }

      return const Right([]);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      debugPrint(e.code);
      working = false;
      error = e;
      return Left(Exception(e.message));
    } catch (e) {
      debugPrint(e.toString());
      working = false;
      error = FirebaseAuthException(code: 'error', message: e.toString());
      return Left(Exception(e.toString()));
    }
  }

  double getBadgeScore(int doctorRatingId) {
    switch (doctorRatingId) {
      case 0:
        return 0.2; // newDoctor
      case 1:
        return 0.4; // contributingDoctor
      case 2:
        return 0.6; // activeDoctor
      case 3:
        return 1.0; // topDoctor
      case 4:
        return 0.0; // inactiveDoctor
      default:
        return 0.0; // fallback
    }
  }

  double calculateDoctorScore({
    required double rating,
    required double distance,
    required int badgeId,
    required double radius,
  }) {
    final normalizedRating = rating / 5.0;
    final logDistance = math.log(1 + distance);
    final logRadius = math.log(1 + radius);
    final distanceRatio = logDistance / logRadius;
    final normalizedDistance = 1 - distanceRatio.clamp(0.0, 1.0);
    final badgeScore = getBadgeScore(badgeId);

    return (normalizedRating * 0.5) +
        (normalizedDistance * 0.4) +
        (badgeScore * 0.1);
  }

  void debugDoctorScore({
    required String doctorName,
    required double rating,
    required double distance,
    required int badgeId,
    required double radius,
  }) {
    final score = calculateDoctorScore(
      rating: rating,
      distance: distance,
      badgeId: badgeId,
      radius: radius,
    );

    debugPrint('=== Score Calculation for $doctorName ===');
    debugPrint('Rating: $rating → Normalized: ${rating / 5.0}');
    debugPrint('Distance: ${distance}km');
    debugPrint(
        '  log(1 + distance) = ${math.log(1 + distance)}');
    debugPrint(
        '  log(1 + radius) = ${math.log(1 + radius)}');
    debugPrint(
        '  distanceRatio = ${math.log(1 + distance) / math.log(1 + radius)}');
    debugPrint(
        '  Normalized Distance = ${1 - (math.log(1 + distance) / math.log(1 + radius)).clamp(0.0, 1.0)}');
    debugPrint('Badge Score: ${getBadgeScore(badgeId)}');
    debugPrint(
        'Final Score = (${rating / 5.0} * 0.5) + (${1 - (math.log(1 + distance) / math.log(1 + radius)).clamp(0.0, 1.0)} * 0.4) + (${getBadgeScore(badgeId)} * 0.1) = $score');
    debugPrint('=====================================');
  }

  Future<Either<Exception, List<DoctorModel>>> getDoctorsNearMe({
    required double radius,
  }) async {
    try {
      final double maxDistance = radius * 1000; // Convert km to meters

      final doctorSnapshot = await firestore
          .collection('doctors')
          .where('doctorVerificationStatus', isEqualTo: 1)
          .get();

      if (doctorSnapshot.docs.isNotEmpty) {
        final doctorList = doctorSnapshot.docs
            .map((doctor) {
              final doctorData = doctor.data();
              final geo.LatLng officeLatLng =
                  parseLatLngFromString(doctorData['officeLatLngAddress']);
              doctorData['officeLatLng'] = officeLatLng;

              final distance = geo.Geodesy().distanceBetweenTwoGeoPoints(
                  storePatientCurrentGeoLatLng!, officeLatLng);

              if (distance <= maxDistance) {
                return DoctorModel.fromJson(doctorData);
              } else {
                return null;
              }
            })
            .where((doctor) => doctor != null)
            .toList();

        doctorList.sort((a, b) {
          final scoreA = calculateDoctorScore(
              rating: a!.averageRating ?? 0.0,
              distance: calculateDistanceToDoctor(a.officeLatLngAddress),
              badgeId: a.doctorRatingId,
              radius: radius);

          final scoreB = calculateDoctorScore(
            rating: b!.averageRating ?? 0.0,
            distance: calculateDistanceToDoctor(b.officeLatLngAddress),
            badgeId: b.doctorRatingId,
            radius: radius,
          );

          debugPrint('=== Comparing ${a.name} vs ${b.name} ===');
          debugPrint('${a.name}:');
          debugPrint(
              '  Rating: ${a.averageRating} → ${(a.averageRating ?? 0.0) / 5.0}');
          debugPrint(
              '  Distance: ${calculateDistanceToDoctor(a.officeLatLngAddress)}km → ${1 - (math.log(1 + calculateDistanceToDoctor(a.officeLatLngAddress)) / math.log(1 + radius)).clamp(0.0, 1.0)}');
          debugPrint(
              '  Badge: ${a.doctorRatingId} → ${getBadgeScore(a.doctorRatingId)}');
          debugPrint('  Final Score: $scoreA');
          debugPrint('${b.name}:');
          debugPrint(
              '  Rating: ${b.averageRating} → ${(b.averageRating ?? 0.0) / 5.0}');
          debugPrint(
              '  Distance: ${calculateDistanceToDoctor(b.officeLatLngAddress)}km → ${1 - (math.log(1 + calculateDistanceToDoctor(b.officeLatLngAddress)) / math.log(1 + radius)).clamp(0.0, 1.0)}');
          debugPrint(
              '  Badge: ${b.doctorRatingId} → ${getBadgeScore(b.doctorRatingId)}');
          debugPrint('  Final Score: $scoreB');
          debugPrint('Comparison result: ${scoreB.compareTo(scoreA)}');
          debugPrint('=====================================');

          return scoreB.compareTo(scoreA);
        });

        return Right(doctorList.cast<DoctorModel>());
      } else {
        return const Right([]);
      }
    } catch (e) {
      debugPrint(e.toString());
      working = false;
      error = FirebaseAuthException(code: 'error', message: e.toString());
      return Left(Exception(e.toString()));
    }
  }

  geo.LatLng parseLatLngFromString(String locationString) {
    String cleanedString =
        locationString.replaceAll('LatLng(', '').replaceAll(')', '');
    List<String> values = cleanedString.split(', ');
    double latitude = double.parse(values[0]);
    double longitude = double.parse(values[1]);
    return geo.LatLng(latitude, longitude);
  }

  // get cities in the philippines
  Future<List<CityModel>> getCitiesInPhilippines() async {
    String cityData =
        await rootBundle.loadString('assets/cities_data/city_data.json');

    List<dynamic> citiesJson = json.decode(cityData);

    // convert json data to a list of city objects
    List<CityModel> cities = citiesJson.map((cityJson) {
      String cityName = cityJson['name'];
      double latitude = cityJson['latitude'];
      double longitude = cityJson['longitude'];
      geo.LatLng coordinates = geo.LatLng(latitude, longitude);
      return CityModel(name: cityName, coordinates: coordinates);
    }).toList();
    return cities;
  }

  Future<Either<Exception, Map<String, List<DoctorModel>>>> getDoctorInCities({
    required double radius, // Add this parameter to match getDoctorsNearMe
  }) async {
    try {
      final double maxDistance = radius * 1000;

      final cities = await getCitiesInPhilippines();
      final doctorSnapshot = await firestore
          .collection('doctors')
          .where('doctorVerificationStatus', isEqualTo: 1)
          .get();

      final Map<String, List<DoctorModel>> doctorsInCities = {};

      for (final doctor in doctorSnapshot.docs) {
        final doctorData = doctor.data();
        final officeMapsLocationAddress =
            doctorData['officeMapsLocationAddress'];

        // Check if the officeMapsLocationAddress contains the name of any city
        for (final city in cities) {
          if (officeMapsLocationAddress.contains(city.name)) {
            if (doctorsInCities.containsKey(city.name)) {
              doctorsInCities[city.name]!.add(DoctorModel.fromJson(doctorData));
            } else {
              doctorsInCities[city.name] = [DoctorModel.fromJson(doctorData)];
            }
          }
        }
      }

      doctorsInCities.forEach((city, doctors) {
        doctors.sort((a, b) {
          final scoreA = calculateDoctorScore(
            rating: a.averageRating ?? 0.0,
            distance: calculateDistanceToDoctor(a.officeLatLngAddress),
            badgeId: a.doctorRatingId,
            radius: radius,
          );
          
          final scoreB = calculateDoctorScore(
            rating: b.averageRating ?? 0.0,
            distance: calculateDistanceToDoctor(b.officeLatLngAddress),
            badgeId: b.doctorRatingId,
            radius: radius,
          );

          debugPrint('=== Comparing ${a.name} vs ${b.name} in $city ===');
          debugPrint('${a.name}:');
          debugPrint(
              '  Rating: ${a.averageRating} → ${(a.averageRating ?? 0.0) / 5.0}');
          debugPrint(
              '  Distance: ${calculateDistanceToDoctor(a.officeLatLngAddress)}km → ${1 - (math.log(1 + calculateDistanceToDoctor(a.officeLatLngAddress)) / math.log(1 + radius)).clamp(0.0, 1.0)}');
          debugPrint(
              '  Badge: ${a.doctorRatingId} → ${getBadgeScore(a.doctorRatingId)}');
          debugPrint('  Final Score: $scoreA');
          debugPrint('${b.name}:');
          debugPrint(
              '  Rating: ${b.averageRating} → ${(b.averageRating ?? 0.0) / 5.0}');
          debugPrint(
              '  Distance: ${calculateDistanceToDoctor(b.officeLatLngAddress)}km → ${1 - (math.log(1 + calculateDistanceToDoctor(b.officeLatLngAddress)) / math.log(1 + radius)).clamp(0.0, 1.0)}');
          debugPrint(
              '  Badge: ${b.doctorRatingId} → ${getBadgeScore(b.doctorRatingId)}');
          debugPrint('  Final Score: $scoreB');
          debugPrint('Comparison result: ${scoreB.compareTo(scoreA)}');
          debugPrint('=====================================');

          return scoreB.compareTo(scoreA);
        });
      });

      final sortedDoctorsInCities = Map.fromEntries(
        doctorsInCities.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)),
      );
      return Right(sortedDoctorsInCities);
    } catch (e) {
      debugPrint(e.toString());
      working = false;
      return Left(Exception('Failed to get doctors in cities'));
    }
  }

  double calculateDistanceToDoctor(String doctorLatLngString) {
    try {
      final doctorLatLng = parseLatLngFromString(doctorLatLngString);

      if (storePatientCurrentGeoLatLng == null) {
        debugPrint('ERROR: storePatientCurrentGeoLatLng is null');
        return 0.0;
      }

      final distance = geo.Geodesy().distanceBetweenTwoGeoPoints(
          storePatientCurrentGeoLatLng!, doctorLatLng);

      return double.parse((distance / 1000).toStringAsFixed(2));
    } catch (e) {
      debugPrint('ERROR calculating distance: ${e.toString()}');
      return 0.0;
    }
  }
}
