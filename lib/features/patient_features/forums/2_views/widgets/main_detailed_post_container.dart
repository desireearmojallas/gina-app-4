import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/widgets/forum_header.dart';
import 'package:icons_plus/icons_plus.dart';

class MainDetailedPostContainer extends StatelessWidget {
  final ForumModel forumPost;
  final int doctorRatingId;
  const MainDetailedPostContainer({
    super.key,
    required this.forumPost,
    required this.doctorRatingId,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final ginaTheme = Theme.of(context);
    return Container(
      width: width * 0.94,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          GinaAppTheme.defaultBoxShadow,
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              forumPost.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
            ),
            const Gap(20),
            forumHeader(
              forumPost: forumPost,
              doctorRatingId: doctorRatingId,
              context: context,
            ),
            const Gap(20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                forumPost.content,
                style: const TextStyle(height: 1.8),
              ),
            ),
            const Gap(25),
            Row(
              children: [
                //TODO: IMPLEMENT LIKES
                const Icon(
                  CupertinoIcons.heart_fill,
                  size: 25,
                  color: GinaAppTheme.lightTertiaryContainer,
                ),
                const Gap(5),
                Text(
                  '18',
                  style: ginaTheme.textTheme.bodySmall?.copyWith(
                    color: GinaAppTheme.lightOutline,
                  ),
                ),
                // const Gap(20),
                // const Icon(
                //   MingCute.message_3_line,
                //   size: 20,
                //   color: GinaAppTheme.lightOutline,
                // ),
                // const Gap(5),
                // Text(
                //   //TODO: IMPLEMENT REPLIES
                //   '5 replies',
                //   style: ginaTheme.textTheme.bodySmall?.copyWith(
                //     color: GinaAppTheme.lightOutline,
                //   ),
                // ),
              ],
            ),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}
