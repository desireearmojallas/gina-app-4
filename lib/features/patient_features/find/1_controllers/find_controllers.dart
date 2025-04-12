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

  Future<Either<Exception, List<DoctorModel>>> getDoctorsNearMe({
    required double radius,
  }) async {
    try {
      // Convert radius from kilometers to meters for the distance calculation
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

              // Use dynamic radius value here instead of hardcoded 25000
              if (distance <= maxDistance) {
                return DoctorModel.fromJson(doctorData);
              } else {
                return null; // Fixed the return null statement
              }
            })
            .where((doctor) => doctor != null)
            .toList();

        doctorList.sort((a, b) {
          // --- Get values ---
          double ratingA = a!.averageRating ?? 0.0;
          double ratingB = b!.averageRating ?? 0.0;

          double distanceA =
              double.parse(calculateDistanceToDoctor(a.officeLatLngAddress));
          double distanceB =
              double.parse(calculateDistanceToDoctor(b.officeLatLngAddress));

          double badgeScoreA = getBadgeScore(a.doctorRatingId);
          double badgeScoreB = getBadgeScore(b.doctorRatingId);

          // --- Normalize values ---
          double normalizedRatingA = ratingA / 5.0;
          double normalizedRatingB = ratingB / 5.0;

          double normalizedDistanceA = 1 -
              (math.log(1 + distanceA) / math.log(1 + maxDistance))
                  .clamp(0.0, 1.0);
          double normalizedDistanceB = 1 -
              (math.log(1 + distanceB) / math.log(1 + maxDistance))
                  .clamp(0.0, 1.0);

          // --- Calculate final scores ---
          double scoreA = (normalizedRatingA * 0.5) +
              (normalizedDistanceA * 0.4) +
              (badgeScoreA * 0.1);

          double scoreB = (normalizedRatingB * 0.5) +
              (normalizedDistanceB * 0.4) +
              (badgeScoreB * 0.1);

          debugPrint('Max Distance: $maxDistance');

          debugPrint(
              "Doctor ${a.name}: Rating=$ratingA ($normalizedRatingA), Distance=${distanceA}km ($normalizedDistanceA), Badge=${a.doctorRatingId} ($badgeScoreA)");
          debugPrint(
              "Formula components: Rating=${normalizedRatingA * 0.5}, Distance=${normalizedDistanceA * 0.4}, Badge=${badgeScoreA * 0.1}");

          // --- Compare by score (descending) ---
          return scoreB.compareTo(scoreA);
        });

        return Right(doctorList.cast<DoctorModel>());
      } else {
        return const Right([]);
      }
    } catch (e) {
      // Error handling remains the same
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
          // --- Get values ---
          double ratingA = a.averageRating ?? 0.0;
          double ratingB = b.averageRating ?? 0.0;

          double distanceA =
              double.parse(calculateDistanceToDoctor(a.officeLatLngAddress));
          double distanceB =
              double.parse(calculateDistanceToDoctor(b.officeLatLngAddress));

          double badgeScoreA = getBadgeScore(a.doctorRatingId);
          double badgeScoreB = getBadgeScore(b.doctorRatingId);

          // --- Normalize values ---
          double normalizedRatingA = ratingA / 5.0;
          double normalizedRatingB = ratingB / 5.0;

          double normalizedDistanceA = 1 -
              (math.log(1 + distanceA) / math.log(1 + maxDistance))
                  .clamp(0.0, 1.0);
          double normalizedDistanceB = 1 -
              (math.log(1 + distanceB) / math.log(1 + maxDistance))
                  .clamp(0.0, 1.0);

          // --- Calculate final scores ---
          double scoreA = (normalizedRatingA * 0.5) +
              (normalizedDistanceA * 0.4) +
              (badgeScoreA * 0.1);

          double scoreB = (normalizedRatingB * 0.5) +
              (normalizedDistanceB * 0.4) +
              (badgeScoreB * 0.1);

          // --- Compare by score (descending) ---
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

  String calculateDistanceToDoctor(String doctorLatLngString) {
    final doctorLatLng = parseLatLngFromString(doctorLatLngString);
    final distance = geo.Geodesy().distanceBetweenTwoGeoPoints(
        storePatientCurrentGeoLatLng!, doctorLatLng);
    return (distance / 1000).toStringAsFixed(
        2); // Convert meters to kilometers and format to 2 decimal places
  }
}
