import 'package:flutter/material.dart';

class DoctorChatConsultationBody extends StatelessWidget {
  final FocusNode messageFN;
  final TextEditingController messageController;
  final BuildContext context;
  final Widget messages;
  final Function send;
  const DoctorChatConsultationBody({
    super.key,
    required this.messageFN,
    required this.messageController,
    required this.context,
    required this.messages,
    required this.send,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Column(
        children: [
          // messages,
          // isFromChatRoomLists || isAppointmentFinished ? P
        ],
      ),
    );
  }
}
