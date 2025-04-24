import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:intl/intl.dart';

int? pendingAppointmentsCount;
int? confirmedAppointmentsCount;
String? doctorName;
AppointmentModel? upcomingAppointment;
AppointmentModel? pendingAppointment;
UserModel? patientDataCont;
Map<DateTime, List<AppointmentModel>>? completedAppointments = {};

class DoctorHomeDashboardController extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  User? currentUser;
  FirebaseAuthException? error;
  bool working = false;

  DoctorHomeDashboardController() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentUser = user;
      notifyListeners();
    });
  }

  Future<Either<Exception, int>> getConfirmedAppointments() async {
    try {
      QuerySnapshot<Map<String, dynamic>> appointmentSnapshot = await firestore
          .collection('appointments')
          .where('doctorUid', isEqualTo: currentUser!.uid)
          .where('appointmentStatus',
              isEqualTo: AppointmentStatus.confirmed.index)
          .get();

      confirmedAppointmentsCount = appointmentSnapshot.docs.length;
      var patientAppointmentCount = appointmentSnapshot.docs.length;

      return Right(patientAppointmentCount);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  Future<Either<Exception, AppointmentModel>> getUpcomingAppointment() async {
    try {
      await updateMissedAppointments(); // Call the method to update missed appointments

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

      if (patientAppointment.isNotEmpty) {
        upcomingAppointment = patientAppointment.first;
        return Right(patientAppointment.first);
      } else {
        return Right(AppointmentModel());
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      return Left(Exception(e.message));
    }
  }

  Future<void> updateMissedAppointments() async {
    try {
      QuerySnapshot<Map<String, dynamic>> appointmentSnapshot = await firestore
          .collection('appointments')
          .where('doctorUid', isEqualTo: currentUser!.uid)
          .where('appointmentStatus',
              isEqualTo: AppointmentStatus.confirmed.index)
          .get();

      final DateFormat dateTimeFormat = DateFormat('MMMM d, yyyy h:mm a');
      final DateTime now = DateTime.now();

      for (var doc in appointmentSnapshot.docs) {
        final appointment = AppointmentModel.fromJson(doc.data());
        final appointmentEndTime = dateTimeFormat.parse(
            '${appointment.appointmentDate} ${appointment.appointmentTime?.split('-')[1].trim()}');

        if (now.isAfter(appointmentEndTime)) {
          await firestore.collection('appointments').doc(doc.id).update({
            'appointmentStatus': AppointmentStatus.missed.index,
            'lastUpdatedAt': FieldValue.serverTimestamp(),
            'isViewed': false,
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
    }
  }

  Future<Either<Exception, int>> getPendingAppointments() async {
    try {
      await updateDeclinedAppointments(); // Call the method to update declined appointments
      QuerySnapshot<Map<String, dynamic>> appointmentSnapshot = await firestore
          .collection('appointments')
          .where('doctorUid', isEqualTo: currentUser!.uid)
          .where('appointmentStatus',
              isEqualTo: AppointmentStatus.pending.index)
          .get();

      pendingAppointmentsCount = appointmentSnapshot.docs.length;
      var patientAppointmentCount = appointmentSnapshot.docs.length;

      return Right(patientAppointmentCount);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  Future<Either<Exception, AppointmentModel>>
      getPendingAppointmentLatest() async {
    try {
      await updateDeclinedAppointments(); // Call the method to update declined appointments

      QuerySnapshot<Map<String, dynamic>> appointmentSnapshot = await firestore
          .collection('appointments')
          .where('doctorUid', isEqualTo: currentUser!.uid)
          .where('appointmentStatus',
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

      if (patientAppointment.isNotEmpty) {
        pendingAppointment = patientAppointment.first;
        return Right(patientAppointment.first);
      } else {
        return Right(AppointmentModel());
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      return Left(Exception(e.message));
    }
  }

  Future<void> updateDeclinedAppointments() async {
    try {
      QuerySnapshot<Map<String, dynamic>> appointmentSnapshot = await firestore
          .collection('appointments')
          .where('doctorUid', isEqualTo: currentUser!.uid)
          .where('appointmentStatus',
              isEqualTo: AppointmentStatus.pending.index)
          .get();

      final DateFormat dateTimeFormat = DateFormat('MMMM d, yyyy h:mm a');
      final DateTime now = DateTime.now();

      for (var doc in appointmentSnapshot.docs) {
        final appointment = AppointmentModel.fromJson(doc.data());
        final appointmentEndTime = dateTimeFormat.parse(
            '${appointment.appointmentDate} ${appointment.appointmentTime?.split('-')[1].trim()}');

        if (now.isAfter(appointmentEndTime)) {
          await firestore.collection('appointments').doc(doc.id).update({
            'appointmentStatus': AppointmentStatus.declined.index,
            'lastUpdatedAt': FieldValue.serverTimestamp(),
            'isViewed': false,
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
    }
  }

  Future<Either<Exception, UserModel>> getPatientData(String patientUid) async {
    try {
      // Debug print to check the patientUid
      debugPrint('Fetching patient data for patientUid: $patientUid');

      DocumentSnapshot<Map<String, dynamic>> patientSnapshot =
          await firestore.collection('patients').doc(patientUid).get();

      var patientData = UserModel.fromJson(patientSnapshot.data()!);

      patientDataCont = patientData;

      return Right(patientData);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      return Left(Exception(e.message));
    }
  }

  Future<Either<Exception, Map<DateTime, List<AppointmentModel>>>>
      getCompletedAppointments() async {
    try {
      QuerySnapshot<Map<String, dynamic>> appointmentSnapshot = await firestore
          .collection('appointments')
          .where('doctorUid', isEqualTo: currentUser!.uid)
          // .where('appointmentStatus',
          //     isEqualTo: AppointmentStatus.completed.index)
          .get();

      var patientCompletedAppointment = appointmentSnapshot.docs
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

      if (patientCompletedAppointment.isNotEmpty) {
        Map<DateTime, List<AppointmentModel>> completedAppointmentsMap = {};
        for (var appointment in patientCompletedAppointment) {
          final appointmentDate =
              DateFormat('MMMM d, yyyy').parse(appointment.appointmentDate!);
          if (completedAppointmentsMap.containsKey(appointmentDate)) {
            completedAppointmentsMap[appointmentDate]!.add(appointment);
          } else {
            completedAppointmentsMap[appointmentDate] = [appointment];
          }
        }
        return Right(completedAppointmentsMap);
      } else {
        return const Right(<DateTime, List<AppointmentModel>>{});
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  Future<Either<Exception, List<PeriodTrackerModel>>> getPatientPeriods(
      String patientUid) async {
    try {
      // Debug print to check the patientUid
      debugPrint('Fetching periods for patientUid: $patientUid');

      QuerySnapshot<Map<String, dynamic>> periodSnapshot = await firestore
          .collection('patients')
          .doc(patientUid)
          .collection('patientLogs')
          .orderBy('startDate')
          .get();

      var patientPeriods = periodSnapshot.docs
          .map((doc) => PeriodTrackerModel.fromFirestore(doc))
          .toList();

      return Right(patientPeriods);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      return Left(Exception(e.message));
    }
  }

  Future<Either<Exception, Map<String, dynamic>>>
      checkForExceededAppointments() async {
    try {
      QuerySnapshot<Map<String, dynamic>> appointmentSnapshot = await firestore
          .collection('appointments')
          .where('doctorUid', isEqualTo: currentUser!.uid)
          .where('appointmentStatus',
              isEqualTo: AppointmentStatus.confirmed.index)
          .get();

      if (appointmentSnapshot.docs.isEmpty) {
        return Left(Exception('No confirmed appointments found'));
      }

      final DateTime now = DateTime.now();
      final DateFormat dateTimeFormat = DateFormat('MMMM d, yyyy h:mm a');

      final f2fAppointments = appointmentSnapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()))
          .where((appointment) =>
              appointment.modeOfAppointment ==
                  ModeOfAppointmentId.faceToFaceConsultation.index &&
              appointment.f2fAppointmentStarted == true &&
              (appointment.f2fAppointmentConcluded == false))
          .toList();

      if (f2fAppointments.isEmpty) {
        return Left(Exception('No active F2F appointments found'));
      }

      for (var appointment in f2fAppointments) {
        if (appointment.appointmentTime == null) continue;

        final appointmentEndTime = dateTimeFormat.parse(
            '${appointment.appointmentDate} ${appointment.appointmentTime!.split('-')[1].trim()}');

        if (now.isAfter(appointmentEndTime)) {
          final patientData = await getPatientData(appointment.patientUid!);
          final patientName = patientData.fold(
            (l) => 'Patient',
            (r) => r.name,
          );

          debugPrint('🕒 Found exceeded appointment for: $patientName');
          return Right({
            'patientName': patientName,
            'scheduledEndTime': appointmentEndTime,
            'currentTime': now,
            'appointmentId': appointment.appointmentUid,
          });
        }
      }

      return Left(Exception('No appointments have exceeded their time'));
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      return Left(Exception(e.message));
    } catch (e) {
      debugPrint('Error checking for exceeded appointments: $e');
      return Left(Exception(e.toString()));
    }
  }
}
