import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/widgets/chat_input_message_field.dart';

class ChatConsultationBody extends StatelessWidget {
  final FocusNode messageFN;
  final TextEditingController messageController;
  final BuildContext context;
  final Widget messages;
  final Function send;
  const ChatConsultationBody({
    super.key,
    required this.messageFN,
    required this.messageController,
    required this.context,
    required this.messages,
    required this.send,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          messages,
          isFromConsultationHistory || isAppointmentFinished
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 15,
                    color: GinaAppTheme.appbarColorLight,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Text(
                          'Note: This conversation is view-only, and the consultation is now complete with no further messaging available.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: GinaAppTheme.lightOutline,
                                  ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                )
              : isChatWaiting
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                              'Welcome!\n\nYour consultation will begin at ${storedAppointmentTime!.split(" - ")[0]} and lasts until ${storedAppointmentTime!.split(" - ")[1]}.\n\nRelax and take a deep breath! Your doctor will be with you soon. We\'re excited to help you feel your best.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: GinaAppTheme.lightOutline,
                                    fontWeight: FontWeight.w600,
                                  )),
                          ChatInputMessageField(
                              messageFN: messageFN,
                              messageController: messageController,
                              context: context,
                              send: send),
                        ],
                      ),
                    )
                  : ChatInputMessageField(
                      messageFN: messageFN,
                      messageController: messageController,
                      context: context,
                      send: send),
        ],
      ),
    );
  }
}
