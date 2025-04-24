import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/widgets/view_patient_data/view_patient_data.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_upcoming_appointments/2_views/bloc/doctor_upcoming_appointments_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class CompletedAppointmentDetailedScreenState extends StatelessWidget {
  final AppointmentModel appointment;
  final UserModel patientData;
  final List<AppointmentModel> completedAppointments;
  final List<PeriodTrackerModel> patientPeriods;
  const CompletedAppointmentDetailedScreenState({
    super.key,
    required this.appointment,
    required this.patientData,
    required this.completedAppointments,
    required this.patientPeriods,
  });

  @override
  Widget build(BuildContext context) {
    final doctorEConsultBloc = context.read<DoctorEconsultBloc>();
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);

    final labelStyle = ginaTheme.textTheme.bodySmall?.copyWith(
      color: GinaAppTheme.lightOutline,
    );
    final textStyle = ginaTheme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );

    final divider = Column(children: [
      const Gap(5),
      SizedBox(
        width: size.width / 1.15,
        child: const Divider(
          thickness: 0.5,
          color: GinaAppTheme.lightSurfaceVariant,
        ),
      ),
      const Gap(25),
    ]);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GinaDoctorAppBar(
        title: patientData.name,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            HapticFeedback.mediumImpact();

            selectedPatientUid = appointment.patientUid!;
            debugPrint(
                'doctor_upcoming_appointments_container selectedPatientUid: $selectedPatientUid');

            debugPrint(
                'doctor_upcoming_appointments_container appointment: ${appointment.appointmentUid}');

            doctorEConsultBloc
                .add(GetPatientDataEvent(patientUid: appointment.patientUid!));

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
          Align(
            alignment: Alignment.topCenter,
            child: ScrollbarCustom(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    width: size.width / 1.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: GinaAppTheme.lightOnTertiary,
                      boxShadow: [
                        GinaAppTheme.defaultBoxShadow,
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
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
                                    width: size.width * 0.48,
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
                                    width: size.width * 0.48,
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
                                padding: const EdgeInsets.fromLTRB(5, 0, 20, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppointmentStatusContainer(
                                      appointmentStatus:
                                          appointment.appointmentStatus!,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Gap(25),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
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
                                  style:
                                      ginaTheme.textTheme.labelSmall?.copyWith(
                                    color: GinaAppTheme.lightTertiaryContainer,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(5),
                                Text(
                                  '${appointment.appointmentDate} | ${appointment.appointmentTime}',
                                  style:
                                      ginaTheme.textTheme.labelMedium?.copyWith(
                                    color: GinaAppTheme.lightOutline,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Payment Info Container
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
                                  style:
                                      ginaTheme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _buildPaymentDetails(
                                  appointment,
                                  labelStyle!,
                                  textStyle!,
                                  context,
                                  size,
                                ),
                              ],
                            ),
                          ),
                          const Gap(30),
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
                            padding: const EdgeInsets.fromLTRB(15, 30, 15, 20),
                            child: Container(
                              height: size.height * 0.06,
                              width: size.width / 1.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: GinaAppTheme.lightSecondary,
                              ),
                              child: Center(
                                child: Text(
                                  'Completed',
                                  style:
                                      ginaTheme.textTheme.labelLarge?.copyWith(
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
        ],
      ),
    );
  }

  // Helper method to build payment details
  Widget _buildPaymentDetails(
    AppointmentModel appointment,
    TextStyle labelStyle,
    TextStyle valueStyle,
    BuildContext context,
    Size size,
  ) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointment.appointmentUid)
          .collection('payments')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CustomLoadingIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          debugPrint('Error loading payment details: ${snapshot.error}');
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Unable to load payment details',
              style: TextStyle(color: Colors.red[300]),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          debugPrint('No payment details available');
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              'No payment details available for this appointment',
              style: TextStyle(
                color: GinaAppTheme.lightOutline,
                fontSize: 12,
              ),
            ),
          );
        }

        final paymentData =
            snapshot.data!.docs.first.data() as Map<String, dynamic>;
        final paymentStatus = paymentData['status'] as String? ?? '';
        final refundStatus = paymentData['refundStatus'] as String?;

        // Extract basic payment details
        final amount = paymentData['amount'] as double? ?? 0.0;
        final refundAmount = paymentData['refundAmount'] as double?;
        final paymentMethod =
            paymentData['paymentMethod'] as String? ?? 'Xendit';
        final linkedAt = paymentData['linkedAt'] as Timestamp?;

        // Extract platform fee details
        final platformFeePercentage =
            paymentData['platformFeePercentage'] as double? ??
                appointment.platformFeePercentage ??
                0.0;
        final platformFeeAmount = paymentData['platformFeeAmount'] as double? ??
            appointment.platformFeeAmount ??
            0.0;

        // Calculate effective platform fee amount
        final effectivePlatformFeeAmount = platformFeeAmount > 0
            ? platformFeeAmount
            : (platformFeePercentage > 0
                ? amount * platformFeePercentage
                : 0.0);

        // Get the totalAmount with proper backward compatibility check
        double? rawTotalAmount = paymentData['totalAmount'] as double?;
        final totalAmount =
            // If totalAmount exists and is not 0, use it directly
            (rawTotalAmount != null && rawTotalAmount > 0.0)
                ? rawTotalAmount
                // Otherwise fall back to amount + platform fee
                : amount + effectivePlatformFeeAmount;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            // Base Fee row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Base Fee',
                  style: labelStyle,
                ),
                Text(
                  '₱${NumberFormat('#,##0.00').format(amount)}',
                  style: valueStyle,
                ),
              ],
            ),
            const Gap(15),
            // Platform Fee row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Platform Fee (${(platformFeePercentage * 100).toInt()}%)',
                  style: labelStyle,
                ),
                Text(
                  '₱${NumberFormat('#,##0.00').format(platformFeeAmount)}',
                  style: valueStyle,
                ),
              ],
            ),
            const Gap(15),
            // Total Amount row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: labelStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₱${NumberFormat('#,##0.00').format(totalAmount)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Gap(15),
            // Payment Status row
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
                SizedBox(
                  width: size.width * 0.45,
                  child: Text(
                    paymentMethod,
                    style: valueStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
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
                  style: valueStyle,
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

  // Helper methods for payment status colors
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
}
