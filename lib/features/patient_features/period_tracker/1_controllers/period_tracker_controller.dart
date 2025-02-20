import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';

class PeriodTrackerController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  User? currentUser;
  FirebaseAuthException? error;
  bool working = false;

  PeriodTrackerController() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentUser = user;
      notifyListeners();
    });
  }

  //------------------Log Menstrual Period------------------
  Future<void> logMenstrualPeriod({
    required DateTime startDate,
    required DateTime endDate,
    required List<DateTime> periodDates,
  }) async {
    try {
      //TODO: Add the code to log the menstrual period
    } catch (e) {}
  }

  Future<Either<Exception, List<PeriodTrackerModel>>> getAllPeriods() async {
    try {
      // Retrieve menstrual cycle data from Firestore
      final menstrualPeriodCycle = await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('patientLogs')
          .get();

      final periodPredictions = await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('periodPredictions')
          .get();

      List<PeriodTrackerModel> allPeriods = [];

      if (menstrualPeriodCycle.docs.isNotEmpty) {
        allPeriods.addAll(menstrualPeriodCycle.docs
            .map((e) => PeriodTrackerModel.fromJson(e.data()))
            .toList());
      }

      if (periodPredictions.docs.isNotEmpty) {
        allPeriods.addAll(periodPredictions.docs
            .map((e) => PeriodTrackerModel.fromJson(e.data()))
            .toList());
      }

      debugPrint('All periods: $allPeriods');
      return Right(allPeriods);
    } catch (e) {
      debugPrint('Error retrieving all periods: $e');
      return Left(
        Exception('Error retrieving all periods: $e'),
      );
    }
  }
}
