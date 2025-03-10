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

  Future<void> logMenstrualPeriod({
    required DateTime startDate,
    required DateTime endDate,
    required List<DateTime> periodDates,
  }) async {
    try {
      List<Timestamp> periodDatesTimestamps =
          periodDates.map((date) => Timestamp.fromDate(date)).toList();

      QuerySnapshot logsSnapshot = await firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('patientLogs')
          .get();

      int cycleLength = 28; // Default value

      if (logsSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> nearestLog = logsSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .reduce((curr, next) {
          DateTime currStartDate = (curr['startDate'] as Timestamp).toDate();
          DateTime nextStartDate = (next['startDate'] as Timestamp).toDate();

          int currDiff = (startDate.difference(currStartDate).inDays - 1).abs();
          int nextDiff = (startDate.difference(nextStartDate).inDays - 1).abs();

          return currDiff < nextDiff ? curr : next;
        });

        DateTime nearestStartDate =
            (nearestLog['startDate'] as Timestamp).toDate();
        cycleLength = (startDate.difference(nearestStartDate).inDays - 1).abs();

        DateTime nearestEndDate = (nearestLog['endDate'] as Timestamp).toDate();

        debugPrint('Nearest Log: $nearestLog');
        debugPrint('Nearest Log End Date: $nearestEndDate');
        debugPrint('Nearest Start Date: $nearestStartDate');
        debugPrint('Cycle Length: $cycleLength');
      }

      String snapId = firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('patientLogs')
          .doc()
          .id;

      await firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('patientLogs')
          .doc(snapId)
          .set({
        'periodDates': periodDatesTimestamps,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'cycleLength': cycleLength,
        'isLog': true,
      });
      debugPrint('Menstrual Cycle logged successfully.');
    } catch (e) {
      debugPrint('Error logging menstrual cycle: $e');
    }
  }

  Future<int?> getAverageCycleLength() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentUser!.uid)
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
          .doc(currentUser!.uid)
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

  List<DateTime> getDatesBetween(DateTime startDate, int length) {
    List<DateTime> dates = [];
    for (int i = 0; i < length; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }
    return dates;
  }

  Future<void> predictNext12Periods() async {
    try {
      QuerySnapshot logsSnapshot = await firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('patientLogs')
          .orderBy('endDate', descending: true)
          .get();

      if (logsSnapshot.docs.isEmpty) {
        debugPrint('No menstrual cycle data logged yet.');
        return;
      }

      DocumentSnapshot nearestLog = logsSnapshot.docs.first;

      DateTime nearestStartDate =
          (nearestLog.data() as Map)['startDate'].toDate();

      DateTime nearestEndDate = (nearestLog.data() as Map)['endDate'].toDate();

      int periodLength = nearestEndDate.difference(nearestStartDate).inDays;

      final getTheAverageCycleLength = await getAverageCycleLength();
      final averagePeriodCycleInDays = getTheAverageCycleLength ?? 28;

      debugPrint('Average period cycle in days: $averagePeriodCycleInDays');

      // Clear existing predictions
      final periodPredictionsCollection = firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('periodPredictions');
      final existingPredictions = await periodPredictionsCollection.get();
      for (var doc in existingPredictions.docs) {
        await doc.reference.delete();
      }

      for (int i = 1; i <= 12; i++) {
        DateTime nextStartDate =
            nearestStartDate.add(Duration(days: i * averagePeriodCycleInDays));
        DateTime nextEndDate = nextStartDate.add(Duration(days: periodLength));

        await periodPredictionsCollection.doc('menstrualDate_$i').set({
          'startDate': Timestamp.fromDate(nextStartDate),
          'endDate': Timestamp.fromDate(nextEndDate),
          'averageBasedPredictionDates':
              getDatesBetween(nextStartDate, periodLength + 1)
                  .map((date) => Timestamp.fromDate(date))
                  .toList(),
          'cycleLength': getTheAverageCycleLength,
          'isLog': false,
        });

        debugPrint('Menstrual cycle $i predicted successfully.');
      }
    } catch (e) {
      debugPrint('Error predicting menstrual cycles: $e');
    }
  }

  Future<void> predictNext12Periods28Default() async {
    try {
      QuerySnapshot logsSnapshot = await firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('patientLogs')
          .orderBy('endDate', descending: true)
          .get();

      if (logsSnapshot.docs.isEmpty) {
        debugPrint('No menstrual cycle data logged yet.');
        return;
      }

      DocumentSnapshot nearestLog = logsSnapshot.docs.first;

      DateTime nearestStartDate =
          (nearestLog.data() as Map)['startDate'].toDate();

      DateTime nearestEndDate = (nearestLog.data() as Map)['endDate'].toDate();

      int periodLength = nearestEndDate.difference(nearestStartDate).inDays;

      const int averagePeriodCycleInDays = 28;

      debugPrint(
          'Default average period cycle in days: $averagePeriodCycleInDays');

      // Clear existing predictions
      final defaultCycleBasedPredictionsCollection = firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('defaultCycleBasedPredictions');
      final existingPredictions =
          await defaultCycleBasedPredictionsCollection.get();
      for (var doc in existingPredictions.docs) {
        await doc.reference.delete();
      }

      for (int i = 1; i <= 12; i++) {
        DateTime nextStartDate =
            nearestStartDate.add(Duration(days: i * averagePeriodCycleInDays));
        DateTime nextEndDate = nextStartDate.add(Duration(days: periodLength));

        await defaultCycleBasedPredictionsCollection
            .doc('menstrualDate28_$i')
            .set({
          'startDate': Timestamp.fromDate(nextStartDate),
          'endDate': Timestamp.fromDate(nextEndDate),
          'day28PredictionDates':
              getDatesBetween(nextStartDate, periodLength + 1)
                  .map((date) => Timestamp.fromDate(date))
                  .toList(),
          'cycleLength': averagePeriodCycleInDays,
          'isLog': false,
        });

        debugPrint(
            'Menstrual cycle $i predicted successfully with default 28-day cycle.');
      }
    } catch (e) {
      debugPrint(
          'Error predicting menstrual cycles with default 28-day cycle: $e');
    }
  }

  Future<Either<Exception, List<PeriodTrackerModel>>>
      getMenstrualPeriods() async {
    try {
      final menstrualPeriodCycle = await firestore
          .collection('patients')
          .doc(currentUser!.uid)
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
      final menstrualPeriodCycle = await firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('patientLogs')
          .get();

      final periodPredictions = await firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('periodPredictions')
          .get();

      final defaultCycleBasedPredictions = await firestore
          .collection('patients')
          .doc(currentUser!.uid)
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
