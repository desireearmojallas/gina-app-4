import 'dart:async';

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
  bool isDisabled = true;

  @override
  void initState() {
    debugPrint('InitState - Initial isDisabled value: $isDisabled');
    super.initState();

    // Set up chatroom
    chatController.getChatRoom(
        chatController.generateRoomId(selectedDoctorUid), selectedDoctorUid);

    // Start polling for new chatroom creation
    Future.delayed(const Duration(milliseconds: 500), () {
      startChatroomPolling();
    });

    bool initialAppointmentStatus = isAppointmentFinished;
    debugPrint('Initial appointment status: $initialAppointmentStatus');

    chatController.addListener(() {
      if (isAppointmentFinished && mounted && !initialAppointmentStatus) {
        debugPrint('Appointment finished, closing consultation screen');
        _showConsultationEndedDialog();
        initialAppointmentStatus = true;
      }
    });

    chatController.stream.listen((status) {
      debugPrint('STREAM STATUS CHANGED: $status');
      if (status == 'success' && mounted) {
        // Force UI update if needed
        setState(() {});
      }
    });

    chatController.addListener(scrollToBottom);
    messageFN.addListener(scrollToBottom);
    checkIfDoctorMessagedFirst();

    // Enhanced listener for first-time message detection
    chatController.messageStream.listen((messages) {
      debugPrint('MessageStream - Received ${messages.length} messages');

      if (messages.isNotEmpty) {
        // Check if this is the first message from doctor (transition from empty to active chat)
        bool wasDisabled = isDisabled;
        updateIsDisabled(messages);

        if (wasDisabled && !isDisabled) {
          debugPrint('First doctor message detected! Transitioning UI state');

          // Force scroll to bottom when first message appears
          Future.delayed(const Duration(milliseconds: 300), () {
            scrollToBottom();
          });
        }
      }
    });
  }

  void startChatroomPolling() {
    debugPrint('Starting chatroom polling for first-time creation');

    // Create a local variable to track current state
    String? currentState;
    StreamSubscription? stateSubscription;

    // Set up a subscription to track state changes
    Timer? timer; // Declare timer before its first use
    stateSubscription = chatController.stream.listen((state) {
      currentState = state;

      // Cancel polling if state changes from empty
      if (state != 'empty' && timer != null) {
        debugPrint('State changed to $state - stopping polling');
        timer?.cancel(); // Replace ?. with .
        stateSubscription?.cancel();
      }
    });

    // Wait briefly to allow initial state to be set
    Future.delayed(const Duration(milliseconds: 100), () {
      if (currentState != 'empty' || !mounted) {
        debugPrint('No need for polling: chat state is $currentState');
        stateSubscription?.cancel();
        return;
      }

      debugPrint('Chat state is empty, starting periodic polling');
      // Check every 5 seconds if the chatroom was created
      timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (currentState != 'empty' || !mounted) {
          debugPrint('Stopping polling: chat state changed to $currentState');
          timer.cancel();
          stateSubscription?.cancel();
          return;
        }

        debugPrint('Polling: re-checking for chatroom creation');
        // Re-trigger chatroom check
        chatController.getChatRoom(
            chatController.generateRoomId(selectedDoctorUid),
            selectedDoctorUid);
      });
    });
  }

  void _showConsultationEndedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Consultation Ended'),
          content: const Text(
            'The doctor has ended this consultation. You can still view the messages, but no new messages can be sent.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Continue Reading'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the consultation screen
              },
              child: const Text('Leave Consultation'),
            ),
          ],
        );
      },
    );
  }

  Future<void> checkIfDoctorMessagedFirst() async {
    debugPrint('CheckIfDoctorMessagedFirst - Starting check...');

    // This handles both existing appointments and potential new ones
    try {
      final messages = await chatController.getMessagesForSpecificAppointment(
        chatroom,
        appointment.appointmentUid!,
      );

      debugPrint(
          'CheckIfDoctorMessagedFirst - Found ${messages.length} messages');

      if (messages.isNotEmpty) {
        updateIsDisabled(messages);
      } else {
        // No messages yet - ensure we're listening for updates
        debugPrint('No messages yet - ensuring listener is active');
      }
    } catch (e) {
      // This might happen if the appointment document doesn't exist yet
      debugPrint('Error checking first messages: $e');
    }
  }

  void updateIsDisabled(List<dynamic> messages) {
    debugPrint('UpdateIsDisabled - Current isDisabled value: $isDisabled');

    // Only process if we have messages
    if (messages.isEmpty) {
      return;
    }

    bool hasDocMessage =
        messages.any((message) => message.authorUid == selectedDoctorUid);

    debugPrint('UpdateIsDisabled - Doctor has messaged: $hasDocMessage');

    if (isDisabled && hasDocMessage) {
      debugPrint('Doctor sent first message - enabling patient replies');
      setState(() {
        isDisabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('AppointmentUID: ${appointment.appointmentUid}');
    debugPrint('ChatRoom: $chatroom');
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
                      disabled: isDisabled,
                      chatController: chatController,
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
                      // disabled: true,
                      disabled: isDisabled, chatController: chatController,
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

  @override
  void dispose() {
    chatController.removeListener(scrollToBottom);
    messageFN.removeListener(scrollToBottom);
    messageController.dispose();
    messageFN.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
