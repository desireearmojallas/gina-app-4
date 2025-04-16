import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/face_to_face_card_details.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/full_screen_image_viewer.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/appointment_information_container.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/appointment_status_card.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/widgets/pay_now_button.dart';
import 'package:intl/intl.dart';

class ConsultationHistoryDetailScreen extends StatelessWidget {
  final DoctorModel doctorDetails;
  final AppointmentModel appointment;
  final UserModel currentPatient;
  final List<String> prescriptionImages;

  const ConsultationHistoryDetailScreen({
    super.key,
    required this.doctorDetails,
    required this.appointment,
    required this.currentPatient,
    required this.prescriptionImages,
  });

  @override
  Widget build(BuildContext context) {
    final appointmentBloc = context.read<AppointmentBloc>();
    final bookAppointmentBloc = context.read<BookAppointmentBloc>();
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    // Define styles for consistent appearance
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

    // Reverse the prescriptionImages list
    final reversedPrescriptionImages = prescriptionImages.reversed.toList();

    return RefreshIndicator(
      onRefresh: () async {
        appointmentBloc.add(NavigateToConsultationHistoryEvent(
          doctorUid: doctorDetails.uid,
          appointmentUid: appointment.appointmentUid!,
        ));
      },
      child: ScrollbarCustom(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              doctorNameWidget(size, ginaTheme, doctorDetails),
              if (appointment.modeOfAppointment == 1) ...[
                FaceToFaceCardDetails(
                  appointment: appointment,
                ),
                const Gap(5),
              ],
              AppointmentStatusCard(
                appointmentStatus: appointment.appointmentStatus!,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('appointments')
                      .doc(appointment.appointmentUid)
                      .collection('payments')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
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
                          appointmentDate: appointment.appointmentDate!,
                          onPaymentCreated: (invoiceUrl) {
                            bookAppointmentBloc.currentInvoiceUrl = invoiceUrl;
                          },
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  }),

              // Payment and appointment details section
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: IntrinsicHeight(
                  child: Container(
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
                              Text(
                                '${appointment.appointmentUid}',
                                style: valueStyle,
                              ),
                            ],
                          ),
                          divider,
                          headerWidget(
                            Icons.medical_services_outlined,
                            'Appointment Detail',
                          ),
                          Column(
                            children: [
                              const Gap(20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Clinic location',
                                    style: labelStyle,
                                  ),
                                  Text(
                                    '${appointment.doctorClinicAddress ?? "N/A"}',
                                    style: valueStyle,
                                  ),
                                ],
                              ),
                              const Gap(15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Mode of appointment',
                                    style: labelStyle,
                                  ),
                                  Text(
                                    appointment.modeOfAppointment == 0
                                        ? 'Online Consultation'
                                        : 'Face-to-Face Consultation',
                                    style: valueStyle,
                                  ),
                                ],
                              ),
                              const Gap(15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Date & time',
                                    style: labelStyle,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${appointment.appointmentDate}',
                                        style: valueStyle,
                                      ),
                                      Text(
                                        '${appointment.appointmentTime}',
                                        style: valueStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          divider,
                          headerWidget(
                            Icons.payment,
                            'Payment Details',
                          ),
                          _buildPaymentDetails(
                            appointment,
                            labelStyle!,
                            valueStyle!,
                            context,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Name',
                                    style: labelStyle,
                                  ),
                                  Text(
                                    currentPatient.name,
                                    style: valueStyle,
                                  ),
                                ],
                              ),
                              const Gap(15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Age',
                                    style: labelStyle,
                                  ),
                                  Text(
                                    '${bookAppointmentBloc.calculateAge(currentPatient.dateOfBirth)} years old',
                                    style: valueStyle,
                                  ),
                                ],
                              ),
                              const Gap(15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Location',
                                    style: labelStyle,
                                  ),
                                  Text(
                                    currentPatient.address,
                                    style: valueStyle,
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
                ),
              ),

              // Prescription images section
              reversedPrescriptionImages.isEmpty
                  ? Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No attachment/s available for this appointment.',
                        style: ginaTheme.bodySmall?.copyWith(
                          color: GinaAppTheme.lightOutline,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${reversedPrescriptionImages.length} Attachment/s',
                              style: ginaTheme.bodySmall?.copyWith(
                                color: GinaAppTheme.lightOutline,
                              ),
                            ),
                          ),
                        ),
                        const Gap(10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          width: size.width * 0.9,
                          height: size.height * 0.6,
                          child: Column(
                            children: [
                              const Gap(10),
                              Expanded(
                                child: ScrollbarCustom(
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount:
                                        reversedPrescriptionImages.length,
                                    itemBuilder: (context, index) {
                                      final image =
                                          reversedPrescriptionImages[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              HapticFeedback.mediumImpact();
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    FullScreenImageViewer(
                                                  imageUrl: image,
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Image.network(
                                                    image,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
              const Gap(100),
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

  Widget _buildPaymentDetails(
    AppointmentModel appointment,
    TextStyle labelStyle,
    TextStyle valueStyle,
    BuildContext context,
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
            padding: EdgeInsets.all(20.0),
            child: Text('No payment details available for this appointment'),
          );
        }

        final paymentData =
            snapshot.data!.docs.first.data() as Map<String, dynamic>;
        final paymentStatus = paymentData['status'] as String? ?? '';
        final refundStatus = paymentData['refundStatus'] as String?;
        final amount = paymentData['amount'] as double? ?? 0.0;
        final refundAmount = paymentData['refundAmount'] as double?;
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
                  style: valueStyle.copyWith(
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
