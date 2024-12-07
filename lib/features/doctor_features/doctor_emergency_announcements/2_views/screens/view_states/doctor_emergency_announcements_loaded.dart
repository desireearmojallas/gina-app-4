import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/0_model/emergency_announcements_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/bloc/doctor_emergency_announcements_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/screens/view_states/doctor_emergency_announcement_initial.dart';

class DoctorEmergencyAnnouncementsLoadedScreen extends StatelessWidget {
  final sampleChecker = false;
  final List<EmergencyAnnouncementModel> emergencyAnnouncements;
  const DoctorEmergencyAnnouncementsLoadedScreen(
      {super.key, required this.emergencyAnnouncements});

  @override
  Widget build(BuildContext context) {
    final doctorEmergencyAnnouncementsBloc =
        context.read<DoctorEmergencyAnnouncementsBloc>();
    final ginaTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {},
      child: sampleChecker
          ? const DoctorEmergencyAnnouncementInitialScreen()
          : ScrollbarCustom(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: emergencyAnnouncements.length,
                  itemBuilder: (context, index) {
                    final emergencyAnnouncement = emergencyAnnouncements[index];
                    return InkWell(
                      onTap: () {
                        doctorEmergencyAnnouncementsBloc.add(
                          NavigateToDoctorCreatedAnnouncementEvent(
                            emergencyAnnouncement: emergencyAnnouncement,
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        height: size.height * 0.1,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Desiree Armojallas',
                                      style: ginaTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Good day! I will be out of town for a week.',
                                      style: ginaTheme.bodySmall,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(5),
                              Text(
                                '12:00 PM',
                                style: ginaTheme.bodySmall?.copyWith(
                                  color: GinaAppTheme.lightOutline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
