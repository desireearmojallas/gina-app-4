import 'package:flutter/material.dart';

List<String> generateTimeSlots(
    BuildContext context, int startHour, int endHour, bool isAfternoon) {
  final List<String> timeSlots = [];
  for (int hour = startHour; hour < endHour; hour++) {
    final startTime =
        TimeOfDay(hour: isAfternoon ? (hour % 12) + 12 : hour, minute: 0);
    final endTime = TimeOfDay(
        hour: isAfternoon ? ((hour % 12) + 1) + 12 : hour + 1, minute: 0);

    final formattedSlot =
        '${startTime.format(context)} - ${endTime.format(context)}';
    timeSlots.add(formattedSlot);
  }
  return timeSlots;
}
