import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:intl/intl.dart';

class AppointmentChatController with ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> chatStatusDecider({
    required String appointmentId,
  }) async {
    if (appointmentId.isEmpty) {
      return 'invalid';
    }

    final appointmentSnapshot =
        await firestore.collection('appointments').doc(appointmentId).get();
    final appointmentData = appointmentSnapshot.data();

    if (appointmentData != null) {
      final String appointmentDate = appointmentData['appointmentDate'];
      final String appointmentTime = appointmentData['appointmentTime'];
      final int appointmentStatus = appointmentData['appointmentStatus'];
      final int modeOfAppointment = appointmentData['modeOfAppointment'];
      debugPrint('Appointment status: $appointmentStatus');

      storedAppointmentTime = appointmentTime;

      final DateFormat dateFormat = DateFormat("MMMM d, yyyy h:mm a");

      try {
        final List<String> times = appointmentTime.split(' - ');

        if (times.length != 2) {
          throw const FormatException('Invalid time format');
        }

        final DateTime startTime =
            dateFormat.parse('$appointmentDate ${times[0]}');
        final DateTime endTime =
            dateFormat.parse('$appointmentDate ${times[1]}');

        //TODO: might make use of this preappointment time variable soon for notif
        final DateTime preAppointmentTime =
            startTime.subtract(const Duration(minutes: 15));

        final DateTime now = DateTime.now();

        debugPrint('Appointment status: $appointmentStatus');
        debugPrint('Mode of appointment: $modeOfAppointment');
        debugPrint('Current time: $now');
        debugPrint('Start time: $startTime');
        debugPrint('End time: $endTime');

        if (modeOfAppointment == 0) {
          if (appointmentStatus == 1) {
            if (now.isAfter(startTime) && now.isBefore(endTime)) {
              debugPrint('Returning canChat');
              return 'canChat';
            } else if (now.isAfter(preAppointmentTime) &&
                now.isBefore(startTime)) {
              debugPrint('Returning waitingForTheAppointment');
              return 'waitingForTheAppointment';
            } else if (now.isBefore(startTime)) {
              debugPrint('Returning appointmentNotStartedYet');
              return 'appointmentNotStartedYet';
            } else if (now.isAfter(endTime)) {
              debugPrint('Returning chatIsFinished');
              return 'chatIsFinished';
            }
          } else if (appointmentStatus == 2) {
            debugPrint('Returning chatIsFinished for status 2');
            return 'chatIsFinished';
          } else if (appointmentStatus == 5) {
            debugPrint('Returning missedAppointment for status 5');
            return 'missedAppointment';
          } else {
            debugPrint('Returning invalid for other status');
            return 'invalid';
          }
        } else if (modeOfAppointment == 1) {
          debugPrint('Returning faceToFaceAppointment');
          return 'faceToFaceAppointment';
        } else {
          debugPrint('Returning invalid for other mode');
          return 'invalid';
        }
      } catch (e) {
        // Handle the parsing error
        debugPrint('Error parsing date: $e');
        return 'invalid';
      }
    }
    return 'invalid';
  }
}
