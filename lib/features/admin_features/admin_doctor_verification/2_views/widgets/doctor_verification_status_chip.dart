import 'package:flutter/material.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class DoctorVerificationStatusChip extends StatelessWidget {
  final int verificationStatus;
  const DoctorVerificationStatusChip({
    super.key,
    required this.verificationStatus,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DoctorVerificationStatus status =
        DoctorVerificationStatus.values[verificationStatus];
    String buttonText;
    Color buttonColor;

    switch (status) {
      case DoctorVerificationStatus.pending:
        buttonText = 'Pending';
        buttonColor = GinaAppTheme.pendingTextColor;

        break;
      case DoctorVerificationStatus.approved:
        buttonText = 'Approved';
        buttonColor = GinaAppTheme.approvedTextColor;
        break;
      case DoctorVerificationStatus.declined:
        buttonText = 'Declined';
        buttonColor = GinaAppTheme.declinedTextColor;
        break;
    }

    return Container(
      width: size.width * 0.04,
      height: size.height * 0.02,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: buttonColor,
      ),
      child: Center(
        child: Text(
          buttonText,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: GinaAppTheme.appbarColorLight,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
