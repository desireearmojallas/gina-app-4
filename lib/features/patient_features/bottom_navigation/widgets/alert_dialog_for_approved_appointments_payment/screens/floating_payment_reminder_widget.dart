import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/widgets/alert_dialog_for_approved_appointments_payment/screens/alert_dialog_for_approved_appointments_payment.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/screens/home_screen.dart';

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
  // Total allowed time in seconds (fetched from admin settings)
  late int _totalAllowedSeconds;

  bool _isInitializing = true;

  // Remaining seconds will be calculated based on approval time
  int _remainingSeconds = 3600; // Default until properly initialized
  Timer? _timer;
  Timer? _statusCheckTimer;
  bool _isAppointmentCancelled = false;

  @override
  void initState() {
    super.initState();
    _initialize();
    debugPrint(
        'FloatingPaymentReminder initialized for appointment: ${widget.appointment.appointmentUid}');
  }

  Future<void> _initialize() async {
    // First, fetch the payment validity time
    await _fetchPaymentValidityTime();

    // Then start the countdown and status check (now _totalAllowedSeconds is initialized)
    _startCountdown();
    _startStatusCheck();

    // Update loading state
    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  Future<void> _fetchPaymentValidityTime() async {
    try {
      _totalAllowedSeconds =
          await AlertDialogForApprovedAppointmentsPaymentProvider
              .getPaymentValidityTime();

      debugPrint(
          'Payment validity time fetched: $_totalAllowedSeconds seconds');
    } catch (e) {
      debugPrint('Error fetching payment validity time: $e');
      _totalAllowedSeconds = 3600; // Default to 1 hour if any error occurs
    }
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
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          // If time's up, reset the reminder in HomeScreen
          HomeScreen.resetPaymentDialogShown();
        }
      });
    });
  }

  // Check if the appointment status has been changed to cancelled or declined
  void _startStatusCheck() {
    final appointmentId = widget.appointment.appointmentUid;
    if (appointmentId == null) return;

    // Check immediately once
    _checkAppointmentStatus(appointmentId);

    // Then set up periodic checks
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _checkAppointmentStatus(appointmentId);
    });
  }

  Future<void> _checkAppointmentStatus(String appointmentId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .get();

      if (!doc.exists) return;

      final status = doc.data()?['appointmentStatus'] as int?;

      if (status == AppointmentStatus.cancelled.index ||
          status == AppointmentStatus.declined.index) {
        if (mounted) {
          setState(() {
            _isAppointmentCancelled = true;
          });

          // If appointment was cancelled/declined, hide this widget
          HomeScreen.resetPaymentDialogShown();
        }
      }
    } catch (e) {
      debugPrint('Error checking appointment status: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _statusCheckTimer?.cancel();
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
    // Show loading or empty widget while initializing
    if (_isInitializing) {
      return const SizedBox.shrink(); // Don't show anything while initializing
    }

    if (_isAppointmentCancelled) {
      debugPrint('💰 PAYMENT REMINDER: Appointment cancelled, not showing');
      return const SizedBox.shrink();
    }

    // Check for zero remaining time
    if (_remainingSeconds <= 0) {
      debugPrint('💰 PAYMENT REMINDER: Time expired, not showing');
      HomeScreen.resetPaymentDialogShown();
      return const SizedBox.shrink();
    }

    debugPrint(
        '💰 PAYMENT REMINDER: Building with ${_remainingSeconds}s remaining');

    // Use a simpler container structure to avoid layout issues
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            debugPrint('💰 PAYMENT REMINDER: Clicked, showing payment dialog');
            AlertDialogForApprovedAppointmentsPaymentProvider.show(
              context,
              appointment: widget.appointment,
            );
          },
          borderRadius: BorderRadius.circular(40),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  GinaAppTheme.lightTertiaryContainer,
                  GinaAppTheme.lightTertiaryContainer.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: GinaAppTheme.lightOutline.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 3,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    );
  }
}
