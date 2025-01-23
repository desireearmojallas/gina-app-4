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
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/consultation_loading_appointment.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/consultation_no_appointment.dart';

class DoctorConsultationOnGoingAppointmentScreen extends StatefulWidget {
  final String patientUid;
  final String chatroom;
  final AppointmentModel appointment;
  const DoctorConsultationOnGoingAppointmentScreen({
    super.key,
    required this.patientUid,
    required this.chatroom,
    required this.appointment,
  });

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
  AppointmentModel get appointment => widget.appointment;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    debugPrint("Initializing DoctorConsultationOnGoingAppointmentScreen...");
    chatController.getChatRoom(
        chatController.generateRoomId(selectedPatientUid), selectedPatientUid);
    chatController.addListener(scrollToBottom);
    messageFN.addListener(scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building DoctorConsultationOnGoingAppointmentScreen...");
    return FutureBuilder<UserModel>(
      future: UserModel.fromUid(uid: selectedPatientUid),
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
                    return DoctorChatConsultationBody(
                      messageFN: messageFN,
                      messageController: messageController,
                      context: context,
                      messages: DoctorChatMessageBody(
                        chatController: chatController,
                        scrollController: scrollController,
                        selectedDoctorUID: selectedPatientUid,
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
                    return DoctorChatConsultationBody(
                      messageFN: messageFN,
                      messageController: messageController,
                      context: context,
                      messages: const DoctorChatFirstMessageBody(),
                      send: firstSend,
                      onChatWaitingChanged: (bool value) {
                        setState(() {
                          isChatWaiting = value;
                        });
                      },
                      appointment: appointment,
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
          duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
    } else {
      debugPrint("ScrollController has no clients.");
    }
  }

  send() {
    debugPrint("Sending message...");
    messageFN.unfocus();
    final doctorConsultationBloc = context.read<DoctorConsultationBloc>();
    if (messageController.text.isNotEmpty) {
      doctorConsultationBloc.add(DoctorConsultationSendChatMessageEvent(
        message: messageController.text.trim(),
        recipient: selectedPatientUid,
      ));
      debugPrint("Message sent: ${messageController.text.trim()}");
      messageController.clear();
    } else {
      debugPrint("Message controller is empty. Nothing to send.");
    }
  }

  firstSend() async {
    debugPrint("Sending first message...");
    messageFN.unfocus();
    if (messageController.text.isNotEmpty) {
      var chatroom = chatController.sendFirstMessage(
        message: messageController.text.trim(),
        recipient: selectedPatientUid,
        appointment: selectedPatientAppointmentModel!,
      );
      debugPrint("First message sent. Chatroom ID: $chatroom");
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
    debugPrint('dispose called');
    messageFN.removeListener(scrollToBottom);
    chatController.removeListener(scrollToBottom);
    messageFN.dispose();
    messageController.dispose();
    chatController.dispose();
    super.dispose();
  }
}
