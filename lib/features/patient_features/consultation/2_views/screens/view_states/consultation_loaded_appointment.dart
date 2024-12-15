import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/1_controllers/chat_message_controllers.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/consultation_loading_appointment.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/consultation_no_appointment.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/widgets/chat_consultation_body.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/widgets/chat_first_message_body.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/widgets/chat_message_body.dart';

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
  final TextEditingController messageController = TextEditingController();
  final FocusNode messageFN = FocusNode();
  final ScrollController scrollController = ScrollController();
  final ChatMessageController chatController = ChatMessageController();

  String get selectedDoctorUid => widget.doctorUid;
  String get chatroom => widget.chatroom;
  UserModel? user;

  @override
  void initState() {
    chatController.getChatRoom(
        chatController.generateRoomId(selectedDoctorUid), selectedDoctorUid);
    chatController.addListener(scrollToBottom);
    messageFN.addListener(scrollToBottom);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DoctorModel>(
        future: DoctorModel.fromUid(uid: selectedDoctorUid),
        builder:
            (BuildContext context, AsyncSnapshot<DoctorModel> selectedDoctor) {
          if (!selectedDoctor.hasData) {
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
                    if (snapshot.data == "null") {
                      return const ConsultationNoAppointmentScreen();
                    } else if (snapshot.data == "success") {
                      return ChatConsultationBody(
                        messageFN: messageFN,
                        messageController: messageController,
                        context: context,
                        messages: ChatMessageBody(
                            chatController: chatController,
                            scrollController: scrollController,
                            selectedDoctorUID: selectedDoctorUid),
                        send: send,
                      );
                    } else if (snapshot.data == 'empty') {
                      return ChatConsultationBody(
                        messageFN: messageFN,
                        messageController: messageController,
                        context: context,
                        messages: const FirstMessageBody(),
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
        });
  }
  //------------------------------StateFul Widget Methods-------------------------------------

  scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (scrollController.hasClients) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          curve: Curves.easeIn, duration: const Duration(milliseconds: 250));
    }
  }

  send() {
    messageFN.unfocus();
    final consultationBloc = context.read<ConsultationBloc>();
    if (messageController.text.isNotEmpty) {
      consultationBloc.add(SendChatMessageEvent(
          message: messageController.text.trim(),
          recipient: selectedDoctorUid));
      messageController.clear();
    }
  }

  firstSend() async {
    //since this ties to the stateful set state, it's better to leave this as it is,
    //to avoid any potential bugs when using the bloc pattern
    messageFN.unfocus();
    if (messageController.text.isNotEmpty) {
      var chatroom = chatController.sendFirstMessage(
          message: messageController.text.trim(), recipient: selectedDoctorUid);
      messageController.text = '';
      try {
        setState(() {
          chatController.initChatRoom(chatroom, selectedDoctorUid);
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
