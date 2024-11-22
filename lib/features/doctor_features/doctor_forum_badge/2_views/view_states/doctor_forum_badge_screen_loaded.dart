import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forum_badge/2_views/widgets/badges_list.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forum_badge/2_views/widgets/doctor_forum_badge_card.dart';

class DoctorForumBadgeScreenLoaded extends StatelessWidget {
  const DoctorForumBadgeScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
        child: Center(
      child: Column(
        children: [
          const Gap(20),
          //TODO: ADD BADGE CARDS HERE : WILL CHANGE ONCE BLOC IS IMPLEMENTED
          DoctorForumBadgeCard(
            formattedDate: 'November 1, 2021',
            badgeName: 'New Doctor',
            backgroundImage: Images.newDoctorForumBadgeBackground,
            nextBadgeName: 'Contributing\nDoctor',
            currentBadgeColor: Colors.grey[500],
            nextBadgeColor: GinaAppTheme.lightTertiary,
            progress: 5,
            progressValue: 10,
            nextBadgeQuota: 1,
          ),

          const Gap(30),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Badges'.toUpperCase(),
              style: ginaTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Gap(15),

          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BadgesList(
                badgeName: 'Top Doctor',
                badgeDescription:
                    'Earned by making at least 50 forum posts or replies in a month.',
                badgeColor: Color(0xffD14633),
              ),
              Gap(10),
              BadgesList(
                badgeName: 'Active Doctor',
                badgeDescription:
                    'Earned by making at least 10 forum posts or replies in a month.',
                badgeColor: GinaAppTheme.pendingTextColor,
              ),
              Gap(10),
              BadgesList(
                badgeName: 'Contributing Doctor',
                badgeDescription:
                    'Earned by joining the forum and making at least 1 post or reply.',
                badgeColor: GinaAppTheme.lightTertiary,
              ),
            ],
          ),

          const Gap(60),

          SizedBox(
            height: size.height * 0.06,
            width: size.width * 0.9,
            child: FilledButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/doctorForumsPost');
              },
              child: Text(
                'Go to Forums',
                style: ginaTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
