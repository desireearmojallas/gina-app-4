import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patients/0_models/user_appointment_period_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:intl/intl.dart';

class DoctorAppointmentRequestController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  User? currentUser;
  FirebaseAuthException? error;
  bool working = false;

  DoctorAppointmentRequestController() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentUser = user;
      notifyListeners();
    });
  }

  //-------------------- Get Patient Data --------------------

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
      debugPrint('Firebase Auth Exception: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      return Left(Exception(e.message));
    }
  }

  //---------- Get Pending Doctor Appointment Request -----------

  Future<Either<Exception, Map<DateTime, List<AppointmentModel>>>>
      getPendingDoctorAppointmentRequest() async {
    try {
      QuerySnapshot<Map<String, dynamic>> appointmentSnapshot = await firestore
          .collection('appointments')
          .where('doctorUid', isEqualTo: currentUser!.uid)
          .where('appointmentStauts',
              isEqualTo: AppointmentStatus.pending.index)
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
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  //---------- Get Confirmed Doctor Appointment Request -----------

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

      return Right(groupedAppointments);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  //---------- Get Declined Doctor Appointment Request -----------

  Future<Either<Exception, Map<DateTime, List<AppointmentModel>>>>
      getDeclinedDoctorAppointmentRequest() async {
    try {
      QuerySnapshot<Map<String, dynamic>> appointmentSnapshot = await firestore
          .collection('appointments')
          .where('doctorUid', isEqualTo: currentUser!.uid)
          .where('appointmentStatus',
              isEqualTo: AppointmentStatus.declined.index)
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
              DateFormat('MMMM d, yyyy').parse(appointment.appointmentDate!));

      return Right(groupedAppointments);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  //---------- Get Cancelled Doctor Appointment Request -----------

  Future<Either<Exception, Map<DateTime, List<AppointmentModel>>>>
      getCancelledDoctorAppointmentRequest() async {
    try {
      QuerySnapshot<Map<String, dynamic>> appointmentSnapshot = await firestore
          .collection('appointments')
          .where('doctorUid', isEqualTo: currentUser!.uid)
          .where('appointmentStatus',
              isEqualTo: AppointmentStatus.cancelled.index)
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
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  //---------- Approve Doctor Appointment Request -----------

  Future<Either<Exception, bool>> approvePendingPatientRequest({
    required String appointmentId,
  }) async {
    try {
      await firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({'appointmentStatus': AppointmentStatus.confirmed.index});

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  //---------- Decline Doctor Appointment Request -----------

  Future<Either<Exception, bool>> declinePendingPatientRequest({
    required String appointmentId,
  }) async {
    try {
      await firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({'appointmentStatus': AppointmentStatus.declined.index});

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  //---------- Completed Patient Appointment -----------

  Future<Either<Exception, bool>> completePatientAppointment({
    required String appointmentId,
  }) async {
    try {
      await firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({'appointStatus': AppointmentStatus.completed.index});

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  //---------- Patient Data -----------

  Future<Either<Exception, UserAppointmentPeriodModel>> getDoctorPatients({
    required String patientUid,
  }) async {
    try {
      QuerySnapshot<Map<String, dynamic>> userSnapshot = await firestore
          .collection('patients')
          .where('uid', isEqualTo: patientUid)
          .where('doctorBookedForAppt', arrayContains: currentUser!.uid)
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
            .where((appointment) =>
                appointment.appointmentStatus == 1 ||
                appointment.appointmentStatus == 2)
            .where((appointment) =>
                appointment.modeOfAppointment ==
                ModeOfAppointmentId.onlineConsultation.index)
            .toList()
          ..sort((a, b) {
            final aDate = DateFormat('MMMM d, yyyy').parse(a.appointmentDate!);
            final bDate = DateFormat('MMMM d, yyyy').parse(b.appointmentDate!);
            return aDate
                .difference(currentDate)
                .abs()
                .compareTo(bDate.difference(currentDate).abs());
          });

        final periodSnapshot = await firestore
            .collection('patients')
            .doc(patient.uid)
            .collection('patientLogs')
            .where('startDate',
                isLessThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
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
