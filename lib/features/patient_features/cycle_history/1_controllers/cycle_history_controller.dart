import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';

class CycleHistoryController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  User? currentPatient;
  FirebaseAuthException? error;
  bool working = false;

  CycleHistoryController() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentPatient = user;
    });
  }

  Future<int?> getAverageCycleLength() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentPatient!.uid)
          .collection('patientLogs')
          .orderBy('startDate')
          .get();

      if (snapshot.docs.length < 2) {
        return null; // Not enough logs to calculate cycle length
      }

      List<int> patientTotalCycleLength = [];
      DateTime? previousStartDate;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final startDateTimestamp = data['startDate'] as Timestamp;
        final DateTime startDate = startDateTimestamp.toDate();

        if (previousStartDate != null) {
          if (startDate != previousStartDate) {
            // Check for duplicate start dates
            final cycleLength = startDate.difference(previousStartDate).inDays;
            patientTotalCycleLength.add(cycleLength);
          }
        }
        previousStartDate = startDate;
      }

      final int updatedTotalCycleCount = patientTotalCycleLength.length;

      // Directly overwrite the patientTotalCycleLength and patientTotalCycleCount
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentPatient!.uid)
          .set({
        'patientTotalCycleLength': patientTotalCycleLength,
        'patientTotalCycleCount': updatedTotalCycleCount,
      }, SetOptions(merge: true));

      debugPrint('Updated patientTotalCycleLength: $patientTotalCycleLength');
      debugPrint('Updated patientTotalCycleCount: $updatedTotalCycleCount');

      // Calculate the average cycle length
      final totalCycleLengthFromFirebase =
          patientTotalCycleLength.fold(0, (acc, length) => acc + length);

      final averageCycleLength = updatedTotalCycleCount > 0
          ? totalCycleLengthFromFirebase ~/ updatedTotalCycleCount
          : null;

      debugPrint('Average cycle length: $averageCycleLength');

      return averageCycleLength;
    } catch (e) {
      debugPrint('Error getting average cycle length: $e');
      return null;
    }
  }

  Future<DateTime?> getLastPeriodDate() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentPatient!.uid)
          .collection('patientLogs')
          .where('startDate',
              isLessThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
          .orderBy('startDate', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final lastPeriodDate =
            snapshot.docs.first.data()['startDate'] as Timestamp;
        return lastPeriodDate.toDate();
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error getting last period date: $e');
      return null;
    }
  }

  Future<int?> getLastPeriodDuration() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentPatient!.uid)
          .collection('patientLogs')
          .where('startDate',
              isLessThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
          .orderBy('startDate', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final lastPeriodDoc = snapshot.docs.first.data();

        final startDate = (lastPeriodDoc['startDate'] as Timestamp).toDate();
        final endDate = (lastPeriodDoc['endDate'] as Timestamp).toDate();

        final periodDuration = endDate.difference(startDate).inDays + 1;
        return periodDuration;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error getting last period duration: $e');
      return null;
    }
  }

  Future<Either<Exception, List<PeriodTrackerModel>>> getCycleHistory() async {
    try {
      final menstrualPeriodCycle = await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentPatient!.uid)
          .collection('patientLogs')
          // .where('startDate',
          //     isLessThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
          .get();

      if (menstrualPeriodCycle.docs.isNotEmpty) {
        final allMenstrualPeriods = menstrualPeriodCycle.docs
            .map((e) => PeriodTrackerModel.fromFirestore(e))
            .toList();

        debugPrint('All menstrual periods: $allMenstrualPeriods');
        return Right(allMenstrualPeriods);
      } else {
        return const Right([]);
      }
    } catch (e) {
      debugPrint('Error retrieving menstrual periods: $e');
      return Left(
        Exception('Error retrieving menstrual periods: $e'),
      );
    }
  }

  Future<Either<Exception, List<PeriodTrackerModel>>>
      getMenstrualPeriods() async {
    try {
      final menstrualPeriodCycle = await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentPatient!.uid)
          .collection('patientLogs')
          .get();

      if (menstrualPeriodCycle.docs.isNotEmpty) {
        final allMenstrualPeriods = menstrualPeriodCycle.docs
            .map((e) => PeriodTrackerModel.fromFirestore(e))
            .toList();

        debugPrint('All menstrual periods: $allMenstrualPeriods');
        return Right(allMenstrualPeriods);
      } else {
        return const Right([]);
      }
    } catch (e) {
      debugPrint('Error retrieving menstrual periods: $e');
      return Left(
        Exception('Error retrieving menstrual periods: $e'),
      );
    }
  }

  Future<Either<Exception, List<PeriodTrackerModel>>> getAllPeriods() async {
    try {
      final menstrualPeriodCycle = await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentPatient!.uid)
          .collection('patientLogs')
          .get();

      final periodPredictions = await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentPatient!.uid)
          .collection('periodPredictions')
          .get();

      final defaultCycleBasedPredictions = await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentPatient!.uid)
          .collection('defaultCycleBasedPredictions')
          .get();

      List<PeriodTrackerModel> allPeriods = [];

      if (menstrualPeriodCycle.docs.isNotEmpty) {
        allPeriods.addAll(menstrualPeriodCycle.docs
            .map((e) => PeriodTrackerModel.fromFirestore(e))
            .toList());
      }

      if (periodPredictions.docs.isNotEmpty) {
        allPeriods.addAll(periodPredictions.docs
            .map((e) => PeriodTrackerModel.fromFirestore(e))
            .toList());
      }

      if (defaultCycleBasedPredictions.docs.isNotEmpty) {
        allPeriods.addAll(defaultCycleBasedPredictions.docs
            .map((e) => PeriodTrackerModel.fromFirestore(e))
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
