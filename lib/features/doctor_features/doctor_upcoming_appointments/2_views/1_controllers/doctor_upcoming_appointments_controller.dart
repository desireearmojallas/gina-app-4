import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:intl/intl.dart';

class DoctorUpcomingAppointmentControllers with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  User? currentUser;
  FirebaseAuthException? error;
  bool working = false;

  DoctorUpcomingAppointmentControllers() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentUser = user;
      notifyListeners();
    });
  }

  Future<Either<Exception, UserModel>> getPatientData({
    required String patientUid,
  }) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> patientSnapshot =
          await firestore.collection('patients').doc(patientUid).get();

      if (patientSnapshot.exists) {
        var patientData = UserModel.fromJson(patientSnapshot.data()!);
        return Right(patientData);
      } else {
        throw Exception('Patient not found');
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      return Left(Exception(e.message));
    }
  }

  Future<Either<Exception, Map<DateTime, List<AppointmentModel>>>>
      getConfirmedDoctorAppointmentRequest() async {
    try {
      QuerySnapshot<Map<String, dynamic>> appointmentSnapshot = await firestore
          .collection('appointments')
          .where('doctorUid', isEqualTo: currentUser!.uid)
          .where('appointmentStatus',
              isEqualTo: AppointmentStatus.confirmed.index)
          .get();

      var patientAppointment = appointmentSnapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()))
          .toList()
        ..sort((a, b) {
          final aDate = DateFormat('MMMM d, yyyy').parse(a.appointmentDate!);
          final bDate = DateFormat('MMMM d, yyyy').parse(b.appointmentDate!);
          return aDate
              .difference(DateTime.now())
              .abs()
              .compareTo(bDate.difference(DateTime.now()).abs());
        });

      var groupedAppointments = groupBy<AppointmentModel, DateTime>(
        patientAppointment,
        (appointment) =>
            DateFormat('MMMM d, yyyy').parse(appointment.appointmentDate!),
      );

      // Ensure there's an entry for today's date
      final today = DateTime.now();
      final todayDateOnly = DateTime(today.year, today.month, today.day);
      if (!groupedAppointments.containsKey(todayDateOnly)) {
        groupedAppointments[todayDateOnly] = [];
      }

      return Right(groupedAppointments);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;

      return Left(Exception(e.message));
    }
  }

  Future<Either<Exception, Map<DateTime, List<AppointmentModel>>>>
      getCompletedDoctorAppointmentRequest() async {
    try {
      QuerySnapshot<Map<String, dynamic>> appointmentSnapshot = await firestore
          .collection('appointments')
          .where('doctorUid', isEqualTo: currentUser!.uid)
          .where('appointmentStatus',
              isEqualTo: AppointmentStatus.completed.index)
          .get();

      var patientAppointment = appointmentSnapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()))
          .toList()
        ..sort((a, b) {
          final aDate = DateFormat('MMMM d, yyyy').parse(a.appointmentDate!);
          final bDate = DateFormat('MMMM d, yyyy').parse(b.appointmentDate!);
          return aDate
              .difference(DateTime.now())
              .abs()
              .compareTo(bDate.difference(DateTime.now()).abs());
        });

      var groupedAppointments = groupBy<AppointmentModel, DateTime>(
        patientAppointment,
        (appointment) =>
            DateFormat('MMMM d, yyyy').parse(appointment.appointmentDate!),
      );

      return Right(groupedAppointments);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;

      return Left(Exception(e.message));
    }
  }
}
