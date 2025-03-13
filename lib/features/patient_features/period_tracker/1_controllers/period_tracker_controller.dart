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

  // Future<void> logOrUpdateMenstrualPeriod({
  //   required List<DateTime> periodDates,
  // }) async {
  //   try {
  //     debugPrint('Starting logOrUpdateMenstrualPeriod...');
  //     debugPrint('Received periodDates: $periodDates');

  //     List<List<DateTime>> newGroupedDates = _groupDatesByRange(periodDates);
  //     debugPrint('New grouped dates: $newGroupedDates');

  //     CollectionReference logsRef = FirebaseFirestore.instance
  //         .collection('patients')
  //         .doc(currentUser!.uid)
  //         .collection('patientLogs');

  //     QuerySnapshot logsSnapshot = await logsRef.get();
  //     List<DocumentSnapshot> existingLogs = logsSnapshot.docs;
  //     debugPrint('Number of existing logs: ${existingLogs.length}');

  //     // Fetch existing logs and their grouped dates
  //     Map<String, List<List<DateTime>>> logIdToGroupedDates = {};
  //     for (var doc in existingLogs) {
  //       String logId = doc.id;
  //       List<Timestamp> existingPeriodTimestamps =
  //           List<Timestamp>.from(doc['periodDates']);
  //       List<DateTime> existingPeriodDates =
  //           existingPeriodTimestamps.map((ts) => ts.toDate()).toList();
  //       logIdToGroupedDates[logId] = _groupDatesByRange(existingPeriodDates);
  //     }

  //     // Process each new group
  //     for (var newGroup in newGroupedDates) {
  //       bool groupHandled = false;

  //       // Check if new group fits into existing logs
  //       for (var logId in logIdToGroupedDates.keys) {
  //         List<List<DateTime>> existingGroupedDates =
  //             logIdToGroupedDates[logId]!;

  //         // Check if the new group can be merged with an existing group
  //         for (var existingGroup in existingGroupedDates) {
  //           if (_canMergeGroups(existingGroup, newGroup)) {
  //             // Merge and update
  //             List<DateTime> mergedDates = List.from(existingGroup)
  //               ..addAll(newGroup);
  //             mergedDates.sort();

  //             DateTime newStartDate = mergedDates
  //                 .reduce((curr, next) => curr.isBefore(next) ? curr : next);
  //             DateTime newEndDate = mergedDates
  //                 .reduce((curr, next) => curr.isAfter(next) ? curr : next);

  //             await logsRef.doc(logId).update({
  //               'periodDates': mergedDates
  //                   .map((date) => Timestamp.fromDate(date))
  //                   .toList(),
  //               'startDate': Timestamp.fromDate(newStartDate),
  //               'endDate': Timestamp.fromDate(newEndDate),
  //             });
  //             debugPrint('Merged and updated log ID: $logId');
  //             groupHandled = true;
  //             break;
  //           }
  //         }
  //         if (groupHandled) {
  //           break;
  //         }
  //       }

  //       // If no merge was possible, create a new log
  //       if (!groupHandled) {
  //         if (newGroup.isNotEmpty) {
  //           DateTime startDate = newGroup
  //               .reduce((curr, next) => curr.isBefore(next) ? curr : next);
  //           DateTime endDate = newGroup
  //               .reduce((curr, next) => curr.isAfter(next) ? curr : next);

  //           String snapId = logsRef.doc().id;
  //           await logsRef.doc(snapId).set({
  //             'periodDates':
  //                 newGroup.map((date) => Timestamp.fromDate(date)).toList(),
  //             'startDate': Timestamp.fromDate(startDate),
  //             'endDate': Timestamp.fromDate(endDate),
  //             'cycleLength': 28,
  //             'isLog': true,
  //           });
  //           debugPrint('Created new log ID: $snapId');
  //         }
  //       }
  //     }

  //     // Final cleanup: Remove empty logs
  //     QuerySnapshot finalLogsSnapshot = await logsRef.get();
  //     for (var doc in finalLogsSnapshot.docs) {
  //       List<Timestamp> periodDatesTimestamps =
  //           List<Timestamp>.from(doc['periodDates']);
  //       if (periodDatesTimestamps.isEmpty) {
  //         debugPrint('Deleting empty log ID: ${doc.id}');
  //         await logsRef.doc(doc.id).delete();
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint('Error logging menstrual cycle: $e');
  //   }
  // }

  // List<List<DateTime>> _groupDatesByRange(List<DateTime> dates) {
  //   // Implement your date grouping logic here
  //   dates.sort();
  //   List<List<DateTime>> groupedDates = [];
  //   if (dates.isEmpty) return groupedDates;
  //   List<DateTime> currentGroup = [dates.first];
  //   for (int i = 1; i < dates.length; i++) {
  //     if (dates[i].difference(currentGroup.last).inDays <= 1) {
  //       currentGroup.add(dates[i]);
  //     } else {
  //       groupedDates.add(currentGroup);
  //       currentGroup = [dates[i]];
  //     }
  //   }
  //   groupedDates.add(currentGroup);
  //   return groupedDates;
  // }

  // bool _canMergeGroups(List<DateTime> existingGroup, List<DateTime> newGroup) {
  //   // Check if the new group is adjacent to the existing group
  //   DateTime existingMax =
  //       existingGroup.reduce((curr, next) => curr.isAfter(next) ? curr : next);
  //   DateTime newMin =
  //       newGroup.reduce((curr, next) => curr.isBefore(next) ? curr : next);
  //   DateTime existingMin =
  //       existingGroup.reduce((curr, next) => curr.isBefore(next) ? curr : next);
  //   DateTime newMax =
  //       newGroup.reduce((curr, next) => curr.isAfter(next) ? curr : next);

  //   if (existingMax.difference(newMin).inDays <= 1 ||
  //       newMax.difference(existingMin).inDays <= 1) {
  //     return true;
  //   }
  //   return false;
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

      if (uniqueNewDates.isNotEmpty) {
        // Add a new log only if there are new unique dates
        await logsRef.add({
          'cycleLength': 28,
          'startDate': uniqueNewDates.first,
          'endDate': uniqueNewDates.last,
          'periodDates': uniqueNewDates,
          'isLog': true,
        });

        debugPrint('New period log added with unique dates!');
      } else {
        debugPrint('No new dates to log.');
      }

      // Handle deletions
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
        } else if (!listEquals(storedDates, remainingDates)) {
          // Update document with remaining dates
          await logsRef.doc(log.id).update({'periodDates': remainingDates});
          debugPrint(
              'Updated log document: ${log.id} with remaining dates: $remainingDates');
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
}
