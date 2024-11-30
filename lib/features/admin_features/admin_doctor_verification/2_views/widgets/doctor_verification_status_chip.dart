// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/doctor_details_state_widgets/declined_verification_information_dialog.dart';

class DoctorVerificationStatusChip extends StatelessWidget {
  final int verificationStatus;
  final double scale;
  final String declinedReason;
  const DoctorVerificationStatusChip({
    super.key,
    required this.verificationStatus,
    this.scale = 1.0,
    required this.declinedReason,
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

    double adjustedFontSize(double originalFontSize) {
      return scale != 1.0 ? originalFontSize * (scale - 0.5) : originalFontSize;
    }

    Widget chip = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (status == DoctorVerificationStatus.declined) {
            declinedVerificationInformationDialog(
              context,
              declinedReason,
            );
          }
        },
        child: Container(
          width: size.width * 0.04 * scale,
          height: size.height * 0.02 * scale,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10 * scale),
            color: buttonColor,
          ),
          child: Center(
            child: Text(
              buttonText,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: GinaAppTheme.appbarColorLight,
                    fontWeight: FontWeight.w500,
                    fontSize: adjustedFontSize(
                      Theme.of(context).textTheme.labelSmall?.fontSize ?? 12.0,
                    ),
                  ),
            ),
          ),
        ),
      ),
    );

    return status == DoctorVerificationStatus.declined
        ? Tooltip(
            message: 'Click to view declined reason',
            child: chip,
          )
        : chip;
  }
}
