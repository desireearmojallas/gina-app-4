import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/widgets/alert_dialog_for_approved_appointments_payment/screens/alert_dialog_for_approved_appointments_payment.dart';
import 'package:icons_plus/icons_plus.dart';

class FloatingPaymentReminderProvider extends StatelessWidget {
  final AppointmentModel appointment;
  final DateTime approvalTime;

  const FloatingPaymentReminderProvider({
    super.key,
    required this.appointment,
    required this.approvalTime,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingPaymentReminder(
      appointment: appointment,
      approvalTime: approvalTime,
    );
  }
}

class FloatingPaymentReminder extends StatefulWidget {
  final AppointmentModel appointment;
  final DateTime approvalTime;

  const FloatingPaymentReminder({
    super.key,
    required this.appointment,
    required this.approvalTime,
  });

  @override
  State<FloatingPaymentReminder> createState() =>
      _FloatingPaymentReminderState();
}

class _FloatingPaymentReminderState extends State<FloatingPaymentReminder> {
  // Total allowed time in seconds (1 hour)
  final int _totalAllowedSeconds = 3600;

  // Remaining seconds will be calculated based on approval time
  late int _remainingSeconds;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    debugPrint(
        'FloatingPaymentReminder initialized for appointment: ${widget.appointment.appointmentUid}');
  }

  void _startCountdown() {
    // Calculate time elapsed since appointment was approved
    DateTime now = DateTime.now();

    // Calculate seconds elapsed since approval
    int secondsElapsed = now.difference(widget.approvalTime).inSeconds;

    // Calculate remaining seconds (cap at 0 if more than allowed time has passed)
    _remainingSeconds = _totalAllowedSeconds - secondsElapsed;
    if (_remainingSeconds < 0) _remainingSeconds = 0;

    debugPrint(
        'Payment reminder countdown started: $_remainingSeconds seconds remaining');

    // Start the countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    debugPrint('FloatingPaymentReminder disposed');
    super.dispose();
  }

  // Format the remaining time as HH:MM:SS
  String _formatTimeRemaining() {
    int hours = _remainingSeconds ~/ 3600;
    int minutes = (_remainingSeconds % 3600) ~/ 60;
    int seconds = _remainingSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building FloatingPaymentReminder widget');
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0, left: 16.0, right: 16.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              debugPrint('Payment reminder clicked, showing payment dialog');
              // Show payment dialog when container is clicked
              AlertDialogForApprovedAppointmentsPaymentProvider.show(context,
                  appointment: widget.appointment);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GinaAppTheme.lightTertiaryContainer,
                    GinaAppTheme.lightTertiaryContainer.withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                // color: GinaAppTheme.lightTertiaryContainer.withOpacity(0.95),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.payment_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pending Payment",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          "Dr. ${widget.appointment.doctorName} • ${widget.appointment.appointmentDate}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Gap(12),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.timer,
                              color: Colors.white,
                              size: 12,
                            ),
                            const Gap(4),
                            Text(
                              _formatTimeRemaining(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(4),
                      Text(
                        "Tap to pay",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
