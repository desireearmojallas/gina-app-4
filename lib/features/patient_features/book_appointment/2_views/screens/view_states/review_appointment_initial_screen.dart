import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/widgets/doctor_name_widget.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/widgets/appointment_made_dialogue.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewAppointmentInitialScreen extends StatelessWidget {
  final DoctorModel doctorDetails;
  final UserModel currentPatient;
  final AppointmentModel appointmentModel;
  const ReviewAppointmentInitialScreen({
    super.key,
    required this.doctorDetails,
    required this.currentPatient,
    required this.appointmentModel,
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

    debugPrint(
        'Reason for appointment: ${appointmentModel.reasonForAppointment}');

    return ScrollbarCustom(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            doctorNameWidget(size, ginaTheme, doctorDetails),
            // Appointment Details
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: IntrinsicHeight(
                child: Container(
                  // height: size.height * 0.3,
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
                              '${appointmentModel.appointmentUid}',
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Reason for visit',
                                    style: labelStyle,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    appointmentModel.reasonForAppointment ??
                                        'Not specified',
                                    style: valueStyle,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Clinic location',
                                  style: labelStyle,
                                ),
                                Text(
                                  '${appointmentModel.doctorClinicAddress}',
                                  style: valueStyle,
                                ),
                              ],
                            ),
                            const Gap(15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Mode of appointment',
                                  style: labelStyle,
                                ),
                                Text(
                                  appointmentModel.modeOfAppointment == 0
                                      ? 'Online Consultation'
                                      : 'Face-to-Face Consultation',
                                  style: valueStyle,
                                ),
                              ],
                            ),
                            const Gap(15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Date & time',
                                  style: labelStyle,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${appointmentModel.appointmentDate}',
                                      style: valueStyle,
                                    ),
                                    Text(
                                      '${appointmentModel.appointmentTime}',
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
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('appointments')
                              .doc(appointmentModel.appointmentUid)
                              .collection('payments')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(
                                'Error loading payment details',
                                style: valueStyle?.copyWith(color: Colors.red),
                              );
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Text(
                                'No payment details available',
                                style: valueStyle?.copyWith(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              );
                            }

                            final paymentDoc = snapshot.data!.docs.first;
                            final paymentData =
                                paymentDoc.data() as Map<String, dynamic>;

                            return Column(
                              children: [
                                const Gap(20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Base Fee', // Changed from 'Amount Paid'
                                      style: labelStyle,
                                    ),
                                    Text(
                                      '₱${NumberFormat('#,##0.00').format(appointmentModel.amount ?? 0)}',
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
                                      'Platform Fee (${(appointmentModel.platformFeePercentage! * 100).toInt()}%)',
                                      style: labelStyle,
                                    ),
                                    Text(
                                      '₱${NumberFormat('#,##0.00').format(appointmentModel.platformFeeAmount ?? 0)}',
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
                                      'Total Amount',
                                      style: labelStyle?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '₱${NumberFormat('#,##0.00').format(appointmentModel.totalAmount ?? 0)}',
                                      style: valueStyle?.copyWith(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        color: (paymentData['status']
                                                        as String?)
                                                    ?.toLowerCase() ==
                                                'paid'
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        (paymentData['status'] as String?)
                                                ?.toUpperCase() ??
                                            'PENDING',
                                        style: valueStyle?.copyWith(
                                          color:
                                              (paymentData['status'] as String?)
                                                          ?.toLowerCase() ==
                                                      'paid'
                                                  ? Colors.green
                                                  : Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Payment Method',
                                      style: labelStyle,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.4,
                                      child: Text(
                                        paymentData['paymentMethod'] ??
                                            'Xendit',
                                        style: valueStyle?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Payment Date',
                                      style: labelStyle,
                                    ),
                                    Text(
                                      paymentData['linkedAt'] != null
                                          ? DateFormat('MMMM d, yyyy h:mm a')
                                              .format((paymentData['linkedAt']
                                                      as Timestamp)
                                                  .toDate())
                                          : 'N/A',
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
                                      'Invoice ID',
                                      style: labelStyle,
                                    ),
                                    Text(
                                      paymentData['invoiceId'] ?? 'N/A',
                                      style: valueStyle?.copyWith(
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            const Gap(5),
            Center(
              child: Column(
                children: [
                  Text(
                    'To ensure a smooth online appointment, please be prepared 15 \nminutes before the scheduled time.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: GinaAppTheme.lightOutline,
                        ),
                  ),
                  const Gap(50),
                  SizedBox(
                    width: size.width * 0.93,
                    height: size.height / 17,
                    child: FilledButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        showAppointmentMadeDialog(context)
                            .then((value) => Navigator.of(context).pop());
                      },
                      child: Text(
                        'Finish Review',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                      ),
                    ),
                  ),
                  const Gap(40),
                ],
              ),
            ),
          ],
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
