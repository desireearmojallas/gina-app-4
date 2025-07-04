import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/0_model/emergency_announcements_model.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/screens/appointment_screen.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/screens/view_states/appointment_details_status_screen.dart';
import 'package:gina_app_4/features/patient_features/emergency_announcements/1_controllers/emergency_announcement_controllers.dart';
import 'package:gina_app_4/features/patient_features/emergency_announcements/2_views/bloc/emergency_announcements_bloc.dart';
import 'package:gina_app_4/features/patient_features/emergency_announcements/2_views/screens/view_states/emergency_announcement_empty_state.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class EmergencyAnnouncementScreenLoaded extends StatelessWidget {
  final List<EmergencyAnnouncementModel> emergencyAnnouncements;
  final String doctorMedicalSpecialty;

  const EmergencyAnnouncementScreenLoaded({
    super.key,
    required this.emergencyAnnouncements,
    required this.doctorMedicalSpecialty,
  });

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AppointmentBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<EmergencyAnnouncementsBloc>(),
        ),
      ],
      child: BlocListener<AppointmentBloc, AppointmentState>(
        listener: (context, state) {
          if (state is AppointmentDetailsState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: GinaPatientAppBar(
                    title: 'Appointment Details',
                  ),
                  floatingActionButton: Padding(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    child: (state is ConsultationHistoryState &&
                                state.appointment.appointmentStatus ==
                                    AppointmentStatus.completed.index) ||
                            ((state.appointment.appointmentStatus ==
                                    AppointmentStatus.confirmed.index ||
                                state.appointment.appointmentStatus ==
                                    AppointmentStatus.completed.index))
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildFloatingActionButton(
                                heroTag: 'consultation',
                                icon: MingCute.message_3_fill,
                                onPressed: () async {
                                  await context
                                      .read<AppointmentBloc>()
                                      .handleConsultationNavigation(
                                          state, context);
                                },
                                context: context,
                              ),
                              const Gap(10),
                              buildFloatingActionButton(
                                heroTag: 'uploadPrescription',
                                icon: MingCute.upload_line,
                                onPressed: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.pushNamed(
                                      context, '/uploadPrescription');
                                },
                                context: context,
                                isOkayToUploadPrescription: false,
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ),
                  body: AppointmentDetailsStatusScreen(
                    appointment: state.appointment,
                    doctorDetails: state.doctorDetails,
                    currentPatient: state.currentPatient,
                  ),
                ),
              ),
            );
          }
        },
        child: emergencyAnnouncements.isEmpty
            ? const EmergencyAnnouncementEmptyState()
            : ScrollbarCustom(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 20.0),
                    itemCount: emergencyAnnouncements.length,
                    itemBuilder: (context, index) {
                      final emergencyAnnouncement =
                          emergencyAnnouncements[index];

                      final controller = EmergencyAnnouncementsController();
                      final currentPatientUid =
                          FirebaseAuth.instance.currentUser?.uid;

// Use FutureBuilder to handle the asynchronous appointment lookup
                      return FutureBuilder<String?>(
                        future: controller.findAppointmentForPatient(
                            emergencyAnnouncement, currentPatientUid),
                        builder: (context, snapshot) {
                          final myAppointmentUid = snapshot.data;

                          // Time formatting code...
                          DateTime now = DateTime.now();
                          DateTime createdAt =
                              emergencyAnnouncement.createdAt.toDate();
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

                          return FutureBuilder<bool>(
                            future: myAppointmentUid != null
                                ? context
                                    .read<EmergencyAnnouncementsBloc>()
                                    .isCompletedAppointment(myAppointmentUid)
                                : Future.value(false),
                            builder: (context, completedSnapshot) {
                              final isCompleted =
                                  completedSnapshot.data ?? false;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: isCompleted
                                        ? const []
                                        : [GinaAppTheme.defaultBoxShadow],
                                    borderRadius: BorderRadius.circular(10),
                                    color: isCompleted
                                        ? Colors.white.withOpacity(0.3)
                                        : Colors.white,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundImage: AssetImage(
                                                  Images.doctorProfileIcon1),
                                            ),
                                            const Gap(10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Dr. ${emergencyAnnouncement.createdBy}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelLarge
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: isCompleted
                                                                ? GinaAppTheme
                                                                    .lightOnPrimaryColor
                                                                    .withOpacity(
                                                                        0.5)
                                                                : GinaAppTheme
                                                                    .lightOnPrimaryColor,
                                                          ),
                                                    ),
                                                    const Gap(5),
                                                    const Icon(
                                                      Icons.verified,
                                                      color: Colors.blue,
                                                      size: 15,
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  doctorMedicalSpecialty,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: GinaAppTheme
                                                            .lightOutline,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                                if (emergencyAnnouncement
                                                        .patientUids.length >
                                                    1) ...[
                                                  const Gap(8),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: GinaAppTheme
                                                          .lightSurfaceVariant,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                          MingCute.user_2_line,
                                                          color: GinaAppTheme
                                                              .lightOutline,
                                                          size: 12,
                                                        ),
                                                        const Gap(3),
                                                        Text(
                                                          'Sent to ${emergencyAnnouncement.patientUids.length} patients',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall
                                                                  ?.copyWith(
                                                                    color: GinaAppTheme
                                                                        .lightOutline,
                                                                    fontSize: 9,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            const Spacer(),
                                            Text(
                                              time,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      color: GinaAppTheme
                                                          .lightOutline),
                                            ),
                                          ],
                                        ),
                                        const Gap(20),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            emergencyAnnouncement.message,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: isCompleted
                                                      ? GinaAppTheme
                                                          .lightOutline
                                                      : GinaAppTheme
                                                          .lightOnPrimaryColor,
                                                ),
                                          ),
                                        ),
                                        const Gap(10),
                                        TextButton(
                                          onPressed: isCompleted ||
                                                  myAppointmentUid == null
                                              ? null
                                              : () {
                                                  context
                                                      .read<AppointmentBloc>()
                                                      .add(
                                                        NavigateToAppointmentDetailsEvent(
                                                          doctorUid:
                                                              emergencyAnnouncement
                                                                  .doctorUid,
                                                          appointmentUid:
                                                              myAppointmentUid,
                                                        ),
                                                      );
                                                },
                                          child: Text(
                                            isCompleted
                                                ? 'Appointment Complete'
                                                : 'View Appointment Details',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: isCompleted
                                                      ? GinaAppTheme
                                                          .lightOutline
                                                          .withOpacity(0.5)
                                                      : GinaAppTheme
                                                          .lightTertiaryContainer,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                        const Gap(10),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Announcement ID: ${emergencyAnnouncement.emergencyId}',
                                                style: ginaTheme.bodySmall
                                                    ?.copyWith(
                                                  color:
                                                      GinaAppTheme.lightOutline,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 9,
                                                ),
                                              ),
                                              const Gap(2),

                                              // // Get current patient's appointment ID
                                              // Builder(builder: (context) {
                                              //   final currentPatientUid =
                                              //       EmergencyAnnouncementsController()
                                              //           .currentPatient
                                              //           ?.uid;

                                              //   int patientIndex =
                                              //       emergencyAnnouncement.patientUids
                                              //           .indexWhere((uid) =>
                                              //               uid == currentPatientUid);

                                              //   String myAppointmentUid =
                                              //       patientIndex != -1 &&
                                              //               patientIndex <
                                              //                   emergencyAnnouncement
                                              //                       .appointmentUids
                                              //                       .length
                                              //           ? emergencyAnnouncement
                                              //                   .appointmentUids[
                                              //               patientIndex]
                                              //           : emergencyAnnouncement
                                              //               .appointmentUid;

                                              //   return Text(
                                              //     'My Appointment ID: $myAppointmentUid',
                                              //     style: Theme.of(context)
                                              //         .textTheme
                                              //         .bodySmall
                                              //         ?.copyWith(
                                              //           color:
                                              //               GinaAppTheme.lightOutline,
                                              //           fontWeight: FontWeight.w500,
                                              //           fontSize: 9,
                                              //         ),
                                              //   );
                                              // }),

                                              Text(
                                                'My Appointment ID: ${myAppointmentUid ?? "N/A"}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: GinaAppTheme
                                                          .lightOutline,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 9,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }),
              ),
      ),
    );
  }
}
