import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patients/0_models/user_appointment_period_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:intl/intl.dart';

List<AppointmentModel>? patientAppointmentList;

class DoctorViewPatientsController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  User? currentUser;
  FirebaseAuthException? error;
  bool working = false;

  DoctorViewPatientsController() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentUser = user;
      notifyListeners();
    });
  }

  // Fetch a list of patients who booked an appointment with the current doctor
  // Retrieves a list of UserModel objects | Filters out doctors who don't have any upcoming or ongoing appointments

  Future<Either<Exception, List<UserModel>>> getListOfPatients() async {
    try {
      QuerySnapshot<Map<String, dynamic>> userSnapshot = await firestore
          .collection('patients')
          .where('doctorsBookedForAppt', arrayContains: currentUser!.uid)
          .get();
      List<UserModel> patients = userSnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();

      List<UserModel> filteredPatients = [];

      for (var patient in patients) {
        QuerySnapshot<Map<String, dynamic>> appointmentSnapshot =
            await firestore
                .collection('appointments')
                .where('patientUid', isEqualTo: patient.uid)
                .where('doctorUid', isEqualTo: currentUser!.uid)
                .get();

        final currentDate = DateTime.now();

        patientAppointmentList = appointmentSnapshot.docs
            .map((doc) => AppointmentModel.fromJson(doc.data()))
            .where((element) =>
                element.appointmentStatus == 1 ||
                element.appointmentStatus == 2)
            .toList()
          ..sort((a, b) {
            final aDate = DateFormat('MMMM d, yyyy').parse(a.appointmentDate!);
            final bDate = DateFormat('MMMM d, yyyy').parse(b.appointmentDate!);
            return aDate
                .difference(currentDate)
                .abs()
                .compareTo(bDate.difference(currentDate).abs());
          });

        if (patientAppointmentList!.isNotEmpty) {
          filteredPatients.add(patient);
        }
      }

      return Right(filteredPatients);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  // Fetch a list of patients who booked an appointment with the current doctor
  // Retrieves a list of AppointmentModel objects |  Filters out appointments that are not in the status of upcoming (status 1) or ongoing (status 2)

  Future<Either<Exception, List<AppointmentModel>>>
      getListOfPatientsAppointment() async {
    try {
      QuerySnapshot<Map<String, dynamic>> userSnapshot = await firestore
          .collection('patients')
          .where('doctorsBookedForAppt', arrayContains: currentUser!.uid)
          .get();
      List<UserModel> patients = userSnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();

      for (var patient in patients) {
        QuerySnapshot<Map<String, dynamic>> appointmentSnapshot =
            await firestore
                .collection('appointments')
                .where('patientUid', isEqualTo: patient.uid)
                .where('doctorUid', isEqualTo: currentUser!.uid)
                .get();

        final currentDate = DateTime.now();

        patientAppointmentList = appointmentSnapshot.docs
            .map((doc) => AppointmentModel.fromJson(doc.data()))
            .where((element) =>
                element.appointmentStatus == 1 ||
                element.appointmentStatus == 2)
            .toList()
          ..sort((a, b) {
            final aDate = DateFormat('MMMM d, yyyy').parse(a.appointmentDate!);
            final bDate = DateFormat('MMMM d, yyyy').parse(b.appointmentDate!);
            return aDate
                .difference(currentDate)
                .abs()
                .compareTo(bDate.difference(currentDate).abs());
          });
      }

      return Right(patientAppointmentList!);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  // Fetch detailed info about a specific patient, including their appointments/consultation history and cycle information
  Future<Either<Exception, UserAppointmentPeriodModel>> getDoctorPatients({
    required String patientUid,
  }) async {
    try {
      QuerySnapshot<Map<String, dynamic>> userSnapshot = await firestore
          .collection('patients')
          .where('uid', isEqualTo: patientUid)
          .where('doctorsBookedForAppt', arrayContains: currentUser!.uid)
          .get();
      List<UserModel> patients = userSnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
      List<AppointmentModel> patientAppointment = [];
      List<PeriodTrackerModel> patientPeriods = [];
      final currentDate = DateTime.now();

      for (var patient in patients) {
        QuerySnapshot<Map<String, dynamic>> appointmentSnapshot =
            await firestore
                .collection('appointments')
                .where('patientUid', isEqualTo: patient.uid)
                .where('doctorUid', isEqualTo: currentUser!.uid)
                .get();

        patientAppointment = appointmentSnapshot.docs
            .map((doc) => AppointmentModel.fromJson(doc.data()))
            .toList()
          ..sort((a, b) {
            final aDate = DateFormat('MMMM d, yyyy').parse(a.appointmentDate!);
            final bDate = DateFormat('MMMM d, yyyy').parse(b.appointmentDate!);
            return aDate
                .difference(currentDate)
                .abs()
                .compareTo(bDate.difference(currentDate).abs());
          });
        final periodSnapshot = await FirebaseFirestore.instance
            .collection('patients')
            .doc(patient.uid)
            .collection('patientLogs')
            .where('startDate',
                isLessThanOrEqualTo:
                    Timestamp.fromDate(DateTime.now())) // Add this line
            .get();

        patientPeriods = periodSnapshot.docs
            .map((doc) => PeriodTrackerModel.fromJson(doc.data()))
            .toList();
      }

      UserAppointmentPeriodModel userAppointmentPeriodModel =
          UserAppointmentPeriodModel(
        patients: patients,
        patientAppointments: patientAppointment,
        patientPeriods: patientPeriods,
      );
      return Right(userAppointmentPeriodModel);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }
}
