import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/widgets/view_patient_data/view_patient_data.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_upcoming_appointments/2_views/bloc/doctor_upcoming_appointments_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patients/2_views/bloc/doctor_view_patients_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class ApprovedRequestDetailsScreenState extends StatelessWidget {
  final AppointmentModel appointment;
  final UserModel patientData;
  final int? appointmentStatus;
  final List<AppointmentModel> completedAppointments;
  final List<PeriodTrackerModel> patientPeriods;
  const ApprovedRequestDetailsScreenState({
    super.key,
    required this.appointment,
    required this.patientData,
    this.appointmentStatus = 1,
    required this.completedAppointments,
    required this.patientPeriods,
  });

  @override
  Widget build(BuildContext context) {
    final doctorEConsultBloc = context.read<DoctorEconsultBloc>();
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);

    debugPrint('Patient Name: ${patientData.name}');
    debugPrint('Patient Date of Birth: ${patientData.dateOfBirth}');
    debugPrint('Patient Gender: ${patientData.gender}');
    debugPrint('Patient Address: ${patientData.address}');
    debugPrint('Patient Email: ${patientData.email}');

    final labelStyle = ginaTheme.textTheme.bodySmall?.copyWith(
      color: GinaAppTheme.lightOutline,
    );
    final textStyle = ginaTheme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );

    final divider = Column(
      children: [
        const Gap(5),
        SizedBox(
          width: size.width / 1.15,
          child: const Divider(
            thickness: 0.5,
            color: GinaAppTheme.lightSurfaceVariant,
          ),
        ),
        const Gap(25),
      ],
    );

    return Scaffold(
      appBar: GinaDoctorAppBar(
        title: patientData.name,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            HapticFeedback.mediumImpact();

            // Check payment status first
            FirebaseFirestore.instance
                .collection('appointments')
                .doc(appointment.appointmentUid)
                .collection('payments')
                .get()
                .then((snapshot) {
              if (snapshot.docs.isEmpty) {
                // No payment record found - simplify the message
                _showPaymentRequiredDialog(context,
                    "The patient hasn't completed payment for this appointment yet.\n\nChat will be available once payment is received.");
                return;
              }

              // If we get here, payment is confirmed - proceed with original logic
              selectedPatientUid = appointment.patientUid!;
              debugPrint(
                  'doctor_upcoming_appointments_container selectedPatientUid: $selectedPatientUid');
              debugPrint(
                  'doctor_upcoming_appointments_container appointment: ${appointment.appointmentUid}');

              doctorEConsultBloc.add(
                  GetPatientDataEvent(patientUid: appointment.patientUid!));
              isFromChatRoomLists = false;

              selectedPatientAppointment = appointment.appointmentUid;
              selectedPatientUid = appointment.patientUid ?? '';
              selectedPatientName = appointment.patientName ?? '';
              selectedPatientAppointmentModel = appointment;

              appointmentDataFromDoctorUpcomingAppointmentsBloc = appointment;
              debugPrint(
                  'doctor_upcoming_appointments_container appointmentDataFromDoctorUpcomingAppointmentsBloc: $appointmentDataFromDoctorUpcomingAppointmentsBloc');

              Navigator.pushNamed(context, '/doctorOnlineConsultChat').then(
                  (value) => context
                      .read<DoctorEconsultBloc>()
                      .add(GetRequestedEconsultsDisplayEvent()));
            }).catchError((error) {
              debugPrint('Error checking payment status: $error');
              // Show generic error dialog
              _showPaymentRequiredDialog(context,
                  "Unable to verify payment status. Please try again later.");
            });
          },
          backgroundColor: GinaAppTheme.lightTertiaryContainer,
          child: const Icon(
            MingCute.message_3_fill,
            color: GinaAppTheme.lightBackground,
          ),
        ),
      ),
      body: Stack(
        children: [
          const GradientBackground(),
          Center(
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                child: Container(
                  width: size.width / 1.05,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: GinaAppTheme.lightOnTertiary,
                    boxShadow: [
                      GinaAppTheme.defaultBoxShadow,
                    ],
                  ),
                  child: ScrollbarCustom(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 80.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 30, 15, 20),
                                  child: CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage(
                                      Images.patientProfileIcon,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.5,
                                      child: Text(
                                        patientData.name,
                                        style: ginaTheme.textTheme.titleSmall
                                            ?.copyWith(
                                          color: GinaAppTheme.lightOnBackground,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.5,
                                      child: Flexible(
                                        child: Text(
                                          'Appointment ID: ${appointment.appointmentUid}',
                                          style: ginaTheme.textTheme.labelSmall
                                              ?.copyWith(
                                            color: GinaAppTheme.lightOutline,
                                          ),
                                          overflow: TextOverflow.visible,
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AppointmentStatusContainer(
                                        appointmentStatus: appointmentStatus!,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Gap(20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Birth date',
                                        style: labelStyle,
                                      ),
                                      const Gap(10),
                                      Text(
                                        patientData.dateOfBirth,
                                        style: textStyle,
                                      ),
                                    ],
                                  ),
                                  const Gap(130),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Gender',
                                        style: labelStyle,
                                      ),
                                      const Gap(10),
                                      Text(
                                        patientData.gender,
                                        style: textStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            divider,
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Address',
                                      style: labelStyle,
                                    ),
                                    const Gap(10),
                                    Text(
                                      patientData.address,
                                      style: textStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            divider,
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Email address',
                                      style: labelStyle,
                                    ),
                                    const Gap(10),
                                    Text(
                                      patientData.email,
                                      style: textStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            divider,
                            Container(
                              height: size.height * 0.08,
                              width: size.width / 1.12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: GinaAppTheme.lightSurfaceVariant,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    appointment.modeOfAppointment == 0
                                        ? 'Online Consultation'.toUpperCase()
                                        : 'Face-to-Face Consultation'
                                            .toUpperCase(),
                                    style: ginaTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color:
                                          GinaAppTheme.lightTertiaryContainer,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Gap(5),
                                  Text(
                                    '${appointment.appointmentDate} | ${appointment.appointmentTime}',
                                    style: ginaTheme.textTheme.labelMedium
                                        ?.copyWith(
                                      color: GinaAppTheme.lightOutline,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(20),
                            Container(
                              width: size.width / 1.12,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: GinaAppTheme.lightSurfaceVariant,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.assignment_outlined,
                                        // color:
                                        //     GinaAppTheme.lightTertiaryContainer,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Reason for Visit',
                                        style: ginaTheme.textTheme.titleSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(15),
                                  Text(
                                    appointment.reasonForAppointment ??
                                        'Not specified',
                                    style: labelStyle?.copyWith(
                                      color: GinaAppTheme.lightOnBackground
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(20),
                            Container(
                              width: size.width / 1.12,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: GinaAppTheme.lightSurfaceVariant,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Payment Information',
                                    style: ginaTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  _buildPaymentDetails(
                                    appointment,
                                    labelStyle!,
                                    textStyle!,
                                  ),
                                ],
                              ),
                            ),
                            const Gap(20),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewPatientDataScreen(
                                              patient: patientData,
                                              patientAppointment: appointment,
                                              patientAppointments:
                                                  completedAppointments,
                                              patientPeriods: patientPeriods,
                                            )));
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'View Patient Data',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Gap(10),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 50, 15, 20),
                              child: Container(
                                height: size.height * 0.06,
                                width: size.width / 1.15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: GinaAppTheme.approvedTextColor,
                                ),
                                child: Center(
                                  child: Text(
                                    'Approved',
                                    style: ginaTheme.textTheme.labelLarge
                                        ?.copyWith(
                                      color: GinaAppTheme.lightBackground,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Add payment details widget
  Widget _buildPaymentDetails(
      AppointmentModel appointment, TextStyle labelStyle, TextStyle textStyle) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointment.appointmentUid)
          .collection('payments')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint('Error loading payment details: ${snapshot.error}');
          return const SizedBox.shrink();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          debugPrint('No payment details available');
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'No payment details available',
              style: labelStyle,
            ),
          );
        }

        final paymentData =
            snapshot.data!.docs.first.data() as Map<String, dynamic>;
        final paymentStatus = paymentData['status'] as String? ?? '';
        final refundStatus = paymentData['refundStatus'] as String?;
        final amount = paymentData['amount'] is double
            ? paymentData['amount'] as double
            : (paymentData['amount'] is int
                ? (paymentData['amount'] as int).toDouble()
                : 0.0);
        final refundAmount = paymentData['refundAmount'] is double
            ? paymentData['refundAmount'] as double
            : (paymentData['refundAmount'] is int
                ? (paymentData['refundAmount'] as int).toDouble()
                : null);
        final paymentMethod =
            paymentData['paymentMethod'] as String? ?? 'Xendit';
        final linkedAt = paymentData['linkedAt'] as Timestamp?;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Amount Paid',
                  style: labelStyle,
                ),
                Text(
                  '₱${NumberFormat('#,##0.00').format(amount)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Status',
                  style: labelStyle,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _getPaymentStatusColor(paymentStatus).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    paymentStatus.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getPaymentStatusColor(paymentStatus),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Method',
                  style: labelStyle,
                ),
                Text(
                  paymentMethod,
                  style: textStyle,
                ),
              ],
            ),
            const Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Date',
                  style: labelStyle,
                ),
                Text(
                  linkedAt != null
                      ? DateFormat('MMMM d, yyyy h:mm a')
                          .format(linkedAt.toDate())
                      : 'N/A',
                  style: textStyle,
                ),
              ],
            ),
            if (refundStatus != null) ...[
              const Gap(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Refund Status',
                    style: labelStyle,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _getRefundStatusColor(refundStatus).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      refundStatus.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getRefundStatusColor(refundStatus),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              if (refundAmount != null) ...[
                const Gap(15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Refund Amount',
                      style: labelStyle,
                    ),
                    Text(
                      '₱${NumberFormat('#,##0.00').format(refundAmount)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ],
          ],
        );
      },
    );
  }

  Color _getPaymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getRefundStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'succeeded':
        return Colors.green;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showPaymentRequiredDialog(BuildContext context, String message) {
    // Get the lastUpdatedAt timestamp from appointment
    final lastUpdatedAt = appointment.lastUpdatedAt;
    if (lastUpdatedAt == null) {
      // No timestamp available, show regular dialog
      _showRegularPaymentDialog(context, message);
      return;
    }

    // Calculate expiry time (48 hours from lastUpdatedAt)
    final expiryTime = lastUpdatedAt.add(const Duration(hours: 48));
    final now = DateTime.now();

    // If already expired, show regular dialog with expired message
    if (now.isAfter(expiryTime)) {
      _showRegularPaymentDialog(context,
          "The payment window for this appointment has expired. The appointment will be automatically declined soon.");
      return;
    }

    // Show dialog with countdown
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          Timer? countdownTimer;
          Duration remaining = expiryTime.difference(DateTime.now());

          // Start the timer when dialog is shown
          countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
            if (context.mounted) {
              setState(() {
                remaining = expiryTime.difference(DateTime.now());
                // If time expired during viewing, update message
                if (remaining.isNegative) {
                  timer.cancel();
                }
              });
            } else {
              timer.cancel();
            }
          });

          // Format the remaining time
          String remainingTimeFormatted = _formatDuration(remaining);

          // Dispose timer when dialog is dismissed
          return WillPopScope(
            onWillPop: () {
              countdownTimer?.cancel();
              return Future.value(true);
            },
            child: AlertDialog(
              title: const Text('Payment Required'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message),
                  const SizedBox(height: 20),
                  const Text(
                    'Time remaining:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: remaining.inHours > 24
                          ? Colors.green.withOpacity(0.1)
                          : remaining.inHours > 6
                              ? Colors.orange.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        remainingTimeFormatted,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: remaining.inHours > 24
                              ? Colors.green
                              : remaining.inHours > 6
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'After this time expires, the appointment will be automatically declined.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    countdownTimer?.cancel();
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  // Helper method for regular dialog without countdown
  void _showRegularPaymentDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Required'),
          content: Text(message),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to format duration nicely
  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      return "Time expired";
    }

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
