import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<Either<Exception, List<DoctorModel>>> getDoctorsNearMe() async {
    try {
      // 25km radius of the user's current location
      const double maxDistance = 25000;

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
                null;
              }
            })
            .where((doctor) => doctor != null)
            .toList();

        doctorList.sort((a, b) {
          // First compare by averageRating (descending order - highest rating first)
          double ratingA = a!.averageRating ?? 0.0;
          double ratingB = b!.averageRating ?? 0.0;
          int averageRatingComparison =
              ratingB.compareTo(ratingA); // descending
          if (averageRatingComparison != 0) {
            return averageRatingComparison;
          }

          // If averageRating is the same, compare by distance from user
          double distanceA =
              double.parse(calculateDistanceToDoctor(a.officeLatLngAddress));
          double distanceB =
              double.parse(calculateDistanceToDoctor(b.officeLatLngAddress));
          int distanceComparison = distanceA.compareTo(distanceB); // ascending
          if (distanceComparison != 0) {
            return distanceComparison;
          }

          // If everything else is equal, compare by doctorRatingId
          // (keeping doctorRatingId=4 at the end)
          if (a.doctorRatingId == 4 && b.doctorRatingId != 4) {
            return 1;
          } else if (a.doctorRatingId != 4 && b.doctorRatingId == 4) {
            return -1;
          } else {
            return b.doctorRatingId.compareTo(a.doctorRatingId); // descending
          }
        });

        return Right(doctorList.cast<DoctorModel>());
      } else {
        return const Right([]);
      }
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

  Future<Either<Exception, Map<String, List<DoctorModel>>>>
      getDoctorInCities() async {
    try {
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

        //check if the officeMapsLocationAddress contains the name of any city
        for (final city in cities) {
          if (officeMapsLocationAddress.contains(city.name)) {
            //if the city already exists
            if (doctorsInCities.containsKey(city.name)) {
              doctorsInCities[city.name]!.add(DoctorModel.fromJson(doctorData));
            }
            //if the city doesnt exist yet
            else {
              doctorsInCities[city.name] = [DoctorModel.fromJson(doctorData)];
            }
          }
        }
      }

      doctorsInCities.forEach((city, doctors) {
        doctors.sort((a, b) {
          if (a.doctorRatingId == 4 && b.doctorRatingId != 4) {
            return 1; // Place doctors with rating 4 at the end
          } else if (a.doctorRatingId != 4 && b.doctorRatingId == 4) {
            return -1; // Place doctors with rating 4 at the end
          } else {
            int ratingComparison = b.doctorRatingId
                .compareTo(a.doctorRatingId); // Descending order
            if (ratingComparison != 0) {
              return ratingComparison;
            } else {
              return a.officeLatLngAddress.compareTo(b.officeLatLngAddress);
            }
          }
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
