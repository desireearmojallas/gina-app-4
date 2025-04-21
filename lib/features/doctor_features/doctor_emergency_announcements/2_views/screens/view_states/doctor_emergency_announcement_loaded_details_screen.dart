import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/gina_divider.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/0_model/emergency_announcements_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/bloc/doctor_emergency_announcements_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/widgets/dashed_line_painter_vertical.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class DoctorEmergencyAnnouncementsLoadedDetailsScreen extends StatelessWidget {
  final EmergencyAnnouncementModel emergencyAnnouncement;
  final AppointmentModel appointment;
  const DoctorEmergencyAnnouncementsLoadedDetailsScreen(
      {super.key,
      required this.emergencyAnnouncement,
      required this.appointment});

  @override
  Widget build(BuildContext context) {
    final doctorEmergencyAnnouncementsBloc =
        context.read<DoctorEmergencyAnnouncementsBloc>();
    final ginaTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    DateTime now = DateTime.now();
    DateTime createdAt = emergencyAnnouncement.createdAt.toDate();
    String formattedDate = DateFormat('MMMM d, yyyy').format(createdAt);
    String time;
    if (now.difference(createdAt).inHours < 24) {
      time = DateFormat.jm().format(createdAt);
    } else if (now.difference(createdAt).inDays == 1) {
      time = 'Yesterday';
    } else if (now.difference(createdAt).inDays <= 7) {
      time = DateFormat('EEEE').format(createdAt);
    } else {
      time = DateFormat.yMd().format(createdAt);
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                GinaAppTheme.defaultBoxShadow,
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PATIENT APPOINTMENTS',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  // If we have multiple appointment UIDs, show patient count
                  if (emergencyAnnouncement.appointmentUids.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'This announcement was sent to ${emergencyAnnouncement.patientNames.length} patients',
                        style: const TextStyle(
                          color: GinaAppTheme.lightOutline,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                  // Map over all patient names from the announcement
                  ...List.generate(
                    emergencyAnnouncement.patientNames.length,
                    (index) {
                      final patientName =
                          emergencyAnnouncement.patientNames[index];

                      // For appointment details, use the available info
                      // If index exceeds appointmentUids length, use the first one as fallback
                      final appointmentUid =
                          index < emergencyAnnouncement.appointmentUids.length
                              ? emergencyAnnouncement.appointmentUids[index]
                              : emergencyAnnouncement.appointmentUids.first;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            // Left: Patient name
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patientName,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Gap(4),
                                  Text(
                                    'Appointment ID: $appointmentUid',
                                    style: const TextStyle(
                                      color: GinaAppTheme.lightOutline,
                                      fontSize: 10.0,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // Add icon to indicate this is a sent announcement
                            const Icon(
                              MingCute.checks_line,
                              color: GinaAppTheme.lightTertiaryContainer,
                              size: 16,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          GinaDivider(),
          IntrinsicHeight(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  GinaAppTheme.defaultBoxShadow,
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                            Images.patientProfileIcon,
                          ),
                        ),
                        const Gap(15),
                        SizedBox(
                          width: size.width * 0.4,
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'To:',
                                  style: ginaTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: GinaAppTheme.lightOutline,
                                    fontSize: 11,
                                  ),
                                ),
                                const Gap(4),
                                if (emergencyAnnouncement.patientNames.length ==
                                    1)
                                  Text(
                                    emergencyAnnouncement.patientNames.first,
                                    style: ginaTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  )
                                else
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${emergencyAnnouncement.patientNames.length} patients',
                                        style: ginaTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                      ),
                                      const Gap(4),
                                      Text(
                                        emergencyAnnouncement.patientNames
                                            .join(', '),
                                        style: ginaTheme.bodySmall?.copyWith(
                                          color: GinaAppTheme.lightOutline,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formattedDate,
                              style: ginaTheme.bodySmall?.copyWith(
                                color: GinaAppTheme.lightTertiaryContainer,
                                fontWeight: FontWeight.w600,
                                fontSize: 11.0,
                              ),
                            ),
                            const Gap(5),
                            Text(
                              time,
                              style: ginaTheme.bodySmall?.copyWith(
                                color: GinaAppTheme.lightOutline,
                                fontSize: 10.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(15),
                    Text(
                      'Announcement ID: ${emergencyAnnouncement.emergencyId}',
                      style: ginaTheme.labelMedium?.copyWith(
                        color: GinaAppTheme.lightOutline,
                        fontSize: 10.0,
                      ),
                      maxLines: null,
                    ),
                    const Gap(15),
                    Text(
                      emergencyAnnouncement.message,
                      style: ginaTheme.labelMedium,
                      maxLines: null,
                    ),
                    const Gap(15),
                  ],
                ),
              ),
            ),
          ),
          const Gap(20),
          IconButton(
            padding: const EdgeInsets.all(10),
            onPressed: () {
              _showDeleteConfirmationDialog(
                  context, doctorEmergencyAnnouncementsBloc);
            },
            icon: const Icon(
              Icons.delete,
              color: GinaAppTheme.lightOnPrimaryColor,
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(GinaAppTheme.lightSurfaceVariant),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, DoctorEmergencyAnnouncementsBloc bloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
              const Text('Are you sure you want to delete this announcement?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(color: GinaAppTheme.lightOutline)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              onPressed: () {
                bloc.add(
                  DeleteEmergencyAnnouncementEvent(
                      emergencyAnnouncement: emergencyAnnouncement),
                );
                bloc.add(GetDoctorEmergencyAnnouncementsEvent());
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                  GinaAppTheme.lightTertiaryContainer,
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
