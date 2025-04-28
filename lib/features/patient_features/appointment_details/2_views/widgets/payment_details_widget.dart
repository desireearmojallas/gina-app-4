import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:intl/intl.dart';

class PaymentDetailsWidget extends StatelessWidget {
  final AppointmentModel appointment;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  const PaymentDetailsWidget({
    super.key,
    required this.appointment,
    required this.labelStyle,
    required this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointment.appointmentUid)
          .collection('payments')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 150,
            child: Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CustomLoadingIndicator(),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 100,
            child: Center(
              child: Text(
                'Error loading payment data',
                style: valueStyle,
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SizedBox(
            height: 100,
            child: Center(
              child: Text(
                'No payment information available',
                style: valueStyle,
              ),
            ),
          );
        }

        final paymentData =
            snapshot.data!.docs.first.data() as Map<String, dynamic>;
        final paymentStatus = paymentData['status'] as String? ?? '';
        final refundStatus = paymentData['refundStatus'] as String?;
        final amount = appointment.amount ?? 0.0;

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
        final totalAmount = (rawTotalAmount != null && rawTotalAmount > 0.0)
            ? rawTotalAmount
            : amount + effectivePlatformFeeAmount;

        final refundAmount = paymentData['refundAmount'] as double?;
        final paymentMethod =
            paymentData['paymentMethod'] as String? ?? 'Xendit';
        final linkedAt = paymentData['linkedAt'] as Timestamp?;

        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Base Fee row
              _buildPaymentRow(
                'Base Fee',
                '₱${NumberFormat('#,##0.00').format(amount)}',
              ),
              const SizedBox(height: 15),
              // Platform Fee row
              _buildPaymentRow(
                'Platform Fee (${(platformFeePercentage * 100).toInt()}%)',
                '₱${NumberFormat('#,##0.00').format(platformFeeAmount)}',
              ),
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
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
                      color: _getPaymentStatusColor(paymentStatus)
                          .withOpacity(0.1),
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
              const SizedBox(height: 15),
              // Payment Method row
              _buildFlexibleRow(
                'Payment Method',
                paymentMethod,
                context,
                isBold: true,
              ),
              const SizedBox(height: 15),
              // Payment Date row
              _buildPaymentRow(
                'Payment Date',
                linkedAt != null
                    ? DateFormat('MMMM d, yyyy h:mm a')
                        .format(linkedAt.toDate())
                    : 'N/A',
              ),
              // Refund details if available
              if (refundStatus != null) ...[
                const SizedBox(height: 15),
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
                        color: _getRefundStatusColor(refundStatus)
                            .withOpacity(0.1),
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
                  const SizedBox(height: 15),
                  _buildPaymentRow(
                    'Refund Amount',
                    '₱${NumberFormat('#,##0.00').format(refundAmount)}',
                    valueColor: Colors.orange,
                    valueBold: true,
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  Row _buildPaymentRow(String label, String value,
      {Color? valueColor, bool valueBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelStyle,
        ),
        Text(
          value,
          style: valueColor != null || valueBold
              ? valueStyle.copyWith(
                  color: valueColor,
                  fontWeight: valueBold ? FontWeight.bold : null,
                )
              : valueStyle,
        ),
      ],
    );
  }

  Row _buildFlexibleRow(String label, String value, BuildContext context,
      {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: Text(
            label,
            style: labelStyle,
          ),
        ),
        Flexible(
          flex: 2,
          child: Text(
            value,
            style: isBold
                ? valueStyle.copyWith(fontWeight: FontWeight.bold)
                : valueStyle,
            textAlign: TextAlign.end,
          ),
        ),
      ],
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
