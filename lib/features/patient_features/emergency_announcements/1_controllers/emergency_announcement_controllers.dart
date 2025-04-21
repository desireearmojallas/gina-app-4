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

  Future<void> markAnnouncementAsClicked(String announcementId) async {
    try {
      if (announcementId.isEmpty) {
        debugPrint(
            'Cannot mark announcement as clicked: Empty announcement ID');
        return;
      }

      await firestore
          .collection('emergencyAnnouncements')
          .where('id', isEqualTo: announcementId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({'clickedByPatient': true});
          debugPrint(
              'Marked announcement $announcementId as clicked by patient');
        }
      });
    } catch (e) {
      debugPrint('Error marking announcement as clicked: $e');
    }
  }
}
