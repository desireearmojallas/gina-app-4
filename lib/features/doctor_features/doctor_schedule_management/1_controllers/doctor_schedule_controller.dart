import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/doctor_features/doctor_schedule_management/0_models/doctor_schedule_management.dart';

class DoctorScheduleController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  User? currentUser;
  FirebaseAuthException? error;
  bool working = false;

  DoctorScheduleController() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentUser = user;
      notifyListeners();
    });
  }

  Future<Either<Exception, ScheduleModel>> getDoctorSchedule() async {
    try {
      final doctorScheduleDoc =
          await firestore.collection('doctors').doc(currentUser!.uid).get();

      final data = doctorScheduleDoc.data();
      if (data != null) {
        final scheduleData = data['schedule'] ?? {};
        return Right(ScheduleModel.fromJson({
          'days': scheduleData['days'],
          'startTimes': scheduleData['startTimes'],
          'endTimes': scheduleData['endTimes'],
          'modeOfAppointment': scheduleData['modeOfAppointment'],
          'name': data['name'],
          'medicalSpecialty': data['medicalSpecialty'],
          'officeAddress': data['officeAddress'],
          'disabledTimeSlots': scheduleData['disabledTimeSlots'],
        }));
      } else {
        return Left(Exception('No schedule found'));
      }
    } catch (e) {
      debugPrint('Error retrieving schedule: $e');
      return Left(
        Exception('Error retrieving schedule: $e'),
      );
    }
  }

  Future<Either<Exception, ScheduleModel>> toggleTimeSlot({
    required int day,
    required String startTime,
    required String endTime,
    required bool disable,
    required ScheduleModel currentSchedule,
  }) async {
    try {
      final docRef = firestore.collection('doctors').doc(currentUser!.uid);

      // Create a copy of the current disabled time slots or initialize an empty list
      List<Map<String, dynamic>> updatedDisabledSlots =
          List<Map<String, dynamic>>.from(
              currentSchedule.disabledTimeSlots ?? []);

      if (disable) {
        // Check if this slot is already disabled to avoid duplicates
        final existingSlotIndex = updatedDisabledSlots.indexWhere((slot) =>
            slot['day'] == day &&
            slot['startTime'] == startTime &&
            slot['endTime'] == endTime);

        if (existingSlotIndex == -1) {
          // Add the time slot to disabled slots with current timestamp
          updatedDisabledSlots.add({
            'day': day,
            'startTime': startTime,
            'endTime': endTime,
            'disabledAt': Timestamp.now(),
            // Don't include isPermanent field for now
          });
        }
      } else {
        // Remove the time slot from disabled slots
        updatedDisabledSlots.removeWhere((slot) =>
            slot['day'] == day &&
            slot['startTime'] == startTime &&
            slot['endTime'] == endTime);
      }

      debugPrint(
          'Disabled slots to save: ${updatedDisabledSlots.map((s) => "${s['day']}-${s['startTime']}-${s['endTime']}").join(", ")}');

      final updatedSchedule = currentSchedule.copyWith(
        disabledTimeSlots: updatedDisabledSlots,
      );

      // Update Firestore
      await docRef.update({
        'schedule.disabledTimeSlots': updatedDisabledSlots,
      }).then((_) => debugPrint('Firebase update completed'));

      return Right(updatedSchedule);
    } catch (e) {
      debugPrint('Error toggling time slot: $e');
      return Left(Exception('Error toggling time slot: $e'));
    }
  }

  // Updated cleanup method that works with existing data structure
  Future<void> cleanupExpiredDisabledSlots() async {
    try {
      final result = await getDoctorSchedule();
      result.fold(
        (error) => null,
        (schedule) async {
          if (schedule.disabledTimeSlots == null ||
              schedule.disabledTimeSlots!.isEmpty) return;

          final now = DateTime.now();
          // Calculate date 1 week ago
          final oneWeekAgo = now.subtract(const Duration(days: 7));

          List<Map<String, dynamic>> currentDisabledSlots =
              List<Map<String, dynamic>>.from(schedule.disabledTimeSlots!);

          // Keep track of removed slots count
          int removedCount = 0;
          List<Map<String, dynamic>> slotsToKeep = [];

          // Process each slot individually
          for (var slot in currentDisabledSlots) {
            // Keep the slot if it doesn't have a timestamp
            // (these are likely manually configured persistent slots)
            if (slot['disabledAt'] == null) {
              slotsToKeep.add(slot);
              continue;
            }

            // For slots with timestamps, only keep those less than a week old
            final disabledAt = (slot['disabledAt'] as Timestamp).toDate();
            if (!disabledAt.isBefore(oneWeekAgo)) {
              slotsToKeep.add(slot);
            } else {
              removedCount++;
            }
          }

          // Only update if we actually removed something
          if (removedCount > 0) {
            await firestore.collection('doctors').doc(currentUser!.uid).update({
              'schedule.disabledTimeSlots': slotsToKeep,
            });
            debugPrint('Cleaned up $removedCount expired slots');
          } else {
            debugPrint('No expired slots to remove');
          }
        },
      );
    } catch (e) {
      debugPrint('Error cleaning up expired disabled slots: $e');
    }
  }
}
