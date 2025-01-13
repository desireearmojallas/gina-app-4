import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
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
  final AppointmentModel appointment;
  const ConsultationOnGoingAppointmentScreen({
    super.key,
    required this.doctorUid,
    required this.chatroom,
    required this.appointment,
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
  AppointmentModel get appointment => widget.appointment;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    chatController.getChatRoom(
        chatController.generateRoomId(selectedDoctorUid), selectedDoctorUid);
    chatController.addListener(scrollToBottom);
    messageFN.addListener(scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building DoctorConsultationOnGoingAppointmentScreen...");
    return FutureBuilder<UserModel>(
      future: UserModel.fromUid(uid: selectedDoctorUid),
      builder:
          (BuildContext context, AsyncSnapshot<UserModel> selectedPatient) {
        if (!selectedPatient.hasData) {
          debugPrint("No patient data available...");
          return const Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CustomLoadingIndicator(),
                ),
              ],
            ),
          );
        }
        debugPrint("Patient data loaded successfully.");
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
                debugPrint(
                    'Snapshot Connection State: ${snapshot.connectionState}');
                debugPrint('Snapshot Data: ${snapshot.data}');
                debugPrint('Snapshot Error: ${snapshot.error}');

                if (snapshot.hasData) {
                  if (snapshot.data == 'null') {
                    debugPrint("No appointment available.");
                    return const ConsultationNoAppointmentScreen();
                  } else if (snapshot.data == 'success') {
                    debugPrint("Consultation data loaded successfully.");
                    return ChatConsultationBody(
                      messageFN: messageFN,
                      messageController: messageController,
                      context: context,
                      messages: MessageBody(
                        chatController: chatController,
                        scrollController: scrollController,
                        selectedDoctorUID: selectedDoctorUid,
                        isChatWaiting: isChatWaiting,
                      ),
                      send: send,
                      onChatWaitingChanged: (bool value) {
                        setState(() {
                          isChatWaiting = value;
                        });
                      },
                      appointment: appointment,
                    );
                  } else if (snapshot.data == 'empty') {
                    debugPrint(
                        "Chat room is empty. Showing first message body.");
                    return ChatConsultationBody(
                      messageFN: messageFN,
                      messageController: messageController,
                      context: context,
                      messages: const FirstMessageBody(),
                      send: firstSend,
                      onChatWaitingChanged: (bool value) {
                        setState(() {
                          isChatWaiting = value;
                        });
                      },
                      appointment: appointment,
                      disabled: true,
                    );
                  }
                } else if (snapshot.hasError) {
                  debugPrint(
                      "Error loading consultation data: ${snapshot.error}");
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                }

                debugPrint("Loading consultation data...");
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
    debugPrint("Scrolling to bottom...");
    await Future.delayed(const Duration(milliseconds: 150));
    if (scrollController.hasClients) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    } else {
      debugPrint("ScrollController has no clients...");
    }
  }

  send() {
    debugPrint('Sending message...');
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
          message: messageController.text.trim(),
          recipient: selectedDoctorUid,
          appointment: appointment);
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
}
