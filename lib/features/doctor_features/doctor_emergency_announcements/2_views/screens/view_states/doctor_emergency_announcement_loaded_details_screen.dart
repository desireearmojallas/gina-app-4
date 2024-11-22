import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/screens/view_states/doctor_emergency_announcement_create_announcement.dart';

class DoctorEmergencyAnnouncementsLoadedDetailsScreen extends StatelessWidget {
  const DoctorEmergencyAnnouncementsLoadedDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    //! todo: temporary scaffold will replace once bloc is implemented
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Announcement'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: FloatingActionButton(
          onPressed: () {
            //! temporary route
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DoctorEmergencyAnnouncementCreateAnnouncementScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: IntrinsicHeight(
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
                        child: Expanded(
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
                              Text(
                                'Desiree Armojallas',
                                style: ginaTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.visible,
                                softWrap: true,
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
                            'December 18, 2024',
                            style: ginaTheme.bodySmall?.copyWith(
                              color: GinaAppTheme.lightTertiaryContainer,
                              fontWeight: FontWeight.w600,
                              fontSize: 11.0,
                            ),
                          ),
                          const Gap(5),
                          Text(
                            '10:00 AM - 11:00 AM',
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
                    '📢 Emergency Announcement:\n\nMs. Desiree Armojallas, due to unforeseen circumstances, we kindly ask you to reschedule your OB-GYN appointment through the app at your earliest convenience. Thank you for your understanding!',
                    style: ginaTheme.labelMedium,
                    maxLines: null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
