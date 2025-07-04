import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/widgets/doctor_name_widget.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/appointment_status_card.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/cancel_appointment_widgets/cancel_modal_dialog.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/payment_details_widget.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/reschedule_filled_button.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/widgets/pay_now_button.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentDetailsStatusScreen extends StatelessWidget {
  final DoctorModel doctorDetails;
  final AppointmentModel appointment;
  final UserModel currentPatient;
  final bool? fromPendingPaymentDialog;
  const AppointmentDetailsStatusScreen({
    super.key,
    required this.doctorDetails,
    required this.appointment,
    required this.currentPatient,
    this.fromPendingPaymentDialog,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    final labelStyle = ginaTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    final valueStyle = ginaTheme.bodyMedium?.copyWith(
      fontSize: 12,
    );

    const divider = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        width: double.infinity,
        child: Divider(
          color: GinaAppTheme.lightSurfaceVariant,
          thickness: 0.5,
        ),
      ),
    );

    final bookAppointmentBloc = context.read<BookAppointmentBloc>();

    debugPrint('Inside Appointment Details Status Screen');

    debugPrint('Platform Fee Percentage: ${appointment.platformFeePercentage}');
    debugPrint('Platform Fee Amount: ${appointment.platformFeeAmount}');
    debugPrint('Total Amount: ${appointment.totalAmount}');
    debugPrint('Amount: ${appointment.amount}');

    return Stack(
      children: [
        ScrollbarCustom(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                doctorNameWidget(size, ginaTheme, doctorDetails),
                AppointmentStatusCard(
                  appointmentStatus: appointment.appointmentStatus!,
                ),
                const Gap(5),

                if (appointment.appointmentStatus ==
                    AppointmentStatus.declined.index)
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('appointments')
                        .doc(appointment.appointmentUid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 80,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }

                      final appointmentData =
                          snapshot.data!.data() as Map<String, dynamic>?;
                      if (appointmentData == null) {
                        return const SizedBox.shrink();
                      }

                      final bool autoDeclined =
                          appointmentData['autoDeclined'] == true;
                      final String declineReason =
                          appointmentData['declineReason'] as String? ?? '';

                      if (declineReason.isNotEmpty) {
                        return Container(
                          width: size.width,
                          margin: const EdgeInsets.fromLTRB(15, 8, 15, 0),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      autoDeclined
                                          ? Icons.timer_off
                                          : Icons.cancel_outlined,
                                      color: GinaAppTheme.declinedTextColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Reason for Declining',
                                      style: ginaTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: GinaAppTheme.declinedTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(15),
                                Text(
                                  declineReason,
                                  style: ginaTheme.bodySmall?.copyWith(
                                    color: GinaAppTheme.lightOnBackground
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('appointments')
                        .doc(appointment.appointmentUid)
                        .collection('payments')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CustomLoadingIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Center(child: Text('Error loading data'));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      final hasPaymentHistory = snapshot.data!.docs.isNotEmpty;
                      final paymentData = hasPaymentHistory
                          ? snapshot.data!.docs.first.data()
                              as Map<String, dynamic>
                          : null;
                      final paymentStatus =
                          paymentData?['status'] as String? ?? '';
                      final wasPreviouslyPaid =
                          paymentStatus.toLowerCase() == 'paid';

                      // Show Pay Now button only if:
                      // 1. Appointment is approved (status == 1) and no previous payment
                      // 2. OR if there was a previous payment (show as View Receipt)
                      if (appointment.appointmentStatus == 1 ||
                          wasPreviouslyPaid) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                          child: PayNowButton(
                            appointmentId: appointment.appointmentUid ?? '',
                            doctorId: doctorDetails.uid,
                            doctorName: doctorDetails.name,
                            patientName: appointment.patientName ?? '',
                            modeOfAppointment: appointment.modeOfAppointment!,
                            amount: appointment.amount ?? 0.0,
                            platformFeePercentage:
                                appointment.platformFeePercentage ?? 0.0,
                            platformFeeAmount:
                                appointment.platformFeeAmount ?? 0.0,
                            totalAmount: appointment.totalAmount ??
                                (appointment.amount ?? 0.0),
                            appointmentDate: appointment.appointmentDate!,
                            onPaymentCreated: (invoiceUrl) {
                              bookAppointmentBloc.currentInvoiceUrl =
                                  invoiceUrl;
                            },
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    }),
                [2, 3].contains(appointment.appointmentStatus)
                    ? const SizedBox()
                    : Column(
                        children: [
                          const Gap(15),
                          RescheduleFilledButton(
                            appointment: appointment,
                            doctor: doctorDetails,
                          ),
                        ],
                      ),

                // [1].contains(appointment.appointmentStatus!)
                //     ? AppointmentPaymentWidgets(
                //         appointmentId: appointment.appointmentUid ?? '',
                //         doctorName: doctorDetails.name,
                //         patientName: appointment.patientName ?? '',
                //         consultationType: appointment.consultationType ?? '',
                //         amount: appointment.amount ?? 0.0,
                //         appointmentDate: appointment.appointmentDate!,
                //       )
                //     : const SizedBox.shrink(),

                appointmentDetailsContent(
                  labelStyle,
                  valueStyle,
                  divider,
                  bookAppointmentBloc,
                  size,
                ),
                [2, 3, 4, 5].contains(appointment.appointmentStatus)
                    ? const SizedBox()
                    : Text(
                        'To ensure a smooth online appointment, please be prepared 15 \nminutes before the scheduled time.',
                        textAlign: TextAlign.center,
                        style: ginaTheme.bodySmall?.copyWith(
                          color: GinaAppTheme.lightOutline,
                        ),
                      ),
                const Gap(15),
                [2, 3, 4, 5].contains(appointment.appointmentStatus)
                    ? const SizedBox()
                    : Builder(
                        builder: (context) {
                          final DateFormat dateFormat =
                              DateFormat('MMMM d, yyyy');
                          final DateFormat timeFormat = DateFormat('hh:mm a');
                          final DateTime now = DateTime.now();

                          final DateTime appointmentDate = dateFormat
                              .parse(appointment.appointmentDate!.trim());
                          final List<String> times =
                              appointment.appointmentTime!.split(' - ');
                          final DateTime startTime =
                              timeFormat.parse(times[0].trim());
                          final DateTime endTime =
                              timeFormat.parse(times[1].trim());

                          final DateTime appointmentStartDateTime = DateTime(
                            appointmentDate.year,
                            appointmentDate.month,
                            appointmentDate.day,
                            startTime.hour,
                            startTime.minute,
                          );

                          final DateTime appointmentEndDateTime = DateTime(
                            appointmentDate.year,
                            appointmentDate.month,
                            appointmentDate.day,
                            endTime.hour,
                            endTime.minute,
                          );

                          final bool isWithinAppointmentTime =
                              now.isAfter(appointmentStartDateTime) &&
                                  now.isBefore(appointmentEndDateTime);

                          return SizedBox(
                            width: size.width * 0.93,
                            height: size.height / 17,
                            child: OutlinedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                    color: isWithinAppointmentTime
                                        ? Colors.grey[300]!
                                        : GinaAppTheme.lightOnPrimaryColor,
                                  ),
                                ),
                              ),
                              onPressed: isWithinAppointmentTime
                                  ? null
                                  : () {
                                      HapticFeedback.mediumImpact();
                                      showCancelModalDialog(context,
                                          appointmentId:
                                              appointment.appointmentUid!);
                                    },
                              child: Text(
                                'Cancel Appointment',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isWithinAppointmentTime
                                          ? Colors.grey[400]!
                                          : GinaAppTheme.lightOnPrimaryColor,
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
                const Gap(100),
                // const Gap(160),
              ],
            ),
          ),
        ),
        appointment.modeOfAppointment == 1 &&
                appointment.appointmentStatus ==
                    AppointmentStatus.confirmed.index
            ? Positioned(
                bottom: 95.0,
                right: 90.0,
                child: Material(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                              color: GinaAppTheme.appbarColorLight
                                  .withOpacity(0.3),
                              blurRadius: 8.0,
                              spreadRadius: 1.0,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Please be at the clinic 15 minutes before\nthe appointment.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : appointment.modeOfAppointment == 0 &&
                    appointment.appointmentStatus ==
                        AppointmentStatus.confirmed.index &&
                    fromPendingPaymentDialog != true
                ? Positioned(
                    bottom: 175.0,
                    right: 70.0,
                    child: Material(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: GinaAppTheme.lightTertiaryContainer,
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Text(
                              'Go to consultation room',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          // const Gap(3),
                          const Icon(
                            Icons.arrow_right_rounded,
                            size: 30,
                            color: GinaAppTheme.lightTertiaryContainer,
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
      ],
    );
  }

  Padding appointmentDetailsContent(
    TextStyle? labelStyle,
    TextStyle? valueStyle,
    Padding divider,
    BookAppointmentBloc bookAppointmentBloc,
    Size size,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 20.0,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Appointment ID:',
                    style: labelStyle,
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text(
                      '${appointment.appointmentUid}',
                      style: valueStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              divider,
              headerWidget(
                Icons.medical_services_outlined,
                'Appointment Detail',
              ),
              const Gap(20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      'Reason for visit',
                      style: labelStyle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 2,
                    child: Text(
                      appointment.reasonForAppointment ?? 'Not specified',
                      style: valueStyle,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              const Gap(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Text(
                      'Mode of appointment',
                      style: labelStyle,
                    ),
                  ),
                  const Gap(10),
                  Flexible(
                    flex: 3,
                    child: Text(
                      appointment.modeOfAppointment == 0
                          ? 'Online Consultation'
                          : 'Face-to-Face Consultation',
                      style: valueStyle,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              const Gap(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Text(
                      'Date & time',
                      style: labelStyle,
                    ),
                  ),
                  const Gap(10),
                  Flexible(
                    flex: 3,
                    child: Column(
                      children: [
                        Text(
                          '${appointment.appointmentDate}',
                          style: valueStyle,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text(
                          '${appointment.appointmentTime}',
                          style: valueStyle,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              divider,
              headerWidget(
                Icons.payment,
                'Payment Details',
              ),
              PaymentDetailsWidget(
                appointment: appointment,
                labelStyle: labelStyle!,
                valueStyle: valueStyle!,
              ),
              divider,
              headerWidget(
                Icons.person_3,
                'Patient Personal Information',
              ),
              Column(
                children: [
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(flex: 1, child: Text('Name', style: labelStyle)),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 2,
                        child: Text(
                          currentPatient.name,
                          style: valueStyle,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const Gap(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(flex: 1, child: Text('Age', style: labelStyle)),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 2,
                        child: Text(
                          '${bookAppointmentBloc.calculateAge(currentPatient.dateOfBirth)} years old',
                          style: valueStyle,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const Gap(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          flex: 1, child: Text('Location', style: labelStyle)),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 2,
                        child: Text(
                          currentPatient.address,
                          style: valueStyle,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const Gap(15),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerWidget(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
        ),
        const Gap(10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
