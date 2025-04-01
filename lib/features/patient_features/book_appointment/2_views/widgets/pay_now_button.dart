import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/2_views/screens/patient_payment_screen.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/2_views/screens/view_states/patient_payment_screen_initial.dart';

class PayNowButton extends StatelessWidget {
  final String appointmentId;
  final String doctorName;
  final int modeOfAppointment;
  final double amount;
  final DateTime appointmentDate;

  const PayNowButton({
    super.key,
    required this.appointmentId,
    required this.doctorName,
    required this.modeOfAppointment,
    required this.amount,
    required this.appointmentDate,
  });

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
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientPaymentScreenProvider(
                    appointmentId: appointmentId,
                    doctorName: doctorName,
                    modeOfAppointment: modeOfAppointment.toString(),
                    amount: amount,
                    appointmentDate: appointmentDate,
                  ),
                ),
              );
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
}
