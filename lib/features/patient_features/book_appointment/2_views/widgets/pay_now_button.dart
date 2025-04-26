// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/screens/home_screen.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/2_views/screens/view_states/patient_payment_screen_initial.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/3_services/patient_payment_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class PayNowButton extends StatefulWidget {
  final String appointmentId;
  final String doctorName;
  final String patientName;
  final int modeOfAppointment;
  final double amount;
  final double platformFeePercentage;
  final double platformFeeAmount;
  final double totalAmount;
  final String appointmentDate;
  final String doctorId;
  final Function(String) onPaymentCreated;

  const PayNowButton({
    super.key,
    required this.appointmentId,
    required this.doctorName,
    required this.patientName,
    required this.modeOfAppointment,
    required this.amount,
    required this.appointmentDate,
    required this.doctorId,
    required this.onPaymentCreated,
    required this.platformFeePercentage,
    required this.platformFeeAmount,
    required this.totalAmount,
  });

  @override
  State<PayNowButton> createState() => _PayNowButtonState();
}

class _PayNowButtonState extends State<PayNowButton> {
  final PatientPaymentService _paymentService = PatientPaymentService();
  bool _isLoading = false;
  bool _isPaid = false;
  String? _invoiceUrl;
  Timer? _statusCheckTimer;
  int _statusCheckAttempts = 0;
  static const int maxAttempts = 60; // Check for 5 minutes (5s interval)

  @override
  void initState() {
    super.initState();
    _checkInitialPaymentStatus();
  }

  Future<void> _checkInitialPaymentStatus() async {
    try {
      final status = await _checkPaymentStatus(context, widget.appointmentId);
      if (status.toLowerCase() == 'paid') {
        setState(() {
          _isPaid = true;
        });
      }
    } catch (e) {
      debugPrint('Error checking initial payment status: $e');
    }
  }

  Future<void> _createPayment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _paymentService.createPaymentInvoice(
        appointmentId: widget.appointmentId,
        doctorName: widget.doctorName,
        patientName: widget.patientName,
        amount: widget.amount,
        platformFeePercentage: widget.platformFeePercentage,
        platformFeeAmount: widget.platformFeeAmount,
        totalAmount: widget.totalAmount,
        appointmentDate: widget.appointmentDate,
        consultationType: widget.modeOfAppointment == 0
            ? 'Online Consultation'
            : 'Face-to-Face',
        doctorId: widget.doctorId,
      );

      setState(() {
        _invoiceUrl = result['invoiceUrl'];
        _isLoading = false;
      });

      debugPrint('Payment invoice created successfully');
      widget.onPaymentCreated(_invoiceUrl!);

      if (_invoiceUrl != null) {
        if (!mounted) return;
        await launchUrl(Uri.parse(_invoiceUrl!));

        // Start polling for payment status
        _startPaymentStatusCheck();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating payment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String> _checkPaymentStatus(
      BuildContext context, String appointmentId) async {
    try {
      // First check pending_payments collection
      final paymentDoc = await FirebaseFirestore.instance
          .collection('pending_payments')
          .doc(appointmentId)
          .get();

      if (paymentDoc.exists) {
        final paymentData = paymentDoc.data()!;
        final invoiceId = paymentData['invoiceId'] as String;
        final currentStatus = paymentData['status'] as String? ?? 'pending';

        debugPrint(
            'Current payment status in pending_payments: $currentStatus');

        // If already marked as paid in Firestore, return paid
        if (currentStatus.toLowerCase() == 'paid') {
          return 'paid';
        }

        final paymentService = PatientPaymentService();
        final xenditStatus =
            await paymentService.checkXenditPaymentStatus(invoiceId);

        debugPrint('Xendit payment status: $xenditStatus');

        // If Xendit reports paid, update Firestore and return paid
        if (xenditStatus.toLowerCase() == 'paid') {
          await FirebaseFirestore.instance
              .collection('pending_payments')
              .doc(appointmentId)
              .update({
            'status': 'paid',
            'updatedAt': FieldValue.serverTimestamp(),
            'lastCheckedAt': FieldValue.serverTimestamp(),
          });
          return 'paid';
        }

        return xenditStatus.toLowerCase();
      }

      // If no record in pending_payments, check appointments/payments subcollection
      final appointmentPaymentsSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .collection('payments')
          .get();

      if (appointmentPaymentsSnapshot.docs.isNotEmpty) {
        final paymentData = appointmentPaymentsSnapshot.docs.first.data();
        final paymentStatus = paymentData['status'] as String? ?? 'pending';

        debugPrint(
            'Found payment record in appointments/payments: $paymentStatus');

        if (paymentStatus.toLowerCase() == 'paid') {
          return 'paid';
        }
        return paymentStatus.toLowerCase();
      }

      debugPrint('No payment records found in either collection');
      return 'not_found';
    } catch (e) {
      debugPrint('Error checking payment status: $e');
      return 'error';
    }
  }

  void _startPaymentStatusCheck() {
    _statusCheckTimer?.cancel();
    _statusCheckAttempts = 0;

    _statusCheckTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      _statusCheckAttempts++;

      if (_statusCheckAttempts >= maxAttempts) {
        timer.cancel();
        debugPrint('Payment status check timed out after 5 minutes');
        return;
      }

      try {
        final status = await _checkPaymentStatus(context, widget.appointmentId);
        debugPrint('Payment status check result: $status');

        if (status.toLowerCase() == 'paid') {
          timer.cancel();
          setState(() {
            _isPaid = true;
          });

          // Now that payment is confirmed as paid, link it to the appointment
          await _paymentService.linkPaymentToAppointment(
            widget.appointmentId,
            widget.appointmentId,
            widget.platformFeePercentage,
            widget.platformFeeAmount,
            widget.totalAmount,
            doctorId: widget.doctorId,
          );

          debugPrint(
              'Payment confirmed and linked to appointment successfully');

          HomeScreen.clearPendingPayment();

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment successful!',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        debugPrint('Error checking payment status: $e');
      }
    });
  }

  @override
  void dispose() {
    _statusCheckTimer?.cancel();
    super.dispose();
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
        gradient: LinearGradient(
          colors: _isPaid
              ? [Colors.grey[300]!, Colors.grey[400]!]
              : [
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
            onTap: _isPaid
                ? () {
                    HapticFeedback.mediumImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientPaymentScreenInitial(
                          appointmentId: widget.appointmentId,
                          doctorId: widget.doctorId,
                          doctorName: widget.doctorName,
                          patientName: widget.patientName,
                          modeOfAppointment: widget.modeOfAppointment,
                          amount: widget.amount,
                          platformFeePercentage: widget.platformFeePercentage,
                          platformFeeAmount: widget.platformFeeAmount,
                          totalAmount: widget.totalAmount,
                          appointmentDate: widget.appointmentDate,
                          existingInvoiceUrl: _invoiceUrl,
                          showReceipt: true,
                        ),
                      ),
                    );
                  }
                : () async {
                    final bookAppointmentBloc =
                        context.read<BookAppointmentBloc>();
                    HapticFeedback.mediumImpact();
                    debugPrint('Pay Now button clicked');
                    debugPrint('Appointment ID: ${widget.appointmentId}');
                    debugPrint('Amount: ${widget.amount}');

                    // First check if we're in reschedule mode by looking for existing payment
                    final pendingPayment = await bookAppointmentBloc
                        .fetchPendingPayment(widget.appointmentId);
                    if (pendingPayment != null) {
                      debugPrint('Found existing payment in reschedule mode');
                      final status =
                          pendingPayment['status'] as String? ?? 'pending';
                      debugPrint('Payment status: $status');

                      if (status.toLowerCase() == 'paid') {
                        debugPrint('Payment is already paid, showing receipt');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientPaymentScreenInitial(
                              appointmentId: widget.appointmentId,
                              doctorId: widget.doctorId,
                              doctorName: widget.doctorName,
                              patientName: widget.patientName,
                              modeOfAppointment: widget.modeOfAppointment,
                              amount: widget.amount,
                              platformFeePercentage:
                                  widget.platformFeePercentage,
                              platformFeeAmount: widget.platformFeeAmount,
                              totalAmount: widget.totalAmount,
                              appointmentDate: widget.appointmentDate,
                              existingInvoiceUrl: pendingPayment['invoiceUrl'],
                              showReceipt: true,
                            ),
                          ),
                        );
                        return;
                      }
                    }

                    // If not in reschedule mode or payment not found/not paid, proceed with normal flow
                    final paymentStatus = await _checkPaymentStatus(
                        context, widget.appointmentId);
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
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          GinaAppTheme.lightTertiaryContainer,
                                    ),
                              ),
                            ],
                          ),
                          content: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: GinaAppTheme.lightSurfaceVariant
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildReceiptRow(
                                  'Doctor',
                                  'Dr. ${widget.doctorName}',
                                  context,
                                ),
                                const Gap(8),
                                _buildReceiptRow(
                                  'Patient',
                                  widget.patientName,
                                  context,
                                ),
                                const Gap(8),
                                _buildReceiptRow(
                                  'Base Fee',
                                  '₱${NumberFormat('#,##0.00').format(widget.amount)}',
                                  context,
                                ),
                                const Gap(8),
                                _buildReceiptRow(
                                  'Platform Fee (${(widget.platformFeePercentage * 100).toInt()}%)',
                                  '₱${NumberFormat('#,##0.00').format(widget.platformFeeAmount)}',
                                  context,
                                ),
                                const Gap(8),
                                _buildReceiptRow(
                                  'Total Amount',
                                  '₱${NumberFormat('#,##0.00').format(widget.totalAmount)}',
                                  context,
                                  valueColor: Colors.green,
                                  valueBold: true,
                                ),
                                const Gap(8),
                                _buildReceiptRow(
                                  'Date',
                                  widget.appointmentDate,
                                  context,
                                ),
                                const Gap(8),
                                _buildReceiptRow(
                                  'Mode',
                                  widget.modeOfAppointment == 0
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
                                    builder: (context) =>
                                        PatientPaymentScreenInitial(
                                      appointmentId: widget.appointmentId,
                                      doctorId: widget.doctorId,
                                      doctorName: widget.doctorName,
                                      patientName: widget.patientName,
                                      modeOfAppointment:
                                          widget.modeOfAppointment,
                                      amount: widget.amount,
                                      platformFeePercentage:
                                          widget.platformFeePercentage,
                                      platformFeeAmount:
                                          widget.platformFeeAmount,
                                      totalAmount: widget.totalAmount,
                                      appointmentDate: widget.appointmentDate,
                                      existingInvoiceUrl: _invoiceUrl,
                                      showReceipt: true,
                                    ),
                                  ),
                                );
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    GinaAppTheme.lightTertiaryContainer,
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

                    if (bookAppointmentBloc.currentInvoiceUrl != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientPaymentScreenInitial(
                            appointmentId: widget.appointmentId,
                            doctorId: widget.doctorId,
                            doctorName: widget.doctorName,
                            patientName: widget.patientName,
                            modeOfAppointment: widget.modeOfAppointment,
                            amount: widget.amount,
                            platformFeePercentage: widget.platformFeePercentage,
                            platformFeeAmount: widget.platformFeeAmount,
                            totalAmount: widget.totalAmount,
                            appointmentDate: widget.appointmentDate,
                            existingInvoiceUrl:
                                bookAppointmentBloc.currentInvoiceUrl,
                          ),
                        ),
                      );
                      return;
                    }

                    await _createPayment();
                  },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (_isPaid
                              ? Colors.grey[300]
                              : GinaAppTheme.lightTertiaryContainer)
                          ?.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _isPaid
                          ? Icons.receipt_long_rounded
                          : Icons.account_balance_wallet_rounded,
                      color: _isPaid
                          ? Colors.grey[600]
                          : GinaAppTheme.lightTertiaryContainer,
                      size: 20,
                    ),
                  ),
                  const Gap(15),
                  Text(
                    _isPaid ? 'View Receipt' : 'Pay Now',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _isPaid
                              ? Colors.grey[600]
                              : GinaAppTheme.lightOnPrimaryColor,
                          letterSpacing: 0.3,
                        ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (_isPaid
                              ? Colors.grey[300]
                              : GinaAppTheme.lightTertiaryContainer)
                          ?.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: _isPaid
                          ? Colors.grey[600]
                          : GinaAppTheme.lightTertiaryContainer,
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
