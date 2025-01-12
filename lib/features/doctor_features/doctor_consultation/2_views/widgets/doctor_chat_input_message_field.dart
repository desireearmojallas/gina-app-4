import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorChatInputMessageField extends StatelessWidget {
  final FocusNode messageFN;
  final TextEditingController messageController;
  final BuildContext context;
  final Function send;
  final AppointmentModel appointment;
  const DoctorChatInputMessageField({
    super.key,
    required this.messageFN,
    required this.messageController,
    required this.context,
    required this.send,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 18,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: 285,
              height: 70,
              decoration: BoxDecoration(
                color: GinaAppTheme.appbarColorLight.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextFormField(
                    readOnly: isChatWaiting,
                    focusNode: messageFN,
                    controller: messageController,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Message',
                      hintStyle:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: GinaAppTheme.lightOutline,
                                fontSize: 14,
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
          const Gap(10),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: isChatWaiting
                    ? GinaAppTheme.lightOutline.withOpacity(0.4)
                    : GinaAppTheme.lightTertiaryContainer,
                borderRadius: BorderRadius.circular(20)),
            child: IconButton(
                // icon: Image.asset(
                //   Images.consultationSendButtonIcon,
                //   width: 30,
                //   height: 30,
                //   fit: BoxFit.contain,
                //   filterQuality: FilterQuality.high,
                // ),
                icon: Icon(
                  MingCute.send_plane_fill,
                  color: isChatWaiting
                      ? Colors.white.withOpacity(0.5)
                      : Colors.white,
                  size: 25,
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
