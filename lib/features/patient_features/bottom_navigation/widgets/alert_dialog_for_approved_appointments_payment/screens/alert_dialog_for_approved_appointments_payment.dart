// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/admin_features/admin_settings/1_controllers/admin_settings_controller.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/screens/view_states/appointment_details_status_screen.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/widgets/alert_dialog_for_approved_appointments_payment/bloc/alert_dialog_for_approved_appointments_payment_bloc.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/bloc/home_bloc.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/screens/home_screen.dart';

class AlertDialogForApprovedAppointmentsPaymentProvider
    extends StatelessWidget {
  final AppointmentModel appointment;
  const AlertDialogForApprovedAppointmentsPaymentProvider(
      {super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AlertDialogForApprovedAppointmentsBloc>(
      create: (context) {
        final alertDialogForApprovedAppointmentsBloc =
            sl<AlertDialogForApprovedAppointmentsBloc>();

        return alertDialogForApprovedAppointmentsBloc;
      },
      child: AlertDialogForApprovedAppointments(
        appointment: appointment,
        parentContext: context,
      ),
    );
  }

// Static method to show the dialog as an overlay
  static void show(BuildContext context,
      {required AppointmentModel appointment}) async {
    final navigatorContext = context;

    final AppointmentBloc appointmentBloc =
        BlocProvider.of<AppointmentBloc>(context);

    final HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);

    final int paymentValidityInSeconds = await getPaymentValidityTime();

    // Check if the appointment has already timed out
    final DateTime now = DateTime.now();
    final DateTime approvalTime = appointment.lastUpdatedAt ?? now;
    final int secondsElapsed = now.difference(approvalTime).inSeconds;

    if (secondsElapsed >= paymentValidityInSeconds) {
      _showTimesUpDialogStatic(context, appointment);
      return;
    }

    // Otherwise, show the regular payment dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AlertDialogForApprovedAppointmentsBloc>(
              create: (context) {
                final alertDialogForApprovedAppointmentsBloc =
                    sl<AlertDialogForApprovedAppointmentsBloc>();
                return alertDialogForApprovedAppointmentsBloc;
              },
            ),
            BlocProvider.value(
              value: appointmentBloc,
            ),
          ],
          child: AlertDialogForApprovedAppointments(
            appointment: appointment,
            parentContext: navigatorContext,
          ),
        );
      },
    ).then((_) {
      HomeScreen.resetPaymentDialogShown();
      homeBloc.add(ResetHomeStateAfterDialogEvent());
    });
  }

  static Future<int> getPaymentValidityTime() async {
    try {
      final settings =
          await AdminSettingsController.getGlobalPaymentValiditySettings();

      // Access the property directly from the settings object
      final validityInSeconds = settings.paymentWindowMinutes * 60;
      debugPrint('Payment validity time fetched: $validityInSeconds seconds');
      return validityInSeconds;
    } catch (e) {
      debugPrint('Error fetching payment validity time: $e');
      return 3600; // Default to 1 hour if any error occurs
    }
  }

  // Static version of the _showTimesUpDialog method
  static void _showTimesUpDialogStatic(
      BuildContext context, AppointmentModel appointment) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning Icon
              const Icon(
                Icons.timer_off,
                color: Colors.red,
                size: 70,
              ),
              const SizedBox(height: 20),

              // Time's Up Text
              const Text(
                "Time's Up!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Explanation Text
              const Text(
                "The appointment has been automatically declined due to payment timeout.",
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // OK Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Close this dialog
                    Navigator.of(dialogContext).pop();

                    // Trigger auto-decline for this specific appointment
                    if (appointment.appointmentUid != null) {
                      try {
                        debugPrint(
                            'Auto-declining unpaid appointment from dialog: ${appointment.appointmentUid}');
                        await FirebaseFirestore.instance
                            .collection('appointments')
                            .doc(appointment.appointmentUid)
                            .update({
                          'appointmentStatus': AppointmentStatus.declined.index,
                          'lastUpdatedAt': FieldValue.serverTimestamp(),
                          'autoDeclined': true,
                          'declinedReason':
                              'Auto-declined due to payment timeout',
                        });
                        debugPrint('Appointment auto-declined successfully');
                      } catch (e) {
                        debugPrint('Error auto-declining appointment: $e');
                      }
                    }

                    // Reset dialog shown flag
                    HomeScreen.resetPaymentDialogShown();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GinaAppTheme.lightOutline,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "I Understand",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AlertDialogForApprovedAppointments extends StatefulWidget {
  final AppointmentModel appointment;
  final BuildContext parentContext;
  const AlertDialogForApprovedAppointments({
    super.key,
    required this.appointment,
    required this.parentContext,
  });

  @override
  State<AlertDialogForApprovedAppointments> createState() =>
      _AlertDialogForApprovedAppointmentsState();
}

class _AlertDialogForApprovedAppointmentsState
    extends State<AlertDialogForApprovedAppointments> {
// Total allowed time in seconds (fetched from admin settings)
  late int _totalAllowedSeconds;

  bool _isInitializing = true;

  // Initialize with default values instead of using late
  int _remainingSeconds = 3600; // Default to 1 hour until properly initialized
  Timer? _timer; // Make nullable so we can check if initialized

  Future<bool> _isAppointmentPaid() async {
    try {
      final String appointmentId = widget.appointment.appointmentUid!;
      bool isPaid = false;

      // Check pending_payments collection first
      final pendingPaymentDoc = await FirebaseFirestore.instance
          .collection('pending_payments')
          .doc(appointmentId)
          .get();

      if (pendingPaymentDoc.exists) {
        final status = pendingPaymentDoc.data()?['status'] as String? ?? '';
        isPaid = status.toLowerCase() == 'paid';
      }

      // If not found or not paid in pending_payments, check appointments/payments
      if (!isPaid) {
        final appointmentPaymentsSnapshot = await FirebaseFirestore.instance
            .collection('appointments')
            .doc(appointmentId)
            .collection('payments')
            .get();

        if (appointmentPaymentsSnapshot.docs.isNotEmpty) {
          final status = appointmentPaymentsSnapshot.docs.first.data()['status']
                  as String? ??
              '';
          isPaid = status.toLowerCase() == 'paid';
        }
      }

      debugPrint(
          '⭐ DIALOG: Appointment $appointmentId payment status: ${isPaid ? 'PAID' : 'NOT PAID'}');
      return isPaid;
    } catch (e) {
      debugPrint('⭐ DIALOG: Error checking payment status: $e');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  Future<void> _initializeTimer() async {
    _totalAllowedSeconds =
        await AlertDialogForApprovedAppointmentsPaymentProvider
            .getPaymentValidityTime();

    DateTime now = DateTime.now();
    DateTime approvalTime = widget.appointment.lastUpdatedAt ?? now;

    int secondsElapsed = now.difference(approvalTime).inSeconds;

    _remainingSeconds = _totalAllowedSeconds - secondsElapsed;
    if (_remainingSeconds < 0) _remainingSeconds = 0;

    // Only proceed if widget is still mounted
    if (mounted) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            if (_remainingSeconds > 0) {
              _remainingSeconds--;
            } else {
              _timer?.cancel();
              // Auto-close dialog when time expires
              Navigator.of(context).pop();
              _showTimesUpDialog();
            }
          });
        }
      });

      // Update loading state
      setState(() {
        _isInitializing = false;
      });

      debugPrint('Payment validity: $_totalAllowedSeconds seconds');
      debugPrint('Appointment approved at: $approvalTime');
      debugPrint('Current time: $now');
      debugPrint('Seconds elapsed since approval: $secondsElapsed');
      debugPrint('Remaining seconds: $_remainingSeconds');
    }
  }

  void _showTimesUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning Icon
              const Icon(
                Icons.timer_off,
                color: Colors.red,
                size: 70,
              ),
              const SizedBox(height: 20),

              // Time's Up Text
              const Text(
                "Time's Up!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Explanation Text
              const Text(
                "The appointment has been automatically declined due to payment timeout.",
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // OK Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Close this dialog and the parent dialog
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();

                    // Trigger auto-decline for this specific appointment
                    if (widget.appointment.appointmentUid != null) {
                      try {
                        debugPrint(
                            'Auto-declining unpaid appointment from dialog: ${widget.appointment.appointmentUid}');
                        await FirebaseFirestore.instance
                            .collection('appointments')
                            .doc(widget.appointment.appointmentUid)
                            .update({
                          'appointmentStatus': AppointmentStatus.declined.index,
                          'lastUpdatedAt': FieldValue.serverTimestamp(),
                          'autoDeclined': true,
                          'declinedReason':
                              'Auto-declined due to payment timeout',
                        });
                        debugPrint('Appointment auto-declined successfully');
                      } catch (e) {
                        debugPrint('Error auto-declining appointment: $e');
                      }
                    }

                    // Reset dialog shown flag
                    HomeScreen.resetPaymentDialogShown();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GinaAppTheme.lightOutline,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "I Understand",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
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
    final appointmentsBloc = context.read<AppointmentBloc>();
    return BlocBuilder<AlertDialogForApprovedAppointmentsBloc,
        AlertDialogForApprovedAppointmentsPaymentState>(
      builder: (context, state) {
        // Get whether the appointment is already paid from the model
        final bool isPaid = widget.appointment.hasPreviousPayment ?? false;

        // Show loading indicator while initializing
        if (_isInitializing) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.all(20),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Loading appointment details..."),
              ],
            ),
          );
        }

        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 70,
              ),
              const SizedBox(height: 20),

              // Approval Text
              const Text(
                "Appointment Approved!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Conditional text based on payment status
              Text(
                isPaid
                    ? "Your rescheduled appointment has been approved by the doctor and is ready."
                    : "Your appointment has been approved by the doctor and is now waiting for payment.",
                style: const TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Appointment Details
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: GinaAppTheme.lightTertiaryContainer.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color:
                          GinaAppTheme.lightTertiaryContainer.withOpacity(0.3),
                      width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Appointment Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Two column layout for appointment details
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailItem(
                                label: "Doctor",
                                value: "Dr. ${widget.appointment.doctorName}",
                              ),
                              const SizedBox(height: 6),
                              _buildDetailItem(
                                label: "Date",
                                value: widget.appointment.appointmentDate!,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailItem(
                                label: "ID",
                                value: widget.appointment.appointmentUid!,
                              ),
                              const SizedBox(height: 6),
                              _buildDetailItem(
                                label: "Time",
                                value: widget.appointment.appointmentTime!,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Show timer warning only for unpaid appointments
              if (!isPaid)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber, width: 1),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.amber),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    color: Colors.black87, fontSize: 14),
                                children: [
                                  const TextSpan(
                                    text: "Time Remaining: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: _formatTimeRemaining(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Unpaid bookings will be auto-declined after ${_totalAllowedSeconds ~/ 60} minutes and the slot will be released to others.",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // Button with different text and behavior based on payment status
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final String appointmentUid =
                          widget.appointment.appointmentUid!;
                      final String doctorUid = widget.appointment.doctorUid!;

                      // Different behavior based on payment status
                      if (isPaid) {
                        debugPrint(
                            '⭐ DIALOG: View rescheduled appointment details clicked');
                      } else {
                        debugPrint('⭐ DIALOG: Proceed to Payment clicked');
                        // Set this as pending payment
                        HomeScreen.setPendingPayment(widget.appointment,
                            approvalTime: widget.appointment.lastUpdatedAt ??
                                DateTime.now());
                      }
                      // Get AppointmentBloc from parent context before closing dialog
                      final appointmentBloc = BlocProvider.of<AppointmentBloc>(
                          widget.parentContext);

                      // Close the dialog
                      Navigator.of(context).pop();

                      // Reset dialog shown flag immediately
                      HomeScreen.resetPaymentDialogShown();

                      // Use a short delay to let the dialog fully dismiss
                      Future.delayed(const Duration(milliseconds: 300),
                          () async {
                        try {
                          // Fetch doctor details
                          final doctorResult = await appointmentBloc
                              .appointmentController
                              .getDoctorDetail(doctorUid: doctorUid);

                          // Fetch patient details
                          final patientResult = await appointmentBloc
                              .profileController
                              .getPatientProfile();

                          doctorResult.fold((failure) {
                            debugPrint(
                                '⭐ DIALOG: Failed to fetch doctor details: $failure');
                            ScaffoldMessenger.of(widget.parentContext)
                                .showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Error fetching doctor details: $failure')),
                            );
                          }, (doctorDetails) {
                            patientResult.fold((failure) {
                              debugPrint(
                                  '⭐ DIALOG: Failed to fetch patient details: $failure');
                              ScaffoldMessenger.of(widget.parentContext)
                                  .showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Error fetching patient details: $failure')),
                              );
                            }, (patientDetails) {
                              if (widget.parentContext.mounted) {
                                Navigator.of(widget.parentContext).push(
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider.value(
                                      value: appointmentBloc,
                                      child: Scaffold(
                                        appBar: GinaPatientAppBar(
                                          title: 'Appointment Details',
                                        ),
                                        body: AppointmentDetailsStatusScreen(
                                          doctorDetails: doctorDetails,
                                          appointment: widget.appointment,
                                          currentPatient: patientDetails,
                                          fromPendingPaymentDialog: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            });
                          });
                        } catch (e) {
                          debugPrint(
                              '⭐ DIALOG: Error during data fetching: $e');
                        }
                      });
                    } catch (e) {
                      debugPrint('⭐ DIALOG: Top-level error: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GinaAppTheme.lightTertiaryContainer,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isPaid
                        ? "View Rescheduled Appointment"
                        : "Proceed to Payment",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Gap(10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
