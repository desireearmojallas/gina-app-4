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

        if (appointmentStatus == 1) {
          if (modeOfAppointment == 0) {
            if (now.isAfter(startTime) && now.isBefore(endTime)) {
              return 'canChat';
            } else if (now.isAfter(preAppointmentTime) &&
                now.isBefore(startTime)) {
              return 'waitingForTheAppointment';
            } else if (now.isBefore(startTime)) {
              return 'appointmentNotStartedYet';
            } else if (now.isAfter(endTime)) {
              return 'chatIsFinished';
            }
          } else if (modeOfAppointment == 1) {
            return 'faceToFaceAppointment';
          } else {
            return 'invalid';
          }
        } else {
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
