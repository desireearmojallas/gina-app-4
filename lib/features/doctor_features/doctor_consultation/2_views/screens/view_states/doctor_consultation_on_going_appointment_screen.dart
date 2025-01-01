import 'package:flutter/material.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/widgets/doctor_chat_consultation_body.dart';

class DoctorConsultationOnGoingAppointmentScreen extends StatefulWidget {
  final String patientUid;
  final String chatroom;
  const DoctorConsultationOnGoingAppointmentScreen(
      {super.key, required this.patientUid, required this.chatroom});

  @override
  State<DoctorConsultationOnGoingAppointmentScreen> createState() =>
      _DoctorConsultationOnGoingAppointmentScreenState();
}

class _DoctorConsultationOnGoingAppointmentScreenState
    extends State<DoctorConsultationOnGoingAppointmentScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
// final DoctorChatMessageController chatController = DoctorChatMessageController()

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: true,
      // body: DoctorChatConsultationBody(),
      body: Center(
        child: Text('DoctorConsultationOnGoingAppointmentScreen'),
      ),
    );
  }
}
