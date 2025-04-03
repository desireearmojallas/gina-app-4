// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/2_views/screens/view_states/patient_payment_screen_initial.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/3_services/patient_payment_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PayNowButton extends StatelessWidget {
  final String appointmentId;
  final String doctorName;
  final String patientName;
  final int modeOfAppointment;
  final double amount;
  final DateTime appointmentDate;
  final Function(String)? onPaymentCreated;

  const PayNowButton({
    super.key,
    required this.appointmentId,
    required this.doctorName,
    required this.patientName,
    required this.modeOfAppointment,
    required this.amount,
    required this.appointmentDate,
    this.onPaymentCreated,
  });

  Future<String> _checkPaymentStatus(
      BuildContext context, String tempAppointmentId) async {
    try {
      final paymentDoc = await FirebaseFirestore.instance
          .collection('pending_payments')
          .doc(tempAppointmentId)
          .get();

      if (!paymentDoc.exists) {
        return 'not_found';
      }

      final paymentData = paymentDoc.data()!;
      final invoiceId = paymentData['invoiceId'] as String;
      final paymentService = PatientPaymentService();
      final xenditStatus =
          await paymentService.checkXenditPaymentStatus(invoiceId);

      return xenditStatus.toLowerCase();
    } catch (e) {
      debugPrint('Error checking payment status: $e');
      return 'error';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height / 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        gradient: const LinearGradient(
          colors: [
            GinaAppTheme.lightTertiaryContainer,
            GinaAppTheme.lightPrimaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(1.2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              HapticFeedback.mediumImpact();
              debugPrint('Pay Now button clicked');
              debugPrint('Appointment ID: $appointmentId');
              debugPrint('Amount: $amount');

              final paymentStatus =
                  await _checkPaymentStatus(context, appointmentId);
              debugPrint('Current payment status: $paymentStatus');

              if (paymentStatus == 'paid') {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: GinaAppTheme.lightTertiaryContainer,
                          size: 24,
                        ),
                        const Gap(8),
                        Text(
                          'Payment Successful',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: GinaAppTheme.lightTertiaryContainer,
                                  ),
                        ),
                      ],
                    ),
                    content: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            GinaAppTheme.lightSurfaceVariant.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildReceiptRow(
                            'Doctor',
                            'Dr. $doctorName',
                            context,
                          ),
                          const Gap(8),
                          _buildReceiptRow(
                            'Patient',
                            patientName,
                            context,
                          ),
                          const Gap(8),
                          _buildReceiptRow(
                            'Amount',
                            '₱${NumberFormat('#,##0.00').format(amount)}',
                            context,
                            valueColor: Colors.green,
                            valueBold: true,
                          ),
                          const Gap(8),
                          _buildReceiptRow(
                            'Date',
                            DateFormat('MMMM d, yyyy').format(appointmentDate),
                            context,
                          ),
                          const Gap(8),
                          _buildReceiptRow(
                            'Mode',
                            modeOfAppointment == 0
                                ? 'Online Consultation'
                                : 'Face-to-Face Consultation',
                            context,
                          ),
                          const Gap(16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                const Gap(8),
                                Expanded(
                                  child: Text(
                                    'Your payment has been successfully processed.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: GinaAppTheme.lightOutline,
                        ),
                        child: const Text('Close'),
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          HapticFeedback.mediumImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientPaymentScreenInitial(
                                appointmentId: appointmentId,
                                doctorName: doctorName,
                                patientName: patientName,
                                modeOfAppointment: modeOfAppointment,
                                amount: amount,
                                appointmentDate: appointmentDate,
                                existingInvoiceUrl: context
                                    .read<BookAppointmentBloc>()
                                    .currentInvoiceUrl,
                                showReceipt: true,
                              ),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: GinaAppTheme.lightTertiaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('View Receipt'),
                      ),
                    ],
                  ),
                );
                return;
              }

              final bookAppointmentBloc = context.read<BookAppointmentBloc>();
              if (bookAppointmentBloc.currentInvoiceUrl != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientPaymentScreenInitial(
                      appointmentId: appointmentId,
                      doctorName: doctorName,
                      patientName: patientName,
                      modeOfAppointment: modeOfAppointment,
                      amount: amount,
                      appointmentDate: appointmentDate,
                      existingInvoiceUrl: bookAppointmentBloc.currentInvoiceUrl,
                    ),
                  ),
                );
                return;
              }

              final paymentService = PatientPaymentService();
              try {
                final invoice = await paymentService.createPaymentInvoice(
                  appointmentId: appointmentId,
                  doctorName: doctorName,
                  patientName: patientName,
                  consultationType:
                      modeOfAppointment == 0 ? 'Online' : 'Face-to-Face',
                  amount: amount,
                  appointmentDate: appointmentDate,
                );

                if (onPaymentCreated != null) {
                  onPaymentCreated!(invoice['invoiceUrl']);
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientPaymentScreenInitial(
                      appointmentId: appointmentId,
                      doctorName: doctorName,
                      patientName: patientName,
                      modeOfAppointment: modeOfAppointment,
                      amount: amount,
                      appointmentDate: appointmentDate,
                      existingInvoiceUrl: invoice['invoiceUrl'],
                    ),
                  ),
                );
              } catch (e) {
                debugPrint('Error creating payment: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error creating payment: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          GinaAppTheme.lightTertiaryContainer.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: GinaAppTheme.lightTertiaryContainer,
                      size: 20,
                    ),
                  ),
                  const Gap(15),
                  Text(
                    'Pay Now',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: GinaAppTheme.lightOnPrimaryColor,
                          letterSpacing: 0.3,
                        ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          GinaAppTheme.lightTertiaryContainer.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: GinaAppTheme.lightTertiaryContainer,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(
    String label,
    String value,
    BuildContext context, {
    Color? valueColor,
    bool valueBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: GinaAppTheme.lightOutline,
                fontWeight: FontWeight.w500,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: valueColor ?? GinaAppTheme.lightOnSurface,
                fontWeight: valueBold ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ],
    );
  }
}
