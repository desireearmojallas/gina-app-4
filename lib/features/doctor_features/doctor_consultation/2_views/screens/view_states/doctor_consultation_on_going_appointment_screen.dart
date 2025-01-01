import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/1_controllers/doctor_chat_message_controller.dart';
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
  final FocusNode messageFN = FocusNode();
  final ScrollController scrollController = ScrollController();
  final DoctorChatMessageController chatController =
      DoctorChatMessageController();

  String get selectedPatientUid => widget.patientUid;
  String get chatroom => widget.chatroom;
  UserModel? user;

  @override
  void initState() {
    chatController.getChatRoom(
        chatController.generateRoomId(selectedPatientUid), selectedPatientUid);
    chatController.addListener(scrollToBottom);
    messageFN.addListener(scrollToBottom);
    super.initState();
  }

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

  //------------------------------StateFul Widget Methods-------------------------------------
  scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (scrollController.hasClients) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    }
  }

  //! to be continued...
}
