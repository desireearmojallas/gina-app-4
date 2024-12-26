import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/0_model/emergency_announcements_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/bloc/doctor_emergency_announcements_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/screens/view_states/doctor_emergency_announcement_initial.dart';
import 'package:intl/intl.dart';

class DoctorEmergencyAnnouncementsLoadedScreen extends StatelessWidget {
  final List<EmergencyAnnouncementModel> emergencyAnnouncements;
  const DoctorEmergencyAnnouncementsLoadedScreen(
      {super.key, required this.emergencyAnnouncements});

  @override
  Widget build(BuildContext context) {
    final doctorEmergencyAnnouncementsBloc =
        context.read<DoctorEmergencyAnnouncementsBloc>();
    final ginaTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return ScrollbarCustom(
      child: RefreshIndicator(
        onRefresh: () async {
          doctorEmergencyAnnouncementsBloc
              .add(GetDoctorEmergencyAnnouncementsEvent());
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Column(
              children: [
                emergencyAnnouncements.isEmpty
                    ? const DoctorEmergencyAnnouncementInitialScreen()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                        child: Image.asset(
                          Images.emergencyAnnouncementLoaded,
                          height: size.height * 0.22,
                        ),
                      ),
                const Text(
                  'STAY PREPARED!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(5),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 90.0),
                  child: Text(
                    'Notify affected patients promptly about changes to their scheduled appointments.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                const Gap(30),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        thickness: 1,
                        color: GinaAppTheme.lightSurfaceVariant,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Recent Emergency Announcements'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: GinaAppTheme.lightSecondary,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        thickness: 1,
                        color: GinaAppTheme.lightSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const Gap(10),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: emergencyAnnouncements.length,
                    itemBuilder: (context, index) {
                      final emergencyAnnouncement =
                          emergencyAnnouncements[index];
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

                      return InkWell(
                        onTap: () {
                          doctorEmergencyAnnouncementsBloc.add(
                            NavigateToDoctorCreatedAnnouncementEvent(
                              emergencyAnnouncement: emergencyAnnouncement,
                            ),
                          );
                        },
                        child: IntrinsicHeight(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                GinaAppTheme.defaultBoxShadow,
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(
                                      Images.patientProfileIcon,
                                    ),
                                  ),
                                  const Gap(15),
                                  SizedBox(
                                    width: size.width * 0.5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Announcement ID: ${emergencyAnnouncement.emergencyId}',
                                          style: ginaTheme.bodySmall?.copyWith(
                                            color: GinaAppTheme.lightOutline,
                                            fontSize: 9,
                                          ),
                                        ),
                                        const Gap(10),
                                        Text(
                                          emergencyAnnouncement.patientName,
                                          style: ginaTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Gap(10),
                                        SizedBox(
                                          width: size.width * 0.5,
                                          child: Text(
                                            emergencyAnnouncement.message,
                                            style: ginaTheme.bodySmall,
                                            maxLines: 6,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(20),
                                  SizedBox(
                                    width: size.width * 0.1,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        time,
                                        style: ginaTheme.bodySmall?.copyWith(
                                          color: GinaAppTheme.lightOutline,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
