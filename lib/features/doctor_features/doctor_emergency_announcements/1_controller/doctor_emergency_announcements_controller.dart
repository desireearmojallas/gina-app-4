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

AppointmentModel? chosenAppointment;

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
          .toList();

      // Filter out past dates
      final today = DateTime.now();
      final todayDateOnly = DateTime(today.year, today.month, today.day);
      patientAppointment = patientAppointment.where((appointment) {
        final appointmentDate =
            DateFormat('MMMM d, yyyy').parse(appointment.appointmentDate!);
        return appointmentDate.isAfter(todayDateOnly) ||
            appointmentDate.isAtSameMomentAs(todayDateOnly);
      }).toList();

      // Sort future dates
      patientAppointment.sort((a, b) {
        final aDate = DateFormat('MMMM d, yyyy').parse(a.appointmentDate!);
        final bDate = DateFormat('MMMM d, yyyy').parse(b.appointmentDate!);
        return aDate.compareTo(bDate);
      });

      var groupedAppointments = groupBy<AppointmentModel, DateTime>(
        patientAppointment,
        (appointment) =>
            DateFormat('MMMM d, yyyy').parse(appointment.appointmentDate!),
      );

      return Right(groupedAppointments);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      return Left(Exception(e.message));
    }
  }

  Future<Either<Exception, bool>> createEmergencyAnnouncement({
    required List<String> appointmentUids,
    required List<String> patientUids,
    required String emergencyMessage,
    required List<String> patientNames,
    required Map<String, String>
        patientToAppointmentMap, // Now required: Maps patientUid to appointmentUid
  }) async {
    try {
      debugPrint(
          'Creating emergency announcement for ${patientUids.length} patients');
      debugPrint('Patient UIDs: $patientUids');
      debugPrint('Patient Names: $patientNames');
      debugPrint('Appointment UIDs: $appointmentUids');

      // Validate that all patients have an appointment mapping
      final unmappedPatients = patientUids.where(
          (patientUid) => !patientToAppointmentMap.containsKey(patientUid));
      if (unmappedPatients.isNotEmpty) {
        return Left(Exception(
            'Some patients are missing appointment mappings: ${unmappedPatients.join(", ")}'));
      }

      final currentUserModel = await firestore
          .collection('doctors')
          .doc(currentUser!.uid)
          .get()
          .then((value) => DoctorModel.fromJson(value.data()!));

      // Create a document reference at the root level
      DocumentReference<Map<String, dynamic>> docRef = firestore
          .collection('emergencyAnnouncements')
          .doc(); // Let Firestore generate the ID

      debugPrint('Created document reference with ID: ${docRef.id}');

      // Initialize clickedByPatients map with all patients set to false (unclicked)
      Map<String, bool> clickedByPatients = {};
      for (String patientUid in patientUids) {
        clickedByPatients[patientUid] = false;
      }

      // Save to the same reference we created
      await docRef.set({
        'id': docRef.id,
        'appointmentUids': appointmentUids,
        'doctorUid': currentUser!.uid,
        'patientUids': patientUids,
        'patientNames': patientNames,
        'message': emergencyMessage,
        'createdBy': currentUserModel.name,
        'profileImage': '',
        'createdAt': Timestamp.now(),
        'clickedByPatients': clickedByPatients,
        'patientToAppointmentMap': patientToAppointmentMap,
      });

      debugPrint('Successfully created emergency announcement document');
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

  Future<Either<Exception, bool>> deleteEmergencyAnnouncement(
    EmergencyAnnouncementModel emergencyAnnouncement,
  ) async {
    try {
      await firestore
          .collection('emergencyAnnouncements')
          .doc(emergencyAnnouncement.emergencyId)
          .delete();

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      return Left(Exception(e.message));
    }
  }

  Future<Either<Exception, AppointmentModel>> getChosenAppointment(
      String appointmentUid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('appointments').doc(appointmentUid).get();

      if (snapshot.exists && snapshot.data() != null) {
        final appointment = AppointmentModel.fromJson(snapshot.data()!);
        return Right(appointment);
      } else {
        return Left(Exception('Appointment not found'));
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      return Left(Exception(e.message));
    }
  }
}
