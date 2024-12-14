import 'package:flutter/material.dart';

class ConsultationOnGoingAppointmentScreen extends StatefulWidget {
  final String doctorUid;
  final String chatroom;
  const ConsultationOnGoingAppointmentScreen({
    super.key,
    required this.doctorUid,
    required this.chatroom,
  });

  @override
  State<ConsultationOnGoingAppointmentScreen> createState() =>
      _ConsultationOnGoingAppointmentScreenState();
}

class _ConsultationOnGoingAppointmentScreenState
    extends State<ConsultationOnGoingAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
