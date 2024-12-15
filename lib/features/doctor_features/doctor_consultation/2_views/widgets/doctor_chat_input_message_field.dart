import 'package:flutter/material.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';

class DoctorChatInputMessageField extends StatelessWidget {
  final FocusNode messageFN;
  final TextEditingController messageController;
  final BuildContext context;
  final Function send;

  const DoctorChatInputMessageField({
    super.key,
    required this.messageFN,
    required this.messageController,
    required this.context,
    required this.send,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 20,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: 285,
              height: 70,
              decoration: BoxDecoration(
                color: GinaAppTheme.appbarColorLight,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: TextFormField(
                    readOnly: isChatWaiting,
                    focusNode: messageFN,
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Message',
                      hintStyle:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: GinaAppTheme.lightOutline,
                                fontSize: 15,
                              ),
                      isDense: true,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.only(bottom: 12, top: 10, right: 12),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 60,
            height: 70,
            decoration: BoxDecoration(
                color: isChatWaiting
                    ? GinaAppTheme.lightOutline
                    : GinaAppTheme.lightTertiaryContainer,
                borderRadius: BorderRadius.circular(30)),
            child: IconButton(
                // icon: Image.asset(
                //   Images.consultationSendButtonIcon,
                //   width: 30,
                //   height: 30,
                //   fit: BoxFit.contain,
                //   filterQuality: FilterQuality.high,
                // ),
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                onPressed: () {
                  isChatWaiting ? null : send();
                }),
          )
        ],
      ),
    );
  }
}
