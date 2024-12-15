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
      List<Timestamp> periodDatesTimestamps =
          periodDates.map((date) => Timestamp.fromDate(date)).toList();
      QuerySnapshot logsSnapshot = await firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('patientLogs')
          .get();

      int cycleLength = 28; // default value

      if (logsSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> nearestLog = logsSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .reduce((current, next) {
          DateTime currentStartDate = current['startDate'].toDate();
          DateTime nextStartDate = next['startDate'].toDate();

          int currentDiff =
              (startDate.difference(currentStartDate).inDays - 1).abs();
          int nextDiff = (startDate.difference(nextStartDate).inDays - 1).abs();

          return currentDiff < nextDiff ? current : next;
        });

        DateTime nearestStartDate = nearestLog['startDate'].toDate();
        cycleLength = (startDate.difference(nearestStartDate).inDays - 1).abs();

        DateTime nearestEndDate = nearestLog['endDate'].toDate();

        //debug

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
        'startDate': startDate,
        'endDate': endDate,
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
      final snapshot = await firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('patientLogs')
          .orderBy('startDate')
          .get();

      int totalCycleLength = 0;
      int totalCount = 0;
      DateTime? previousStartDate;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final startDate = data['startDate'] as Timestamp;
        final DateTime date = startDate.toDate();

        if (previousStartDate != null) {
          // final cycleLength = date.difference(previousStartDate).inDays + 1;
          final cycleLength = date.difference(previousStartDate).inDays;
          totalCycleLength += cycleLength;
          totalCount++;
        }
        previousStartDate = date;
      }

      if (totalCount == 0) {
        return null;
      }

      final averageCycleLength = totalCycleLength ~/ totalCount;

      debugPrint('Average cycle length: $averageCycleLength');

      return averageCycleLength;
    } catch (e) {
      debugPrint('Error getting average cycle length: $e');
      return null;
    }
  }

  List<DateTime> getDatesBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> dates = [];

    for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }
    return dates;
  }

  Future<void> predictNext12PeriodsWithAvgCycleLength() async {
    try {
      QuerySnapshot logsSnapshot = await firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('patientLogs')
          .orderBy('endDate', descending: true)
          .get();

      if (logsSnapshot.docs.isEmpty) {
        debugPrint('No menstrual cycle data logged yet');
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

      for (var i = 0; i <= 12; i++) {
        DateTime nextStartDate =
            nearestStartDate.add(Duration(days: i * averagePeriodCycleInDays));

        DateTime nextEndDate = nextStartDate.add(Duration(days: periodLength));

        await firestore
            .collection('patients')
            .doc(currentUser!.uid)
            .collection('periodPredictions')
            .doc('menstrualDate_$i')
            .set({
          'startDate': nextStartDate,
          'endDate': nextEndDate,
          'periodDatesPredictions': getDatesBetween(nextStartDate, nextEndDate),
          'cycleLength': getTheAverageCycleLength,
          'isLog': false,
        });

        debugPrint('Menstrual cycle $i predicted successfully.');
      }
    } catch (e) {
      debugPrint('Error predicting menstrual cycles: $e');
    }
  }

  Future<void> predictNext12PeriodsWith28DefaultLength() async {
    try {
      QuerySnapshot logsSnapshot = await firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('patientLogs')
          .orderBy('endDate', descending: true)
          .get();

      if (logsSnapshot.docs.isEmpty) {
        debugPrint('No menstrual cycle data logged yet');
        return;
      }

      DocumentSnapshot nearestLog = logsSnapshot.docs.first;

      DateTime nearestStartDate =
          (nearestLog.data() as Map)['startDate'].toDate();

      DateTime nearestEndDate =
          (nearestLog.data() as Map)['startDate'].toDate();

      int periodLength = nearestEndDate.difference(nearestStartDate).inDays;

      const defaultCycleLength = 28;

      debugPrint('Default period length: $defaultCycleLength');

      for (var i = 0; i <= 12; i++) {
        DateTime nextStartDate =
            nearestStartDate.add(Duration(days: i * defaultCycleLength));

        DateTime nextEndDate = nextStartDate.add(Duration(days: periodLength));

        await firestore
            .collection('patients')
            .doc(currentUser!.uid)
            .collection('28dayPeriodPredictions')
            .doc('menstrualDate_$i')
            .set({
          'startDate': nextStartDate,
          'endDate': nextEndDate,
          'periodDatesPredictions': getDatesBetween(nextStartDate, nextEndDate),
          'cycleLength': defaultCycleLength,
          'isLog': false,
        });

        debugPrint('Menstrual 28 day cycle $i predicted successfully.');
      }
    } catch (e) {
      debugPrint('Error predicting menstrual cycles: $e');
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
            .map((e) => PeriodTrackerModel.fromJson(e.data()))
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

  //! Add here the day before the period starts to notify user using alert dialog
  //TODO: Add the day before the period starts to notify user using alert dialog

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

  Future<Either<Exception, List<PeriodTrackerModel>>>
      getAllPeriodsWith28DaysPredictions() async {
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

      final default28DayPeriodPredictions = await firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('28dayPeriodPredictions')
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

      if (default28DayPeriodPredictions.docs.isNotEmpty) {
        allPeriods.addAll(default28DayPeriodPredictions.docs
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
