import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class AlertDialogForExceedingFaceToFaceAppointment extends StatelessWidget {
  final String patientName;
  final DateTime scheduledEndTime;
  final DateTime currentTime;
  final VoidCallback? onConcludeAppointment;
  final VoidCallback? onExtendAppointment;
  final VoidCallback? onDismiss;

  const AlertDialogForExceedingFaceToFaceAppointment({
    super.key,
    this.patientName = 'Patient Name',
    required this.scheduledEndTime,
    required this.currentTime,
    this.onConcludeAppointment,
    this.onExtendAppointment,
    this.onDismiss,
  });

  String get timeExceededText {
    final difference = currentTime.difference(scheduledEndTime);
    if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} '
          '${difference.inMinutes % 60} minute${difference.inMinutes % 60 != 1 ? 's' : ''}';
    } else {
      return '${difference.inMinutes} minute${difference.inMinutes != 1 ? 's' : ''}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('h:mm a');

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: GinaAppTheme.declinedTextColor,
          width: 1.5,
        ),
      ),
      icon: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: GinaAppTheme.declinedTextColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          MingCute.time_fill,
          color: GinaAppTheme.declinedTextColor,
          size: 32,
        ),
      ),
      title: const Text(
        'Appointment Time Exceeded',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: GinaAppTheme.declinedTextColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      // Use content for everything including buttons to avoid actions list issues
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Your appointment with $patientName has exceeded its scheduled end time.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(20),
          _buildInfoCard(context),
          const Gap(16),
          const Text(
            'Please conclude this appointment or extend the time. Other patients may be waiting for their scheduled appointments.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const Gap(24),
          // Action buttons - now properly inside a column
          Row(
            children: [
              // Extend time - secondary action
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      onExtendAppointment ?? () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size.fromHeight(56), // Set fixed height
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Extend Time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '(30 mins)',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(12),
              // Conclude now - primary action
              Expanded(
                child: ElevatedButton(
                  onPressed: onConcludeAppointment ??
                      () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GinaAppTheme.lightTertiaryContainer,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size.fromHeight(56), // Set fixed height
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Gap(7),
                      Text(
                        'Conclude Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(7),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Gap(10),
          // Dismiss button
          TextButton(
            onPressed: onDismiss ?? () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Dismiss for Now',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '(5 mins)',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final timeFormat = DateFormat('h:mm a');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            Icons.schedule,
            'Scheduled end time: ${timeFormat.format(scheduledEndTime)}',
          ),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.timer,
            'Current time: ${timeFormat.format(currentTime)}',
          ),
          const Divider(height: 24),
          _buildInfoRow(
            MingCute.alarm_1_fill,
            'Time exceeded: $timeExceededText',
            textColor: GinaAppTheme.declinedTextColor,
            iconColor: GinaAppTheme.declinedTextColor,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    dynamic icon,
    String text, {
    Color? textColor,
    Color? iconColor,
    FontWeight? fontWeight,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: iconColor ?? Colors.grey[700],
        ),
        const Gap(12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: textColor ?? Colors.grey[800],
              fontWeight: fontWeight ?? FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
