import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/doctor_rating_badge/doctor_rating_badge.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget forumHeader(
    {required final ForumModel forumPost,
    required final int doctorRatingId,
    required BuildContext context}) {
  final ginaTheme = Theme.of(context);
  return forumPost.isDoctor
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoctorRatingBadge(
              doctorRating: doctorRatingId,
              width: 100,
            ),
            const Gap(10),
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  foregroundImage: AssetImage(
                    Images.doctorProfileIcon2,
                  ),
                ),
                const Gap(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Dr. ${forumPost.postedBy}',
                          style: ginaTheme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
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
                      "Posted ${timeago.format(forumPost.postedAt.toDate(), locale: 'en')}",
                      style: ginaTheme.textTheme.bodySmall?.copyWith(
                        color: GinaAppTheme.lightOutline,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
      : Row(
          children: [
            CircleAvatar(
              radius: 20,
              foregroundImage: AssetImage(
                Images.patientProfileIcon,
              ),
            ),
            const Gap(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  forumPost.postedBy,
                  style: ginaTheme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Posted ${timeago.format(forumPost.postedAt.toDate(), locale: 'en')}",
                  style: ginaTheme.textTheme.bodySmall?.copyWith(
                    color: GinaAppTheme.lightOutline,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        );
}
