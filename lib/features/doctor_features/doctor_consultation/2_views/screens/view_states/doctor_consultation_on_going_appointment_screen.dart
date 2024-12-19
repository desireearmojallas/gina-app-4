import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/1_controllers/doctor_chat_message_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/widgets/doctor_chat_consultation_body.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/widgets/doctor_chat_first_message_body.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/widgets/doctor_chat_message_body.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/consultation_loading_appointment.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/consultation_no_appointment.dart';

class DoctorConsultationOnGoingAppointmentScreen extends StatefulWidget {
  final String patientUid;
  final String chatroom;
  const DoctorConsultationOnGoingAppointmentScreen({
    super.key,
    required this.patientUid,
    required this.chatroom,
  });

  @override
  State<DoctorConsultationOnGoingAppointmentScreen> createState() =>
      _DoctorConsultationOnGoingAppointmentScreenStateState();
}

class _DoctorConsultationOnGoingAppointmentScreenStateState
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
    return FutureBuilder<UserModel>(
      future: UserModel.fromUid(uid: selectedPatientUid),
      builder:
          (BuildContext context, AsyncSnapshot<UserModel> selectedPatient) {
        if (!selectedPatient.hasData) {
          return const Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: CustomLoadingIndicator(),
                ),
              ],
            ),
          );
        }
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.splashPic),
                fit: BoxFit.cover,
              ),
            ),
            child: StreamBuilder(
              stream: chatController.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == 'null') {
                    return const ConsultationNoAppointmentScreen();
                  } else if (snapshot.data == 'success') {
                    return DoctorChatConsultationBody(
                      messageFN: messageFN,
                      messageController: messageController,
                      context: context,
                      messages: DoctorChatMessageBody(
                        chatController: chatController,
                        scrollController: scrollController,
                        selectedDoctorUID: selectedPatientUid,
                      ),
                      send: send,
                    );
                  } else if (snapshot.data == 'empty') {
                    return DoctorChatConsultationBody(
                      messageFN: messageFN,
                      messageController: messageController,
                      context: context,
                      messages: const DoctorChatFirstMessageBody(),
                      send: firstSend,
                    );
                  }
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                }
                return const ConsultationLoadingAppointmentState();
              },
            ),
          ),
        );
      },
    );
  }

  //------------------------------StateFul Widget Methods-------------------------------------
  scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
      );
    }
  }

  send() {
    messageFN.unfocus();
    final doctorConsultationBloc = context.read<DoctorConsultationBloc>();
    if (messageController.text.isNotEmpty) {
      doctorConsultationBloc.add(DoctorConsultationSendChatMessageEvent(
        message: messageController.text.trim(),
        recipient: selectedPatientUid,
      ));
      messageController.clear();
    }
  }

  firstSend() async {
    //since this ties to the stateful set state, it's better to leave this as it is,
    //to avoid any potential bugs when using the bloc pattern

    messageFN.unfocus();
    if (messageController.text.isNotEmpty) {
      var chatroom = chatController.sendFirstMessage(
        message: messageController.text.trim(),
        recipient: selectedPatientUid,
      );
      messageController.text = '';
      try {
        setState(() {
          chatController.initChatRoom(chatroom, selectedPatientUid);
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  void dispose() {
    messageFN.dispose();
    messageController.dispose();
    if (chatController.messages.isNotEmpty) {
      chatController.dispose();
    }
    super.dispose();
  }
}
