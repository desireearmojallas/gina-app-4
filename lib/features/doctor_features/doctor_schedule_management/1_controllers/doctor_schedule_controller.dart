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

      // Remove expired disabled slots (older than current week)
      final now = DateTime.now();
      var startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      startOfWeek =
          startOfWeek.subtract(const Duration(hours: 1)); // Reset to midnight

      updatedDisabledSlots.removeWhere((slot) {
        if (slot['disabledAt'] == null) return false;
        final disabledAt = (slot['disabledAt'] as Timestamp).toDate();
        return disabledAt.isBefore(startOfWeek);
      });

      if (disable) {
        // Add the time slot to disabled slots with current timestamp
        updatedDisabledSlots.add({
          'day': day,
          'startTime': startTime,
          'endTime': endTime,
          'disabledAt': Timestamp.now(),
        });
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

      debugPrint(
          'Disabled slots in new state: ${updatedSchedule.disabledTimeSlots?.map((s) => "${s['day']}-${s['startTime']}-${s['endTime']}").join(", ")}');

      // Update Firestore
      await docRef.update({
        'schedule.disabledTimeSlots': updatedDisabledSlots,
      }).then((_) => debugPrint('Firebase update completed'));

      // Return updated schedule model
      // return Right(currentSchedule.copyWith(
      //   disabledTimeSlots: updatedDisabledSlots,
      // ));

      return Right(updatedSchedule);
    } catch (e) {
      debugPrint('Error toggling time slot: $e');
      return Left(Exception('Error toggling time slot: $e'));
    }
  }

  // Helper method to clean up expired disabled slots
  Future<void> cleanupExpiredDisabledSlots() async {
    try {
      final result = await getDoctorSchedule();
      result.fold(
        (error) => null,
        (schedule) async {
          if (schedule.disabledTimeSlots == null) return;

          final now = DateTime.now();
          var startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          startOfWeek = startOfWeek
              .subtract(const Duration(hours: 1)); // Reset to midnight

          List<Map<String, dynamic>> currentDisabledSlots =
              List<Map<String, dynamic>>.from(schedule.disabledTimeSlots!);

          currentDisabledSlots.removeWhere((slot) {
            if (slot['disabledAt'] == null) return false;
            final disabledAt = (slot['disabledAt'] as Timestamp).toDate();
            return disabledAt.isBefore(startOfWeek);
          });

          await firestore.collection('doctors').doc(currentUser!.uid).update({
            'schedule.disabledTimeSlots': currentDisabledSlots,
          });
        },
      );
    } catch (e) {
      debugPrint('Error cleaning up expired disabled slots: $e');
    }
  }
}
