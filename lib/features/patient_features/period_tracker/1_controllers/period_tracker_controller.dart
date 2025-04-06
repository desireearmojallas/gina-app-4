import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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

  // Future<void> logMenstrualPeriod({
  //   required DateTime startDate,
  //   required DateTime endDate,
  //   required List<DateTime> periodDates,
  // }) async {
  //   try {
  //     List<Timestamp> periodDatesTimestamps =
  //         periodDates.map((date) => Timestamp.fromDate(date)).toList();

  //     QuerySnapshot logsSnapshot = await firestore
  //         .collection('patients')
  //         .doc(currentUser!.uid)
  //         .collection('patientLogs')
  //         .get();

  //     int cycleLength = 28; // Default value

  //     if (logsSnapshot.docs.isNotEmpty) {
  //       Map<String, dynamic> nearestLog = logsSnapshot.docs
  //           .map((doc) => doc.data() as Map<String, dynamic>)
  //           .reduce((curr, next) {
  //         DateTime currStartDate = (curr['startDate'] as Timestamp).toDate();
  //         DateTime nextStartDate = (next['startDate'] as Timestamp).toDate();

  //         int currDiff = (startDate.difference(currStartDate).inDays - 1).abs();
  //         int nextDiff = (startDate.difference(nextStartDate).inDays - 1).abs();

  //         return currDiff < nextDiff ? curr : next;
  //       });

  //       DateTime nearestStartDate =
  //           (nearestLog['startDate'] as Timestamp).toDate();
  //       cycleLength = (startDate.difference(nearestStartDate).inDays - 1).abs();

  //       DateTime nearestEndDate = (nearestLog['endDate'] as Timestamp).toDate();

  //       debugPrint('Nearest Log: $nearestLog');
  //       debugPrint('Nearest Log End Date: $nearestEndDate');
  //       debugPrint('Nearest Start Date: $nearestStartDate');
  //       debugPrint('Cycle Length: $cycleLength');
  //     }

  //     String snapId = firestore
  //         .collection('patients')
  //         .doc(currentUser!.uid)
  //         .collection('patientLogs')
  //         .doc()
  //         .id;

  //     await firestore
  //         .collection('patients')
  //         .doc(currentUser!.uid)
  //         .collection('patientLogs')
  //         .doc(snapId)
  //         .set({
  //       'periodDates': periodDatesTimestamps,
  //       'startDate': Timestamp.fromDate(startDate),
  //       'endDate': Timestamp.fromDate(endDate),
  //       'cycleLength': cycleLength,
  //       'isLog': true,
  //     });
  //     debugPrint('Menstrual Cycle logged successfully.');
  //   } catch (e) {
  //     debugPrint('Error logging menstrual cycle: $e');
  //   }
  // }

  //------------------------------------------------------------------------
  Future<void> logOrUpdateMenstrualPeriod({
    required List<DateTime> periodDates,
  }) async {
    try {
      debugPrint('Starting logOrUpdateMenstrualPeriod...');
      debugPrint('Received periodDates: $periodDates');

      List<List<DateTime>> newGroupedDates = _groupDatesByRange(periodDates);
      debugPrint('New grouped dates: $newGroupedDates');

      CollectionReference logsRef = FirebaseFirestore.instance
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('patientLogs');

      QuerySnapshot logsSnapshot = await logsRef.get();
      List<DocumentSnapshot> existingLogs = logsSnapshot.docs;
      debugPrint('Number of existing logs: ${existingLogs.length}');

      // Collect all stored dates from existing logs
      Set<DateTime> allStoredDates = {};
      for (var log in existingLogs) {
        var logData = log.data() as Map<String, dynamic>;
        List<DateTime> storedDates = (logData['periodDates'] as List<dynamic>)
            .map((date) => (date as Timestamp).toDate())
            .toList();
        allStoredDates.addAll(storedDates);
      }

      // Identify only new dates that haven't been logged yet
      List<DateTime> uniqueNewDates =
          periodDates.where((date) => !allStoredDates.contains(date)).toList();

      debugPrint('Unique new dates: $uniqueNewDates');

      bool anyUpdateOrAddition = false; // Flag to track updates or additions

      if (uniqueNewDates.isNotEmpty) {
        // Check if the new dates can be merged with existing logs
        for (List<DateTime> newGroup in newGroupedDates) {
          bool merged = false;
          List<DocumentSnapshot> logsToCheck =
              List.from(existingLogs); // Create a copy
          for (var log in logsToCheck) {
            var logData = log.data() as Map<String, dynamic>;
            List<DateTime> storedDates =
                (logData['periodDates'] as List<dynamic>)
                    .map((date) => (date as Timestamp).toDate())
                    .toList();

            DateTime storedStartDate =
                (logData['startDate'] as Timestamp).toDate();
            DateTime storedEndDate = (logData['endDate'] as Timestamp).toDate();

            DateTime newStartDate = newGroup.first;
            DateTime newEndDate = newGroup.last;

            if ((newStartDate.isAfter(
                        storedStartDate.subtract(const Duration(days: 1))) &&
                    newStartDate.isBefore(
                        storedEndDate.add(const Duration(days: 1)))) ||
                (newEndDate.isAfter(
                        storedStartDate.subtract(const Duration(days: 1))) &&
                    newEndDate.isBefore(
                        storedEndDate.add(const Duration(days: 1))))) {
              // Merge the dates and update the log
              storedDates.addAll(newGroup);
              storedDates = storedDates.toSet().toList(); // Remove duplicates
              storedDates.sort();

              await logsRef.doc(log.id).update({
                'periodDates': storedDates
                    .map((date) => Timestamp.fromDate(date))
                    .toList(),
                'startDate': Timestamp.fromDate(storedDates.first),
                'endDate': Timestamp.fromDate(storedDates.last),
              });

              debugPrint(
                  'Updated log document: ${log.id} with merged dates: $storedDates');
              merged = true;
              anyUpdateOrAddition = true; // Set the flag
              break; // Break the inner loop, go to the next group.
            }
          }
          if (!merged) {
            // Add a new log if no existing log could be merged
            int cycleLength = 28; // Default cycle length

            if (existingLogs.isNotEmpty) {
              // Calculate cycle length if there are existing logs
              List<DateTime> existingStartDates = existingLogs
                  .map((log) => (log.data()
                      as Map<String, dynamic>)['startDate'] as Timestamp)
                  .map((timestamp) => timestamp.toDate())
                  .toList();

              existingStartDates.sort();

              if (existingStartDates.isNotEmpty) {
                DateTime previousStartDate = existingStartDates.last;
                cycleLength =
                    newGroup.first.difference(previousStartDate).inDays.abs();
              }
            }

            await logsRef.add({
              'cycleLength': cycleLength,
              'startDate': newGroup.first,
              'endDate': newGroup.last,
              'periodDates':
                  newGroup.map((date) => Timestamp.fromDate(date)).toList(),
              'isLog': true,
            });

            debugPrint('New period log added with unique dates!');
            anyUpdateOrAddition = true; // Set the flag
          }
        }
      } else {
        debugPrint('No new dates to log.');
      }

      // Handle deletions
      bool deletionOccurred = false;
      for (var log in existingLogs) {
        var logData = log.data() as Map<String, dynamic>;
        List<DateTime> storedDates = (logData['periodDates'] as List<dynamic>)
            .map((date) => (date as Timestamp).toDate())
            .toList();

        List<DateTime> remainingDates =
            storedDates.where((date) => periodDates.contains(date)).toList();

        if (remainingDates.isEmpty) {
          // Delete the entire document if no dates remain
          await logsRef.doc(log.id).delete();
          debugPrint('Deleted log document: ${log.id}');
          deletionOccurred = true;
        } else if (!listEquals(storedDates, remainingDates)) {
          // Update document with remaining dates and start/end dates
          await logsRef.doc(log.id).update({
            'periodDates':
                remainingDates.map((date) => Timestamp.fromDate(date)).toList(),
            'startDate': Timestamp.fromDate(remainingDates.first),
            'endDate': Timestamp.fromDate(remainingDates.last),
          });
          debugPrint(
              'Updated log document: ${log.id} with remaining dates: $remainingDates');
          deletionOccurred = true;
        }
      }

      if (deletionOccurred || anyUpdateOrAddition) {
        // Recalculate cycle lengths for all logs
        logsSnapshot = await logsRef.get();
        existingLogs = logsSnapshot.docs;
        existingLogs.sort((a, b) =>
            (a.data() as Map<String, dynamic>)['startDate']
                .compareTo((b.data() as Map<String, dynamic>)['startDate']));

        for (int i = 0; i < existingLogs.length; i++) {
          DocumentSnapshot log = existingLogs[i];
          int newCycleLength = 28; // Default for the first log
          if (i > 0) {
            DateTime previousStartDate = (existingLogs[i - 1].data()
                    as Map<String, dynamic>)['startDate']
                .toDate();
            DateTime currentStartDate =
                (log.data() as Map<String, dynamic>)['startDate'].toDate();
            newCycleLength =
                currentStartDate.difference(previousStartDate).inDays.abs();
          }
          await logsRef.doc(log.id).update({'cycleLength': newCycleLength});
        }
      }

      // Check for redundant documents after merging
      logsSnapshot = await logsRef.get();
      existingLogs = logsSnapshot.docs;

      for (var log1 in existingLogs) {
        var logData1 = log1.data() as Map<String, dynamic>;
        List<DateTime> dates1 = (logData1['periodDates'] as List<dynamic>)
            .map((date) => (date as Timestamp).toDate())
            .toList();

        for (var log2 in existingLogs) {
          if (log1.id != log2.id) {
            var logData2 = log2.data() as Map<String, dynamic>;
            List<DateTime> dates2 = (logData2['periodDates'] as List<dynamic>)
                .map((date) => (date as Timestamp).toDate())
                .toList();

            if (dates2.every((date) => dates1.contains(date))) {
              // dates2 are completely contained within dates1, delete log2
              await logsRef.doc(log2.id).delete();
              debugPrint('Deleted redundant log document: ${log2.id}');
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error logging menstrual cycle: $e');
    }
  }

  bool listEquals(List<DateTime> list1, List<DateTime> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  //------------------------------------------------------------------------

  List<List<DateTime>> _groupDatesByRange(List<DateTime> dates) {
    List<List<DateTime>> groupedDates = [];
    List<DateTime> currentGroup = [];

    if (dates.isEmpty) return groupedDates;

    dates.sort();

    for (int i = 0; i < dates.length; i++) {
      if (currentGroup.isEmpty ||
          dates[i].difference(currentGroup.last).inDays <= 1) {
        currentGroup.add(dates[i]);
      } else {
        groupedDates.add(currentGroup);
        currentGroup = [dates[i]];
      }
    }

    if (currentGroup.isNotEmpty) {
      groupedDates.add(currentGroup);
    }

    return groupedDates;
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

  Future<Map<String, dynamic>> isThreeDaysBeforePrediction() async {
    try {
      final periodPredictionsCollection = firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('periodPredictions');

      final predictionsSnapshot = await periodPredictionsCollection.get();

      if (predictionsSnapshot.docs.isEmpty) {
        debugPrint('No period predictions found.');
        return {
          'isWithinRange': false,
          'predictedStartDate': null,
        };
      }

      // Get the nearest prediction
      final nearestPrediction = predictionsSnapshot.docs.first;
      final predictionData = nearestPrediction.data();
      final DateTime predictedStartDate =
          (predictionData['startDate'] as Timestamp).toDate();

      // Check if today is within the range of 3 days before and the predicted start date
      final DateTime today = DateTime.now();
      final DateTime threeDaysBefore =
          predictedStartDate.subtract(const Duration(days: 3));

      final bool isWithinRange = today.isAtSameMomentAs(threeDaysBefore) ||
          today.isAfter(threeDaysBefore) &&
              today.isBefore(predictedStartDate.add(const Duration(days: 1)));

      debugPrint('Today: $today');
      debugPrint('Predicted Start Date: $predictedStartDate');
      debugPrint('Three Days Before: $threeDaysBefore');
      debugPrint(
          'Is it within the range (3 days before to the predicted day)? $isWithinRange');

      return {
        'isWithinRange': isWithinRange,
        'predictedStartDate': predictedStartDate,
      };
    } catch (e) {
      debugPrint('Error checking if it is 3 days before prediction: $e');
      return {
        'isWithinRange': false,
        'predictedStartDate': null,
      };
    }
  }
}
