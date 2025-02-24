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

  Future<Either<Exception, EmergencyAnnouncementModel>>
      getNearestEmergencyAnnouncement() async {
    try {
      if (currentPatient == null) {
        throw Exception('No current patient found');
      }

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('emergencyAnnouncements')
          .where('patientUid', isEqualTo: currentPatient!.uid)
          .get();

      if (snapshot.docs.isEmpty) {
        return Right(EmergencyAnnouncementModel.empty);
      }

      List<QueryDocumentSnapshot<Map<String, dynamic>>> sortedDocs =
          snapshot.docs.toList()
            ..sort((a, b) => (b['createdAt'] as Timestamp)
                .compareTo(a['createdAt'] as Timestamp));

      final latestDoc = sortedDocs.first;

      final doctorModel = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(snapshot.docs.first.data()['doctorUid'])
          .get()
          .then((value) => DoctorModel.fromJson(value.data()!));

      doctorMedicalSpecialty = doctorModel.medicalSpecialty;

      EmergencyAnnouncementModel announcement =
          EmergencyAnnouncementModel.fromJson(latestDoc.data());

      return Right(announcement);
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
}
