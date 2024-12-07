import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/0_model/emergency_announcements_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:intl/intl.dart';

class DoctorEmergencyAnnouncementsController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  User? currentUser;
  FirebaseAuthException? error;
  bool working = false;

  DoctorEmergencyAnnouncementsController() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentUser = user;
      notifyListeners();
    });
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

      final today = DateTime.now();
      final todayDateOnly = DateTime(today.year, today.month, today.day);
      if (groupedAppointments.containsKey(todayDateOnly)) {
        groupedAppointments[todayDateOnly] = [];
      }

      return Right(groupedAppointments);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      error = e;

      return Left(Exception(e.message));
    }
  }

  Future<Either<Exception, bool>> createEmergencyAnnouncement({
    required String appointmentUid,
    required String patientUid,
    required String emergencyMessage,
    required String patientName,
  }) async {
    try {
      DocumentReference<Map<String, dynamic>> snap = firestore
          .collection('emergencyAnnouncements')
          .doc(currentUser!.uid)
          .collection('createdAnnouncements')
          .doc();

      final currentUserModel = await firestore
          .collection('doctors')
          .doc(currentUser!.uid)
          .get()
          .then((value) => DoctorModel.fromJson(value.data()!));

      await firestore.collection('emergencyAnnouncements').doc(snap.id).set({
        'id': snap.id,
        'appointmentUid': appointmentUid,
        'doctorUid': currentUser!.uid,
        'patientUid': patientUid,
        'patientName': patientName,
        'message': emergencyMessage,
        'createdBy': currentUserModel.name,
        'profileImage': '',
        'createdAt': Timestamp.now(),
      });

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  Future<Either<Exception, List<EmergencyAnnouncementModel>>>
      getEmergencyAnnouncements() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('emergencyAnnouncements')
          .where('doctorUid', isEqualTo: currentUser!.uid)
          .get();

      List<EmergencyAnnouncementModel> announcements = snapshot.docs
          .map((doc) => EmergencyAnnouncementModel.fromJson(doc.data()))
          .toList();

      if (announcements.isEmpty) {
        return const Right([]);
      }

      return Right(announcements);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException ${e.code}');
      return Left(Exception(e.message));
    }
  }
}
