import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/0_model/emergency_announcements_model.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/emergency_announcements/1_controllers/emergency_announcement_controllers.dart';
import 'package:gina_app_4/features/patient_features/emergency_announcements/2_views/bloc/emergency_announcements_bloc.dart';
import 'package:intl/intl.dart';

/// A dialog for displaying emergency announcements to patients
class EmergencyNotificationsAlertDialog extends StatelessWidget {
  final EmergencyAnnouncementModel? announcement;

  const EmergencyNotificationsAlertDialog({
    super.key,
    this.announcement,
  });

  void _markAnnouncementAsClicked(BuildContext context) {
    debugPrint('🔔 DIALOG: Marking announcement as clicked initial');
    debugPrint('🔔 DIALOG: Announcement: $announcement');

    if (announcement != null) {
      // DON'T create a new controller - use Firebase directly
      final currentPatientUid = FirebaseAuth.instance.currentUser?.uid;

      debugPrint(
          '🔔 DIALOG: Current patient UID from Firebase: $currentPatientUid');
      debugPrint(
          '🔔 DIALOG: Patient UIDs in announcement: ${announcement!.patientUids}');

      if (currentPatientUid != null) {
        debugPrint(
            '🔔 DIALOG: Marking announcement ${announcement!.emergencyId} as clicked by $currentPatientUid');

        // Get direct Firestore reference to update immediately
        FirebaseFirestore.instance
            .collection('emergencyAnnouncements')
            .doc(announcement!.emergencyId)
            .update({'clickedByPatients.$currentPatientUid': true}).then((_) {
          debugPrint('✅ DIALOG: Direct Firestore update succeeded');

          // Verify update worked
          FirebaseFirestore.instance
              .collection('emergencyAnnouncements')
              .doc(announcement!.emergencyId)
              .get()
              .then((doc) {
            final data = doc.data();
            if (data != null && data['clickedByPatients'] != null) {
              debugPrint(
                  '✅ DIALOG: Updated clickedByPatients: ${data['clickedByPatients']}');
            }
          });
        }).catchError((e) =>
                debugPrint('❌ DIALOG: Direct Firestore update failed: $e'));

        // Also dispatch through bloc for state management
        context.read<EmergencyAnnouncementsBloc>().add(
              MarkAnnouncementAsClickedEvent(
                emergencyId: announcement!.emergencyId,
                patientUid: currentPatientUid,
              ),
            );
      } else {
        debugPrint('⛔️ DIALOG: No current user UID available!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the model data if provided, otherwise use defaults
    final message = announcement?.message ??
        'There is an emergency situation you should be aware of. Please stay alert and follow safety instructions.';

    final createdBy = announcement?.createdBy.isNotEmpty ?? false
        ? 'From Dr. ${announcement!.createdBy}'
        : 'Dr. Bakla';

    final timestamp = announcement?.createdAt ?? Timestamp.now();

    // Find the appropriate appointment UID for the current patient
    String? myAppointmentUid;
    if (announcement != null) {
      final currentPatientUid =
          EmergencyAnnouncementsController().currentPatient?.uid;

      // Check if we have a mapping for this patient
      if (currentPatientUid != null &&
          announcement!.patientToAppointmentMap
              .containsKey(currentPatientUid)) {
        myAppointmentUid =
            announcement!.patientToAppointmentMap[currentPatientUid];
      }
      // If no direct mapping, try to find by index in lists
      else if (currentPatientUid != null) {
        int patientIndex = announcement!.patientUids
            .indexWhere((uid) => uid == currentPatientUid);

        if (patientIndex != -1 &&
            patientIndex < announcement!.appointmentUids.length) {
          myAppointmentUid = announcement!.appointmentUids[patientIndex];
        }
      }

      // Fallback to first appointment UID if available
      if (myAppointmentUid == null &&
          announcement!.appointmentUids.isNotEmpty) {
        myAppointmentUid = announcement!.appointmentUids.first;
      }
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: GinaAppTheme.declinedTextColor,
          width: 2,
        ),
      ),
      icon: const Icon(
        Icons.warning_amber_rounded,
        color: GinaAppTheme.declinedTextColor,
        size: 32,
      ),
      title: const Text(
        'Emergency Alert',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: GinaAppTheme.declinedTextColor,
        ),
      ),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            const Gap(30),
            if (createdBy.isNotEmpty)
              Text(
                createdBy,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            const Gap(12),
            Row(
              children: [
                Text(
                  'Issued: ${_formatTimestamp(timestamp)}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                if (announcement?.profileImage != null &&
                    announcement!.profileImage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(announcement!.profileImage),
                    ),
                  ),
              ],
            ),
            const Gap(15),
            Text(
              'Announcement ID: ${announcement?.emergencyId}',
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey[600],
              ),
            ),
            const Gap(2),
            Text(
              'My Appointment ID: ${myAppointmentUid ?? "N/A"}',
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Dismiss'),
        ),
        ElevatedButton(
          onPressed: () {
            // Mark as clicked
            debugPrint('Clicked "View details" button');
            _markAnnouncementAsClicked(context);

            // IMPORTANT: Capture the bloc BEFORE popping the dialog
            final appointmentBloc = context.read<AppointmentBloc>();

            Navigator.of(context).pop();

            if (announcement != null && myAppointmentUid != null) {
              Navigator.pushNamed(context, '/emergencyAnnouncements')
                  .then((value) {
                // Use the captured bloc variable instead of context.read
                appointmentBloc.add(
                  NavigateToAppointmentDetailsEvent(
                    doctorUid: announcement!.doctorUid,
                    appointmentUid: myAppointmentUid!,
                  ),
                );
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: GinaAppTheme.declinedTextColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('View details'),
        ),
      ],
    );
  }

  // Format timestamp to a readable date/time
  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // If less than 1 minute ago
    if (difference.inMinutes < 1) {
      return 'just now';
    }
    // If less than 1 hour ago
    else if (difference.inHours < 1) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    }
    // If less than 24 hours ago
    else if (difference.inDays < 1) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    }
    // If less than 7 days ago
    else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    }
    // Otherwise show the full date
    else {
      return DateFormat('MMM dd, yyyy \u2022 h:mm a').format(dateTime);
    }
  }
}
