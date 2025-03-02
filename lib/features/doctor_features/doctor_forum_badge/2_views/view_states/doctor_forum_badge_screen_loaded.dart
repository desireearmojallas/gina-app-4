import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/enum/enum.dart';

import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forum_badge/2_views/bloc/doctor_forum_badge_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forum_badge/2_views/widgets/badges_list.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forum_badge/2_views/widgets/doctor_forum_badge_card.dart';
import 'package:intl/intl.dart';

class DoctorForumBadgeScreenLoaded extends StatelessWidget {
  final DoctorModel doctor;
  const DoctorForumBadgeScreenLoaded({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    final profileBloc = context.read<DoctorForumBadgeBloc>();
    DateTime now = DateTime.now();
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    String formattedDate =
        DateFormat('MMMM dd, yyyy').format(firstDayOfNextMonth);

    double progress = doctor.createdPosts != null && doctor.repliedPosts != null
        ? doctor.createdPosts!.length.toDouble() +
            doctor.repliedPosts!.length.toDouble()
        : 0;
    int progressInt = doctor.createdPosts != null && doctor.repliedPosts != null
        ? doctor.createdPosts!.length + doctor.repliedPosts!.length
        : 0;

    debugPrint('doctor.doctorRatingId: ${doctor.doctorRatingId}');

    return RefreshIndicator(
      onRefresh: () async {
        profileBloc.add(GetForumBadgeEvent());
      },
      child: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            const Gap(20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Your current badge'.toUpperCase(),
                style: ginaTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Gap(15),

            // 0 == 0
            doctor.doctorRatingId == DoctorRating.newDoctor.index
                ? DoctorForumBadgeCard(
                    formattedDate: formattedDate,
                    badgeName: 'New Doctor',
                    backgroundImage: Images.newDoctorForumBadgeBackground,
                    nextBadgeName: 'Contributing\nDoctor',
                    currentBadgeColor: Colors.grey[500],
                    nextBadgeColor: GinaAppTheme.lightTertiary,
                    progress: progressInt,
                    progressValue: progress,
                    nextBadgeQuota: 1,
                  )
                : Container(),

            // 1 == 1
            doctor.doctorRatingId == DoctorRating.contributingDoctor.index
                ? DoctorForumBadgeCard(
                    formattedDate: formattedDate,
                    badgeName: 'Contributing Doctor',
                    backgroundImage:
                        Images.contributingDoctorForumBadgeBackground,
                    nextBadgeName: 'Active\nDoctor',
                    currentBadgeColor: GinaAppTheme.lightTertiary,
                    nextBadgeColor: GinaAppTheme.pendingTextColor,
                    progress: progressInt,
                    progressValue: progress,
                    nextBadgeQuota: 10,
                  )
                : Container(),

            // 2 == 2
            doctor.doctorRatingId == DoctorRating.activeDoctor.index
                ? DoctorForumBadgeCard(
                    formattedDate: formattedDate,
                    badgeName: 'Active Doctor',
                    backgroundImage: Images.activeDoctorForumBadgeBackground,
                    nextBadgeName: 'Top\nDoctor',
                    currentBadgeColor: GinaAppTheme.pendingTextColor,
                    nextBadgeColor: const Color(0xffD14633),
                    progress: progressInt,
                    progressValue: progress,
                    nextBadgeQuota: 50,
                  )
                : Container(),

            // 3 == 3
            doctor.doctorRatingId == DoctorRating.topDoctor.index
                ? DoctorForumBadgeCard(
                    formattedDate: formattedDate,
                    badgeName: 'Top Doctor',
                    backgroundImage: Images.topDoctorForumBadgeBackground,
                    nextBadgeName: 'Top\nDoctor',
                    currentBadgeColor: const Color(0xffD14633),
                    nextBadgeColor: const Color(0xffD14633),
                    progress: progressInt,
                    progressValue: progress,
                    nextBadgeQuota: 0,
                  )
                : Container(),

            // 3 == 3
            doctor.doctorRatingId == DoctorRating.inactiveDoctor.index
                ? SizedBox(
                    height: size.height * 0.1,
                    child: Center(
                      child: Text(
                        "No posts yet this month.\nShare your knowledge and earn your badge!",
                        style: ginaTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Container(),

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
                  Navigator.pushNamed(context, '/doctorForumsPost').then((_) {
                    profileBloc.add(GetForumBadgeEvent());
                  });
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
      )),
    );
  }
}
