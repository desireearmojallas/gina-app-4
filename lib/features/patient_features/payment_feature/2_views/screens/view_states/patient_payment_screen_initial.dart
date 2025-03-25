import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/dashed_divider.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/2_views/bloc/patient_payment_bloc.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/2_views/widgets/rounded_rectangle_receipt_base.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/2_views/widgets/payment_method_card.dart';

class PatientPaymentScreenInitial extends StatelessWidget {
  const PatientPaymentScreenInitial({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Invoice
            NotchedRoundedRectangle(
              width: size.width,
              height: 150,
              color: Colors.white,
              notchOffsetY: 125,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(Images.appLogo, width: 30),
                      const Gap(10),
                      Text(
                        'Appointment Invoice',
                        style: ginaTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const Gap(25),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InvoiceDetailColumn(
                            title: 'Invoice Number',
                            value: '123456',
                          ),
                          InvoiceDetailColumn(
                            title: 'Date',
                            value: 'January 1, 2025',
                          ),
                        ],
                      ),
                      const Gap(10),
                      Divider(
                        color:
                            GinaAppTheme.lightSurfaceVariant.withOpacity(0.5),
                      ),
                      const Gap(10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Consultation with Dr. Jabawookez Choy',
                          style: ginaTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Gap(15),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InvoiceDetailColumn(
                            title: 'Consultation Type',
                            value: 'Online Consultation',
                          ),
                          InvoiceDetailColumn(
                            title: 'Price',
                            value: '₱1,000.00',
                          ),
                        ],
                      ),
                      const Gap(15),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InvoiceDetailColumn(
                            title: 'Payment Status',
                            value: 'Not yet paid',
                          ),
                        ],
                      ),
                      const Gap(15),
                      DashedDivider(
                        color: GinaAppTheme.lightSurfaceVariant.withOpacity(1),
                      ),
                      const Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: ginaTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: GinaAppTheme.lightOutline,
                            ),
                          ),
                          Text(
                            '₱1,000.00',
                            style: ginaTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: GinaAppTheme.lightTertiaryContainer,
                            ),
                          ),
                        ],
                      ),
                      Gap(10),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(24),

            // Payment Methods
            Text(
              'Payment Method',
              style: ginaTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const Gap(12),
            BlocBuilder<PatientPaymentBloc, PatientPaymentState>(
              builder: (context, state) {
                return Column(
                  children: [
                    PaymentMethodCard(
                      icon: Icons.credit_card_rounded,
                      title: 'Credit/Debit Card',
                      subtitle: 'Pay with your card',
                      isSelected: state.selectedPaymentMethod ==
                          PaymentMethod.creditCard,
                      onTap: () {
                        context.read<PatientPaymentBloc>().add(
                              SelectPaymentMethod(PaymentMethod.creditCard),
                            );
                      },
                    ),
                    const Gap(8),
                    PaymentMethodCard(
                      icon: Icons.account_balance_rounded,
                      title: 'Bank Transfer',
                      subtitle: 'Transfer from your bank account',
                      isSelected: state.selectedPaymentMethod ==
                          PaymentMethod.bankTransfer,
                      onTap: () {
                        context.read<PatientPaymentBloc>().add(
                              SelectPaymentMethod(PaymentMethod.bankTransfer),
                            );
                      },
                    ),
                    const Gap(8),
                    PaymentMethodCard(
                      icon: Icons.payment_rounded,
                      title: 'E-Wallet',
                      subtitle: 'Pay with e-wallet',
                      isSelected:
                          state.selectedPaymentMethod == PaymentMethod.eWallet,
                      onTap: () {
                        context.read<PatientPaymentBloc>().add(
                              SelectPaymentMethod(PaymentMethod.eWallet),
                            );
                      },
                    ),
                  ],
                );
              },
            ),
            const Gap(32),

            // Pay Button
            SizedBox(
              width: size.width,
              height: 50,
              child: BlocBuilder<PatientPaymentBloc, PatientPaymentState>(
                builder: (context, state) {
                  return FilledButton(
                    onPressed: state.selectedPaymentMethod != null
                        ? () {
                            // TODO: Implement payment processing
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: GinaAppTheme.lightTertiaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Pay Now',
                      style: ginaTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvoiceDetailColumn extends StatelessWidget {
  final String title;
  final String value;

  const InvoiceDetailColumn({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: ginaTheme.bodySmall?.copyWith(
            color: GinaAppTheme.lightOutline,
          ),
        ),
        const Gap(5),
        Text(
          value,
          style: ginaTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
