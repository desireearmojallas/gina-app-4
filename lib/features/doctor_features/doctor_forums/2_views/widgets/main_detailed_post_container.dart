import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/widgets/forum_header.dart';

class MainDetailedDoctorPostContainer extends StatelessWidget {
  final ForumModel forumPost;
  final int doctorRatingId;
  const MainDetailedDoctorPostContainer({
    super.key,
    required this.forumPost,
    required this.doctorRatingId,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
