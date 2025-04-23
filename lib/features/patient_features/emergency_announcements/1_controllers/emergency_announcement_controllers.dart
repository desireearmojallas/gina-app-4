import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/0_model/emergency_announcements_model.dart';
import 'package:gina_app_4/features/patient_features/emergency_announcements/2_views/bloc/emergency_announcements_bloc.dart';

class EmergencyAnnouncementsController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  User? currentPatient;
  FirebaseAuthException? error;
  bool working = false;

  EmergencyAnnouncementsController() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentPatient = user;
      notifyListeners();
    });
  }

  Future<Either<Exception, List<EmergencyAnnouncementModel>>>
      getEmergencyAnnouncements() async {
    try {
      if (currentPatient == null) {
        throw Exception('No current patient found');
      }

      // Set to track unique announcement IDs to avoid duplicates
      final Set<String> processedIds = {};
      List<EmergencyAnnouncementModel> announcements = [];

      // QUERY 1: Get announcements with new structure (patientUids array)
      QuerySnapshot<Map<String, dynamic>> newFormatSnapshot =
          await FirebaseFirestore.instance
              .collection('emergencyAnnouncements')
              .where('patientUids', arrayContains: currentPatient!.uid)
              .get();

      debugPrint(
          'Found ${newFormatSnapshot.docs.length} announcements with new format (patientUids array)');

      // Process new format documents
      for (var doc in newFormatSnapshot.docs) {
        if (!processedIds.contains(doc.data()['id'])) {
          processedIds.add(doc.data()['id']);

          final doctorModel = await FirebaseFirestore.instance
              .collection('doctors')
              .doc(doc.data()['doctorUid'])
              .get()
              .then((value) => DoctorModel.fromJson(value.data()!));

          doctorMedicalSpecialty = doctorModel.medicalSpecialty;

          EmergencyAnnouncementModel announcement =
              EmergencyAnnouncementModel.fromJson(doc.data());
          announcements.add(announcement);
        }
      }

      // QUERY 2: Get announcements with old structure (patientUid string)
      QuerySnapshot<Map<String, dynamic>> oldFormatSnapshot =
          await FirebaseFirestore.instance
              .collection('emergencyAnnouncements')
              .where('patientUid', isEqualTo: currentPatient!.uid)
              .get();

      debugPrint(
          'Found ${oldFormatSnapshot.docs.length} announcements with old format (patientUid string)');

      // Process old format documents
      for (var doc in oldFormatSnapshot.docs) {
        if (!processedIds.contains(doc.data()['id'])) {
          processedIds.add(doc.data()['id']);

          final doctorModel = await FirebaseFirestore.instance
              .collection('doctors')
              .doc(doc.data()['doctorUid'])
              .get()
              .then((value) => DoctorModel.fromJson(value.data()!));

          doctorMedicalSpecialty = doctorModel.medicalSpecialty;

          EmergencyAnnouncementModel announcement =
              EmergencyAnnouncementModel.fromJson(doc.data());
          announcements.add(announcement);
        }
      }

      debugPrint('Total unique announcements found: ${announcements.length}');

      if (announcements.isEmpty) {
        return const Right([]);
      }

      // Sort the announcements by createdAt in descending order
      announcements.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Right(announcements);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      return Left(Exception(e.message));
    } on FirebaseException catch (e) {
      debugPrint('FirebaseException: ${e.message}');
      return Left(Exception(e.message));
    } catch (e) {
      debugPrint('Exception: $e');
      return Left(Exception(e.toString()));
    }
  }

  Stream<EmergencyAnnouncementModel> listenForEmergencyAnnouncements() {
    if (currentPatient == null) {
      return const Stream.empty();
    }

    final controller = StreamController<EmergencyAnnouncementModel>();

    // Track processed announcement IDs to avoid duplicates
    final Set<String> processedIds = {};

    // Listen for new-format announcements (using patientUids array)
    final newFormatSubscription = firestore
        .collection('emergencyAnnouncements')
        .where('patientUids', arrayContains: currentPatient!.uid)
        .snapshots()
        .listen((snapshot) async {
      for (final change in snapshot.docChanges) {
        // Only process newly added announcements
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data()!;
          final id = data['id'] as String? ?? change.doc.id;

          // Skip if already processed
          if (processedIds.contains(id)) continue;
          processedIds.add(id);

          try {
            // Get doctor information
            final doctorModel = await firestore
                .collection('doctors')
                .doc(data['doctorUid'])
                .get()
                .then((value) => value.data() != null
                    ? DoctorModel.fromJson(value.data()!)
                    : null);

            if (doctorModel != null) {
              doctorMedicalSpecialty = doctorModel.medicalSpecialty;
            }

            final announcement = EmergencyAnnouncementModel.fromJson(data);
            controller.add(announcement);
            debugPrint(
                'New emergency announcement received: ${announcement.emergencyId}');
          } catch (e) {
            debugPrint('Error processing announcement: $e');
          }
        }
      }
    });

    // Listen for old-format announcements (using patientUid string)
    final oldFormatSubscription = firestore
        .collection('emergencyAnnouncements')
        .where('patientUid', isEqualTo: currentPatient!.uid)
        .snapshots()
        .listen((snapshot) async {
      for (final change in snapshot.docChanges) {
        // Only process newly added announcements
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data()!;
          final id = data['id'] as String? ?? change.doc.id;

          // Skip if already processed
          if (processedIds.contains(id)) continue;
          processedIds.add(id);

          try {
            // Get doctor information
            final doctorModel = await firestore
                .collection('doctors')
                .doc(data['doctorUid'])
                .get()
                .then((value) => value.data() != null
                    ? DoctorModel.fromJson(value.data()!)
                    : null);

            if (doctorModel != null) {
              doctorMedicalSpecialty = doctorModel.medicalSpecialty;
            }

            final announcement = EmergencyAnnouncementModel.fromJson(data);
            controller.add(announcement);
            debugPrint(
                'New emergency announcement received: ${announcement.emergencyId}');
          } catch (e) {
            debugPrint('Error processing announcement: $e');
          }
        }
      }
    });

    // Clean up the subscriptions when the stream is cancelled
    controller.onCancel = () {
      newFormatSubscription.cancel();
      oldFormatSubscription.cancel();
    };

    return controller.stream;
  }

  Future<void> markAnnouncementAsClicked({
    required String emergencyId,
    required String patientUid,
  }) async {
    try {
      debugPrint('⭐️ CONTROLLER: markAnnouncementAsClicked called');
      debugPrint('⭐️ CONTROLLER: emergencyId = $emergencyId');
      debugPrint('⭐️ CONTROLLER: patientUid = $patientUid');

      if (emergencyId.isEmpty || patientUid.isEmpty) {
        debugPrint(
            '⛔️ CONTROLLER: Cannot mark announcement as clicked: Empty ID or UID');
        return;
      }

      // Direct reference to the exact document
      final announcementRef =
          firestore.collection('emergencyAnnouncements').doc(emergencyId);

      debugPrint('⭐️ CONTROLLER: Getting document snapshot...');

      // First fetch the current document
      final docSnapshot = await announcementRef.get();
      if (!docSnapshot.exists) {
        debugPrint('⛔️ CONTROLLER: Document does not exist: $emergencyId');
        return;
      }

      debugPrint('⭐️ CONTROLLER: Document exists! ID: ${docSnapshot.id}');

      final data = docSnapshot.data();
      if (data == null) {
        debugPrint('⛔️ CONTROLLER: Document data is null');
        return;
      }

      // Verify if clickedByPatients exists
      if (data['clickedByPatients'] != null) {
        debugPrint(
            '⭐️ CONTROLLER: Current clickedByPatients: ${data['clickedByPatients']}');
      } else {
        debugPrint(
            '⚠️ CONTROLLER: clickedByPatients does not exist in the document! Creating new map.');
      }

      // Get the existing clickedByPatients map or create a new one
      Map<String, dynamic> clickedByPatients = {};
      if (data['clickedByPatients'] != null) {
        clickedByPatients =
            Map<String, dynamic>.from(data['clickedByPatients']);
      }

      // Update the patient's status
      clickedByPatients[patientUid] = true;
      debugPrint(
          '⭐️ CONTROLLER: Updated clickedByPatients: $clickedByPatients');

      // Update the document with the modified map
      await announcementRef.update({
        'clickedByPatients': clickedByPatients,
      });

      debugPrint('✅ CONTROLLER: Document updated successfully!');

      // Verify the update
      final verifyDoc = await firestore
          .collection('emergencyAnnouncements')
          .doc(emergencyId)
          .get();
      final verifyData = verifyDoc.data();
      if (verifyData != null && verifyData['clickedByPatients'] != null) {
        debugPrint(
            '✅ CONTROLLER: Verified clickedByPatients after update: ${verifyData['clickedByPatients']}');
      }
    } catch (e) {
      debugPrint(
          '❌ CONTROLLER ERROR: Failed to mark announcement as clicked: $e');
      rethrow; // Re-throw to let the bloc handle it
    }
  }

  Future<String?> findAppointmentForPatient(
      EmergencyAnnouncementModel announcement, String? patientUid) async {
    if (patientUid == null) return null;

    debugPrint('🔍 Finding appointment for patient: $patientUid');

    // Strategy 1: Try the direct mapping (new format)
    if (announcement.patientToAppointmentMap.containsKey(patientUid)) {
      final appointmentUid = announcement.patientToAppointmentMap[patientUid];
      debugPrint('✅ Found via patient map: $appointmentUid');
      return appointmentUid;
    }

    // Strategy 2: Try array index matching
    if (announcement.patientUids.isNotEmpty) {
      int patientIndex =
          announcement.patientUids.indexWhere((uid) => uid == patientUid);

      if (patientIndex != -1 &&
          patientIndex < announcement.appointmentUids.length) {
        final appointmentUid = announcement.appointmentUids[patientIndex];
        debugPrint('✅ Found via array index: $appointmentUid');
        return appointmentUid;
      }
    }

    // Strategy 3: Query appointments collection (for old format)
    if (announcement.appointmentUids.isNotEmpty) {
      try {
        for (String appointmentUid in announcement.appointmentUids) {
          final appointmentDoc = await firestore
              .collection('appointments')
              .doc(appointmentUid)
              .get();

          if (appointmentDoc.exists) {
            final data = appointmentDoc.data();
            if (data != null && data['patientUid'] == patientUid) {
              debugPrint('✅ Found via Firestore query: $appointmentUid');
              return appointmentUid;
            }
          }
        }
      } catch (e) {
        debugPrint('⚠️ Error querying appointments: $e');
      }
    }

    // Fallback: Just return the first appointment UID
    if (announcement.appointmentUids.isNotEmpty) {
      debugPrint(
          '⚠️ Fallback to first appointment: ${announcement.appointmentUids.first}');
      return announcement.appointmentUids.first;
    }

    debugPrint('❌ No appointment found for patient');
    return null;
  }
}
