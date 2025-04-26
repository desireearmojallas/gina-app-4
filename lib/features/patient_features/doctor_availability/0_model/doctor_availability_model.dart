import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorAvailabilityModel extends Equatable {
  final List<int> days;
  final List<String> startTimes;
  final List<String> endTimes;
  final List<int> modeOfAppointment;
  final List<Map<String, dynamic>>? disabledTimeSlots;

  const DoctorAvailabilityModel({
    required this.days,
    required this.startTimes,
    required this.endTimes,
    required this.modeOfAppointment,
    this.disabledTimeSlots,
  });

  factory DoctorAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return DoctorAvailabilityModel(
      days: List<int>.from(json['days'] ?? []),
      startTimes: List<String>.from(json['startTimes'] ?? []),
      endTimes: List<String>.from(json['endTimes'] ?? []),
      modeOfAppointment: List<int>.from(json['modeOfAppointment'] ?? []),
      disabledTimeSlots: json['disabledTimeSlots'] != null
          ? List<Map<String, dynamic>>.from(json['disabledTimeSlots'])
          : null,
    );
  }

  factory DoctorAvailabilityModel.fromMap(Map<String, dynamic> data) {
    return DoctorAvailabilityModel(
      startTimes: List<String>.from(data['startTimes'] ?? []),
      endTimes: List<String>.from(data['endTimes'] ?? []),
      days: List<int>.from(data['days'] ?? []),
      modeOfAppointment: List<int>.from(data['modeOfAppointment'] ?? []),
      disabledTimeSlots: data['disabledTimeSlots'] != null
          ? List<Map<String, dynamic>>.from(data['disabledTimeSlots'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'days': days,
      'startTimes': startTimes,
      'endTimes': endTimes,
      'modeOfAppointment': modeOfAppointment,
      'disabledTimeSlots': disabledTimeSlots,
    };
  }

  @override
  List<Object> get props => [
        days,
        startTimes,
        endTimes,
        modeOfAppointment,
        disabledTimeSlots ?? [],
      ];

  bool isTimeSlotDisabled(int day, String startTime, String endTime,
      {DateTime? selectedDate}) {
    // First check if the slot is in the past for today
    if (selectedDate != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

      if (selectedDay.isAtSameMomentAs(today)) {
        // Parse the time string to get hours and minutes
        try {
          // Extract just the start time (remove the AM/PM indicator if needed)
          String timeStr = startTime.trim();
          if (timeStr.contains('-')) {
            timeStr = timeStr.split('-')[0].trim();
          }

          // Parse the time string
          String timeOnly = timeStr.split(' ')[0]; // Get just the time part
          String amPm = timeStr.split(' ')[1].toUpperCase(); // Get AM/PM part
          
          List<String> timeParts = timeOnly.split(':');
          int hour = int.parse(timeParts[0]);
          int minute = timeParts.length > 1 ? int.parse(timeParts[1]) : 0;
          
          // Handle AM/PM
          if (amPm == 'PM' && hour < 12) {
            hour += 12;
          } else if (amPm == 'AM' && hour == 12) {
            hour = 0;
          }

          // Create a DateTime object for the slot time on today's date
          final slotDateTime = DateTime(
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          );

          // Check if this time is before the current time
          if (slotDateTime.isBefore(now)) {
            debugPrint('Slot is in the past: $startTime on $selectedDate');
            return true;
          }
        } catch (e) {
          debugPrint('Error parsing time: $e');
          return false;
        }
      }
    }

    // Then check existing disabled slots logic
    if (disabledTimeSlots != null && disabledTimeSlots!.isNotEmpty && selectedDate != null) {
      for (var slot in disabledTimeSlots!) {
        // Check if the slot matches the day and time
        bool isMatchingSlot = slot['day'] == day &&
            slot['startTime'] == startTime &&
            slot['endTime'] == endTime;

        debugPrint('Checking slot: ${slot['startTime']} - ${slot['endTime']} on day ${slot['day']}');
        debugPrint('Against: $startTime - $endTime on day $day');
        debugPrint('Matching slot: $isMatchingSlot');

        if (!isMatchingSlot) continue;

        // If we have a disabledAt timestamp, check if it applies to the selected date
        if (slot['disabledAt'] != null) {
          final disabledAt = (slot['disabledAt'] as Timestamp).toDate();
          debugPrint('DisabledAt: $disabledAt');
          debugPrint('Selected date: $selectedDate');

          // Get the start of the week for both dates (Sunday = 0)
          final disabledWeekStart = disabledAt.subtract(Duration(days: disabledAt.weekday % 7));
          final selectedWeekStart = selectedDate.subtract(Duration(days: selectedDate.weekday % 7));

          // Reset to midnight for accurate comparison
          final disabledWeekStartMidnight = DateTime(
            disabledWeekStart.year,
            disabledWeekStart.month,
            disabledWeekStart.day,
          );
          final selectedWeekStartMidnight = DateTime(
            selectedWeekStart.year,
            selectedWeekStart.month,
            selectedWeekStart.day,
          );

          debugPrint('Disabled week start: $disabledWeekStartMidnight');
          debugPrint('Selected week start: $selectedWeekStartMidnight');

          // Compare the week starts to see if they're in the same week or future weeks
          if (selectedWeekStartMidnight.isAtSameMomentAs(disabledWeekStartMidnight) ||
              selectedWeekStartMidnight.isAfter(disabledWeekStartMidnight)) {
            debugPrint('Slot is disabled: Same or future week');
            return true;
          }
        } else {
          // If no disabledAt timestamp, consider it permanently disabled
          return true;
        }
      }
    }
    
    // If we reach here, the slot is not disabled
    return false;
  }
}
