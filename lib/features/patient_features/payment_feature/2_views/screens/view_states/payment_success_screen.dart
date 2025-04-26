import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String refNumber;
  final String date;
  final String time;
  final String paymentMethod;
  final String senderName;
  final String receiverName;
  final double amount;

  const PaymentSuccessScreen({
    super.key,
    required this.refNumber,
    required this.date,
    required this.time,
    required this.paymentMethod,
    required this.senderName,
    required this.receiverName,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Success Icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.green.shade500,
                        size: 32,
                      ),
                    ),
                    const Gap(16),
                    Text(
                      'Payment Success!',
                      style: ginaTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      '₱${amount.toStringAsFixed(2)}',
                      style: ginaTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade500,
                      ),
                    ),
                    const Gap(32),

                    // Receipt Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildReceiptRow('Ref Number', refNumber),
                          _buildReceiptRow('Date', date),
                          _buildReceiptRow('Time', time),
                          _buildReceiptRow('Payment Method', paymentMethod),
                          _buildReceiptRow('Sender Name', senderName),
                          _buildReceiptRow('Receiver Name', receiverName),
                          _buildReceiptRow('Payment Status', 'Success',
                              isSuccess: true),
                          const Divider(height: 24),
                          _buildReceiptRow(
                              'Total Amount', '₱${amount.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Buttons
              Column(
                children: [
                  FilledButton.tonal(
                    onPressed: () {
                      // TODO: Implement PDF receipt generation
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: Size(size.width, 48),
                      backgroundColor: Colors.grey.shade100,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.share_rounded, size: 20),
                        const Gap(8),
                        Text(
                          'Get PDF Receipt',
                          style: ginaTheme.titleSmall?.copyWith(
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(8),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: Size(size.width, 48),
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Back to Home',
                      style: ginaTheme.titleSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value,
      {bool isSuccess = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          if (isSuccess)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.green.shade500,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
