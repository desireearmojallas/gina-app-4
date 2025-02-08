import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
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

  // Data for ongoing appointment
  AppointmentModel? ongoingAppointmentForDoctorOnGoingAppointment;
  DoctorModel? associatedDoctorForDoctorOngoingAppointment;
  bool hasOngoingAppointmentForDoctor = false;

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
      debugPrint('Fetching pending doctor appointment requests');
      QuerySnapshot<Map<String, dynamic>> appointmentSnapshot = await firestore
          .collection('appointments')
          .where('doctorUid', isEqualTo: currentUser!.uid)
          .where('appointmentStatus',
              isEqualTo: AppointmentStatus.pending.index)
          .get();

      debugPrint('Fetched ${appointmentSnapshot.docs.length} pending requests');

      var patientAppointment = appointmentSnapshot.docs.map((doc) {
        debugPrint('Appointment data: ${doc.data()}');
        return AppointmentModel.fromJson(doc.data());
      }).toList()
        ..sort((a, b) {
          final aDate = DateFormat('MMMM d, yyyy').parse(a.appointmentDate!);
          final bDate = DateFormat('MMMM d, yyyy').parse(b.appointmentDate!);
          return aDate
              .difference(DateTime.now())
              .abs()
              .compareTo(bDate.difference(DateTime.now()).abs());
        });

      // Add null checks and error handling for date parsing
      var groupedAppointments = groupBy<AppointmentModel, DateTime>(
        patientAppointment,
        (appointment) {
          if (appointment.appointmentDate == null) {
            debugPrint(
                'Null appointment date for appointment: ${appointment.appointmentUid}');
            throw Exception('Null appointment date');
          }
          try {
            return DateFormat('MMMM d, yyyy')
                .parse(appointment.appointmentDate!);
          } catch (e) {
            debugPrint('Error parsing date: ${appointment.appointmentDate}');
            throw Exception(
                'Error parsing date: ${appointment.appointmentDate}');
          }
        },
      );

      debugPrint('Grouped appointments: $groupedAppointments');

      return Right(groupedAppointments);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
      return Left(Exception(e.toString()));
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

      // Update missed appointments
      await updateMissedAppointments(patientAppointment);

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

// Function to update missed appointments
  Future<void> updateMissedAppointments(
      List<AppointmentModel> appointments) async {
    final now = DateTime.now();

    for (var appointment in appointments) {
      final appointmentDate =
          DateFormat('MMMM d, yyyy').parse(appointment.appointmentDate!);
      final appointmentTimes = appointment.appointmentTime!.split(' - ');
      final appointmentStartTime =
          DateFormat('hh:mm a').parse(appointmentTimes[0]);
      final appointmentEndTime =
          DateFormat('hh:mm a').parse(appointmentTimes[1]);

      final appointmentStartDateTime = DateTime(
        appointmentDate.year,
        appointmentDate.month,
        appointmentDate.day,
        appointmentStartTime.hour,
        appointmentStartTime.minute,
      );

      final appointmentEndDateTime = DateTime(
        appointmentDate.year,
        appointmentDate.month,
        appointmentDate.day,
        appointmentEndTime.hour,
        appointmentEndTime.minute,
      );

      if (appointmentEndDateTime.isBefore(now) &&
          appointment.appointmentStatus == AppointmentStatus.confirmed.index &&
          !appointment.hasVisitedConsultationRoom) {
        await firestore
            .collection('appointments')
            .doc(appointment.appointmentUid)
            .update({
          'appointmentStatus': AppointmentStatus.missed.index,
        });

        appointment.appointmentStatus = AppointmentStatus.missed.index;
      }
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

  //---------- Get Missed Doctor Appointment Request -----------

  Future<Either<Exception, Map<DateTime, List<AppointmentModel>>>>
      getMissedDoctorAppointmentRequest() async {
    try {
      QuerySnapshot<Map<String, dynamic>> appointmentSnapshot = await firestore
          .collection('appointments')
          .where('doctorUid', isEqualTo: currentUser!.uid)
          .where('appointmentStatus', isEqualTo: AppointmentStatus.missed.index)
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

  //---------- Get Completed Doctor Appointment Request -----------

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
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  //---------- Approve Doctor Appointment Request -----------

  Future<Either<Exception, bool>> approvePendingPatientRequest({
    required String appointmentId,
  }) async {
    debugPrint('Approving appointment with ID: $appointmentId');
    try {
      await firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({'appointmentStatus': AppointmentStatus.confirmed.index});
      debugPrint('Appointment approved successfully');

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      debugPrint('Error approving appointment: $e');
      return Left(Exception(e.message));
    }
  }

  //---------- Decline Doctor Appointment Request -----------

  Future<Either<Exception, bool>> declinePendingPatientRequest({
    required String appointmentId,
  }) async {
    debugPrint('Declining appointment with ID: $appointmentId');
    try {
      await firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({'appointmentStatus': AppointmentStatus.declined.index});
      debugPrint('Appointment declined successfully');

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      debugPrint('Error declining appointment: $e');
      return Left(Exception(e.message));
    }
  }

  //---------- Begin F2F Patient Appointment -----------

  Future<Either<Exception, bool>> beginF2FPatientAppointment({
    required String appointmentId,
  }) async {
    try {
      await firestore.collection('appointments').doc(appointmentId).update({
        'f2fAppointmentStarted': true,
        'f2fAppointmentStartedTime': Timestamp.now(),
      });

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
      notifyListeners();
      return Left(Exception(e.toString()));
    }
  }

  //---------- Conclude/Complete F2F Patient Appointment -----------

  Future<Either<Exception, bool>> concludeF2FPatientAppointment({
    required String appointmentId,
  }) async {
    try {
      await firestore.collection('appointments').doc(appointmentId).update({
        'appointmentStatus': AppointmentStatus.completed.index,
        'f2fAppointmentConcluded': true,
        'f2fAppointmentConcludedTime': Timestamp.now(),
      });

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
      notifyListeners();
      return Left(Exception(e.toString()));
    }
  }

  //---------- Completed Patient Appointment -----------

  Future<Either<Exception, bool>> completePatientAppointment({
    required String appointmentId,
  }) async {
    try {
      await firestore.collection('appointments').doc(appointmentId).update({
        'appointmentStatus': AppointmentStatus.completed.index,
        'onlineAppointmentCompletedTime': Timestamp.now(),
      });

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

  //---------- CHECK ONGOING APPOINTMENT -----------
  Future<Either<Exception, AppointmentModel?>> checkOnGoingAppointment() async {
    try {
      final snapshotStream = firestore
          .collection('appointments')
          .where('doctorUid', isEqualTo: currentUser!.uid)
          .where('appointmentStatus',
              isEqualTo: AppointmentStatus.confirmed.index)
          .snapshots();

      final snapshot = await snapshotStream.first;

      final today = DateFormat('MMMM d, yyyy').format(DateTime.now());

      bool ongoingAppointmentFound = false;

      for (var doc in snapshot.docs) {
        final data = doc.data();

        final appointmentDate = data['appointmentDate'] as String;
        final appointmentTime = data['appointmentTime'] as String;

        if (appointmentDate != today) continue;

        final times = appointmentTime.split(' - ');
        if (times.length != 2) continue;

        final startTime = DateFormat('hh:mm a').parse(times[0]);
        final endTime = DateFormat('hh:mm a').parse(times[1]);

        final appointmentStartDateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          startTime.hour,
          startTime.minute,
        );
        final appointmentEndDateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          endTime.hour,
          endTime.minute,
        );

        final now = DateTime.now();
        if (now.isAfter(appointmentStartDateTime) &&
            now.isBefore(appointmentEndDateTime)) {
          ongoingAppointmentForDoctorOnGoingAppointment =
              AppointmentModel.fromDocumentSnap(doc);
          ongoingAppointmentFound = true;
          break;
        }
      }

      if (ongoingAppointmentFound) {
        return Right(ongoingAppointmentForDoctorOnGoingAppointment);
      } else {
        return const Right(null);
      }
    } catch (e) {
      debugPrint('Error checking ongoing appointments: $e');
      return Left(Exception('Error checking ongoing appointments'));
    }
  }

  Stream<AppointmentModel?> checkOnGoingAppointmentStream() {
    return firestore
        .collection('appointments')
        .where('doctorUid', isEqualTo: currentUser!.uid)
        .where('appointmentStatus',
            isEqualTo: AppointmentStatus.confirmed.index)
        .snapshots()
        .map((snapshot) {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final appointmentDate = data['appointmentDate'] as String;
        final appointmentTime = data['appointmentTime'] as String;
        final modeOfAppointment = data['modeOfAppointment'] as int;

        final today = DateFormat('MMMM d, yyyy').format(DateTime.now());
        if (appointmentDate != today) continue;

        final times = appointmentTime.split(' - ');
        if (times.length != 2) continue;

        final startTime = DateFormat('h:mm a').parse(times[0]);
        final endTime = DateFormat('h:mm a').parse(times[1]);

        final appointmentStartDateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          startTime.hour,
          startTime.minute,
        );
        final appointmentEndDateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          endTime.hour,
          endTime.minute,
        );

        final now = DateTime.now();

        if (modeOfAppointment == 1) {
          // Whole day appointment
          if (now.isBefore(appointmentEndDateTime)) {
            return AppointmentModel.fromDocumentSnap(doc);
          }
        } else {
          // Regular appointment
          if (now.isAfter(appointmentStartDateTime) &&
              now.isBefore(appointmentEndDateTime)) {
            return AppointmentModel.fromDocumentSnap(doc);
          }
        }
      }
      return null; // If no ongoing appointment is found
    });
  }

  void resetOnGoingAppointment({
    bool clearDoctor = true,
    bool clearAppointment = true,
    bool notify = true,
  }) {
    debugPrint('Resetting ongoing appointment data...');

    if (clearAppointment) {
      debugPrint('Clearing ongoing appointment details...');
      ongoingAppointmentForDoctorOnGoingAppointment = null;
    }

    if (clearDoctor) {
      debugPrint('Clearing associated doctor details...');
      associatedDoctorForDoctorOngoingAppointment = null;
    }

    hasOngoingAppointmentForDoctor = false;

    if (notify) {
      debugPrint('Notifying listeners about reset...');
      notifyListeners();
    }

    debugPrint('Ongoing appointment data reset completed.');
  }

  //---------- CHECK IF THERE ARE MESSAGES INSIDE CONSULTATION CHATROOM -----------

  Stream<bool> hasMessagesStream(String chatroomId, String appointmentId) {
    try {
      return FirebaseFirestore.instance
          .collection('consultation-chatrooms')
          .doc(chatroomId)
          .collection('appointments')
          .doc(appointmentId)
          .collection('messages')
          .snapshots()
          .map((messagesSnapshot) {
        if (messagesSnapshot.docs.isEmpty) {
          debugPrint(
              'No messages found in chatroom $chatroomId for appointment $appointmentId');
          return false;
        }

        debugPrint(
            'Messages found in chatroom $chatroomId for appointment $appointmentId');
        return true;
      });
    } catch (e) {
      // Log the error or handle it as needed
      debugPrint('Error checking messages: $e');
      return Stream.value(false);
    }
  }
}
