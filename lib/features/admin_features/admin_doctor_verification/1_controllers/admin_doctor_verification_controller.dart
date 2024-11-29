import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_verification_model.dart';

class AdminDoctorVerificationController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  FirebaseAuthException? error;
  bool working = false;

  //--------------- GET ALL DOCTORS -------------------

  Future<Either<Exception, List<DoctorModel>>> getAllDoctors() async {
    try {
      final doctorSnapshot = await firestore.collection('doctors').get();

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
      return Left(
        Exception(e.message),
      );
    } catch (e) {
      debugPrint(e.toString());
      working = false;
      error = FirebaseAuthException(message: e.toString(), code: 'error');
      return Left(Exception(e.toString()));
    }
  }

  //---------- REVERSE GEOCODE OFFICE LATLNG ADDRESS ---------------
  Future<Either<Exception, String>> reverseGeocodeOfficeLatLngAddress({
    required String doctorId,
  }) async {
    try {
      // Fetch the doctor document from Firestore
      final doctorSnapshot =
          await firestore.collection('doctors').doc(doctorId).get();

      if (!doctorSnapshot.exists) {
        return Left(Exception('Doctor document does not exist.'));
      }

      // Get the officeLatLngAddress from the document data
      final doctorOfficeAddress = doctorSnapshot.data()?['officeLatLngAddress'];

      if (doctorOfficeAddress == null) {
        return Left(Exception('Office LatLng Address not found.'));
      }

      // Extract latitude and longitude from the address string
      final match = RegExp(r"LatLng\(([-\d.]+),\s([-\d.]+)\)")
          .firstMatch(doctorOfficeAddress);

      if (match == null) {
        return Left(Exception('Invalid LatLng format.'));
      }

      final latitude = double.parse(match.group(1)!);
      final longitude = double.parse(match.group(2)!);

      final doctorLatLngAddress = LatLng(latitude, longitude);
      debugPrint('Doctor Office LatLng: $doctorLatLngAddress');

      // Now perform reverse geocoding to get the human-readable address
      final address = await _reverseGeocodeLatLng(doctorLatLngAddress);

      // Return the address if reverse geocoding is successful
      return Right(address);
    } catch (e) {
      // Log the error and return it
      debugPrint(e.toString());
      return Left(Exception(
          'Failed to reverse geocode office address: ${e.toString()}'));
    }
  }

// Function to handle reverse geocoding using Google Maps Geocoding API
  Future<String> _reverseGeocodeLatLng(LatLng latLng) async {
    const apiKey =
        'AIzaSyBg5KxB2Rdw7UV86btx0YJFmGkfF3CXUbc'; // Replace with your actual API key
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        // Extract the human-readable address from the response
        final formattedAddress = data['results'][0]['formatted_address'];
        return formattedAddress;
      } else {
        throw Exception('Failed to reverse geocode: No results found.');
      }
    } else {
      throw Exception('Failed to fetch data from Google Geocoding API.');
    }
  }

  //---------- GET DOCTOR SUBMITTED MEDICAL LICENSE ---------------

  Future<Either<Exception, List<DoctorVerificationModel>>>
      getDoctorSubmittedMedicalLicense({
    required String doctorId,
  }) async {
    try {
      final doctorSnaphot = await firestore
          .collection('doctors')
          .doc(doctorId)
          .collection('doctorSubmittedDocuments')
          .get();

      if (doctorSnaphot.docs.isNotEmpty) {
        final doctorSubmittedDocuments = doctorSnaphot.docs
            .map((doctor) => DoctorVerificationModel.fromJson(doctor.data()))
            .toList();

        doctorSubmittedDocuments
            .sort((a, b) => a.dateSubmitted.compareTo(b.dateSubmitted));

        return Right(doctorSubmittedDocuments);
      }
      return const Right([]);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      debugPrint(e.code);
      working = false;
      error = e;
      return Left(
        Exception(e.message),
      );
    } catch (e) {
      debugPrint(e.toString());
      working = false;
      error = FirebaseAuthException(message: e.toString(), code: 'error');
      return Left(Exception(e.toString()));
    }
  }

  //---------- APPROVE DOCTOR VERIFICATION ---------------

  Future<Either<Exception, bool>> approveDoctorVerification({
    required String doctorId,
    required String doctorVerificationId,
  }) async {
    try {
      await firestore
          .collection('doctors')
          .doc(doctorId)
          .collection('doctorSubmittedDocuments')
          .doc(doctorVerificationId)
          .update({
        'verificationStuatus': DoctorVerificationStatus.approved.index,
      });

      await firestore.collection('doctors').doc(doctorId).update({
        'doctorVerificationStatus': DoctorVerificationStatus.approved.index,
        'isVerified': true,
        'verifiedData': Timestamp.now(),
      });

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      debugPrint(e.code);
      working = false;
      error = e;
      return Left(
        Exception(e.message),
      );
    } catch (e) {
      debugPrint(e.toString());
      working = false;
      error = FirebaseAuthException(message: e.toString(), code: 'error');
      return Left(Exception(e.toString()));
    }
  }

  //---------- DECLINE DOCTOR VERIFICATION ---------------

  Future<Either<Exception, bool>> declineDoctorVerification({
    required String doctorId,
    required String doctorVerificationId,
    required String declineReason,
  }) async {
    try {
      await firestore
          .collection('doctors')
          .doc(doctorId)
          .collection('doctorSubmittedDocuments')
          .doc(doctorVerificationId)
          .update({
        'verificationStatuts': DoctorVerificationStatus.declined.index,
        'declineReason': declineReason,
      });

      await firestore.collection('doctors').doc(doctorId).update({
        'doctorVerificationStatus': DoctorVerificationStatus.declined.index,
        'verifiedDate': Timestamp.now(),
      });

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      debugPrint(e.code);
      working = false;
      error = e;
      return Left(
        Exception(e.message),
      );
    } catch (e) {
      debugPrint(e.toString());
      working = false;
      error = FirebaseAuthException(message: e.toString(), code: 'error');
      return Left(Exception(e.toString()));
    }
  }
}
