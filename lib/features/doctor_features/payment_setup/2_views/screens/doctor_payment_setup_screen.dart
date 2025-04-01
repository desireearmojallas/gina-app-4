import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/payment_setup/2_views/widgets/earnings_card.dart';
import 'package:gina_app_4/features/doctor_features/payment_setup/2_views/widgets/payment_account_form.dart';

class DoctorPaymentSetupScreen extends StatelessWidget {
  const DoctorPaymentSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Setup',
          style: ginaTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.black87,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Earnings Card
              const EarningsCard(),
              const Gap(24),

              // Payment Account Setup Section
              Text(
                'Payment Account',
                style: ginaTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(12),
              Text(
                'Set up your account to receive payments from consultations',
                style: ginaTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const Gap(24),

              // Payment Account Form
              const PaymentAccountForm(),
            ],
          ),
        ),
      ),
    );
  }
} 