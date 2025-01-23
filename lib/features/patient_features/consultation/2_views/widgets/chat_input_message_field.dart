import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:icons_plus/icons_plus.dart';

class ChatInputMessageField extends StatelessWidget {
  final FocusNode messageFN;
  final TextEditingController messageController;
  final BuildContext context;
  final Function send;
  final AppointmentModel appointment;
  final bool disabled;
  const ChatInputMessageField({
    super.key,
    required this.messageFN,
    required this.messageController,
    required this.context,
    required this.send,
    required this.appointment,
    required this.disabled,
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
                color: disabled
                    ? GinaAppTheme.lightOutline.withOpacity(0.2)
                    : GinaAppTheme.appbarColorLight.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextFormField(
                    readOnly: disabled,
                    focusNode: messageFN,
                    controller: messageController,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Message',
                      hintStyle:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: disabled
                                    ? Colors.white.withOpacity(0.4)
                                    : GinaAppTheme.lightOutline,
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
                    onTap: () {
                      if (disabled) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          HapticFeedback.mediumImpact();

                          Fluttertoast.showToast(
                            msg: 'Wait for the doctor to message first',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor:
                                GinaAppTheme.appbarColorLight.withOpacity(0.85),
                            textColor: Colors.grey[700],
                            fontSize: 12.0,
                          );
                        });
                      }
                    },
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
                color: disabled
                    ? GinaAppTheme.lightOutline.withOpacity(0.2)
                    : GinaAppTheme.lightTertiaryContainer,
                borderRadius: BorderRadius.circular(20)),
            child: IconButton(
                icon: Icon(
                  MingCute.send_plane_fill,
                  color:
                      disabled ? Colors.white.withOpacity(0.4) : Colors.white,
                  size: 25,
                ),
                onPressed: () {
                  if (disabled) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      HapticFeedback.mediumImpact();

                      Fluttertoast.showToast(
                        msg: 'Wait for the doctor to message first',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor:
                            GinaAppTheme.appbarColorLight.withOpacity(0.85),
                        textColor: Colors.grey[700],
                        fontSize: 12.0,
                      );
                    });
                  } else {
                    send();
                  }
                }),
          )
        ],
      ),
    );
  }
}
