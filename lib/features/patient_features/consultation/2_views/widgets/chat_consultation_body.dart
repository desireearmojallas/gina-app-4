import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/widgets/chat_input_message_field.dart';
import 'package:intl/intl.dart';

class ChatConsultationBody extends StatefulWidget {
  final FocusNode messageFN;
  final TextEditingController messageController;
  final BuildContext context;
  final Widget messages;
  final Function send;
  final Function(bool) onChatWaitingChanged;
  final AppointmentModel appointment;
  final bool disabled;
  const ChatConsultationBody({
    super.key,
    required this.messageFN,
    required this.messageController,
    required this.context,
    required this.messages,
    required this.send,
    required this.onChatWaitingChanged,
    required this.appointment,
    required this.disabled,
  });

  @override
  _ChatConsultationBodyState createState() => _ChatConsultationBodyState();
}

class _ChatConsultationBodyState extends State<ChatConsultationBody> {
  late Timer _timer;
  bool _isLoading = false;

  AppointmentModel get appointment => widget.appointment;
  bool get disabled => widget.disabled;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final currentTime = DateFormat('hh:mm a').format(DateTime.now());
      final appointmentStartTime = storedAppointmentTime!.split(' - ')[0];

      debugPrint('Current time: $currentTime');
      debugPrint('Appointment start time: $appointmentStartTime');

      if (currentTime == appointmentStartTime) {
        setState(() {
          _isLoading = true;
        });

        // Show toast notification using addPostFrameCallback
        WidgetsBinding.instance.addPostFrameCallback((_) {
          HapticFeedback.mediumImpact();

          Fluttertoast.showToast(
            msg: 'Consultation is starting...',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 6,
            backgroundColor: GinaAppTheme.appbarColorLight.withOpacity(0.85),
            textColor: Colors.grey[700],
            fontSize: 12.0,
          );
        });

        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            isChatWaiting = false;
            _isLoading = false;
          });
          widget.onChatWaitingChanged(false);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Column(
        children: [
          widget.messages,
          if (_isLoading) ...[
            const Column(
              children: [
                CustomLoadingIndicator(
                  colors: [GinaAppTheme.appbarColorLight],
                ),
                Gap(10),
              ],
            ),
          ],
          if ((isFromChatRoomLists && isAppointmentFinished) ||
              isAppointmentFinished)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                width: size.width,
                height: size.height / 15,
                color: GinaAppTheme.appbarColorLight.withOpacity(0.85),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      'Note: This conversation is view-only, and the consultation is now complete with no further messaging available.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: GinaAppTheme.lightOutline,
                          ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
            )
          else if (isChatWaiting)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Welcome!\n\nYour consultation will begin at ${storedAppointmentTime!.split(' - ')[0]} and lasts until ${storedAppointmentTime!.split(' - ')[1]}.\n\n',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: GinaAppTheme.appbarColorLight,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  ChatInputMessageField(
                    messageFN: widget.messageFN,
                    messageController: widget.messageController,
                    context: widget.context,
                    send: widget.send,
                    appointment: appointment,
                    disabled: disabled,
                  ),
                ],
              ),
            )
          else
            ChatInputMessageField(
              messageFN: widget.messageFN,
              messageController: widget.messageController,
              context: widget.context,
              send: widget.send,
              appointment: appointment,
              disabled: disabled,
            ),
        ],
      ),
    );
  }
}
