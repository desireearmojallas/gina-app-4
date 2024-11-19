import 'package:flutter/material.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class AdminPatientAppointmentStatusChip extends StatelessWidget {
  final int appointmentStatus;
  const AdminPatientAppointmentStatusChip({
    super.key,
    required this.appointmentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    AppointmentStatus status = AppointmentStatus.values[appointmentStatus];
    String buttonText;
    Color buttonColor;

    switch (status) {
      case AppointmentStatus.pending:
        buttonText = 'Pending';
        buttonColor = GinaAppTheme.pendingTextColor;
        break;

      case AppointmentStatus.confirmed:
        buttonText = 'Confirmed';
        buttonColor = GinaAppTheme.approvedTextColor;
        break;

      case AppointmentStatus.completed:
        buttonText = 'Completed';
        buttonColor = GinaAppTheme.lightTertiaryContainer;
        break;

      case AppointmentStatus.cancelled:
        buttonText = 'Cancelled';
        buttonColor = GinaAppTheme.cancelledTextColor;
        break;

      case AppointmentStatus.declined:
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
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
