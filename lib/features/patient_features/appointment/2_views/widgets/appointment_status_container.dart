import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class AppointmentStatusContainer extends StatelessWidget {
  final int appointmentStatus;
  const AppointmentStatusContainer({
    super.key,
    required this.appointmentStatus,
  });

  @override
  Widget build(BuildContext context) {
    String statusText = '';
    Color statusColor = Colors.white;

    switch (appointmentStatus) {
      case 0:
        statusText = 'Pending';
        statusColor = GinaAppTheme.pendingTextColor;
        break;
      case 1:
        statusText = 'Approved';
        statusColor = GinaAppTheme.approvedTextColor;
        break;
      case 2:
        statusText = 'Completed';
        statusColor = GinaAppTheme.lightSecondary;
        break;
      case 3:
        statusText = 'Cancelled';
        statusColor = GinaAppTheme.lightOutline;
        break;
      case 4:
        statusText = 'Declined';
        statusColor = GinaAppTheme.declinedTextColor;
    }

    return Container(
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(9),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      child: Text(
        statusText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
