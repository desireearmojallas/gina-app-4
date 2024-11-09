import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorForumsScreenLoaded extends StatelessWidget {
  const DoctorForumsScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final ginaTheme = Theme.of(context);

    // Dummy data
    final List<ForumModel> forumsPosts = [
      ForumModel(
        title: 'Forum Post 1',
        content: 'This is the content of forum post 1.',
        replies: const [],
        postId: '1',
        posterUid: 'doctor1',
        postedBy: 'Dr. Smith',
        profileImage: Images.doctorProfileIcon1,
        postedAt: Timestamp.fromDate(DateTime.now()),
        isDoctor: true,
        doctorRatingId: 1,
      ),
      ForumModel(
        title: 'Forum Post 2',
        content: 'Tips on managing anxiety and stress effectively.',
        replies: const [],
        postId: '2',
        posterUid: 'doctor2',
        postedBy: 'Dr. Kim',
        profileImage: Images.doctorProfileIcon1,
        postedAt: Timestamp.fromDate(DateTime.now()),
        isDoctor: true,
        doctorRatingId: 2,
      ),
      ForumModel(
        title: 'Forum Post 3',
        content:
            'Discussion on healthy eating habits for a balanced lifestyle.',
        replies: const [],
        postId: '3',
        posterUid: 'doctor3',
        postedBy: 'Dr. Lee',
        profileImage: Images.doctorProfileIcon1,
        postedAt: Timestamp.fromDate(DateTime.now()),
        isDoctor: true,
        doctorRatingId: 3,
      ),
      ForumModel(
        title: 'Forum Post 4',
        content: 'How to improve sleep quality and reduce insomnia.',
        replies: const [],
        postId: '4',
        posterUid: 'doctor4',
        postedBy: 'Dr. Garcia',
        profileImage: Images.doctorProfileIcon1,
        postedAt: Timestamp.fromDate(DateTime.now()),
        isDoctor: true,
        doctorRatingId: 4,
      ),
      ForumModel(
        title: 'Forum Post 5',
        content: 'Discussing effective ways to maintain mental health.',
        replies: const [],
        postId: '5',
        posterUid: 'doctor5',
        postedBy: 'Dr. Johnson',
        profileImage: Images.doctorProfileIcon1,
        postedAt: Timestamp.fromDate(DateTime.now()),
        isDoctor: true,
        doctorRatingId: 5,
      ),
    ];
    final List<int> doctorRatingIds = [1, 2];

    return Scaffold(
      appBar: GinaDoctorAppBar(
        title: 'Forums',
      ),
      body: forumsPosts.isEmpty
          ? const Center(child: Text('No forums available'))
          : Stack(
              children: [
                const GradientBackground(),
                RefreshIndicator(
                  onRefresh: () async {
                    // Refresh logic here
                  },
                  child: ScrollbarCustom(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: forumsPosts.length,
                      itemBuilder: (context, index) {
                        final forumPost = forumsPosts[index];
                        // final doctorRatingId = doctorRatingIds[index];
                        // dummy data
                        const doctorRatingId = 2;
                        return InkWell(
                          onTap: () {
                            // Navigate to detailed post
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Container(
                              width: width * 0.94,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  GinaAppTheme.defaultBoxShadow,
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 15.0),
                                child: Column(
                                  children: [
                                    // TODO: FORUMS DOCTOR
                                    forumHeader(
                                      forumPost: forumPost,
                                      doctorRatingId: doctorRatingId,
                                      context: context,
                                    ),
                                    const Gap(10),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        forumPost.title,
                                        style: ginaTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                    ),
                                    const Gap(10),
                                    SizedBox(
                                      width: width * 0.9,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          LayoutBuilder(
                                            builder: (context, constraints) {
                                              final textSpan = TextSpan(
                                                text: forumPost.content,
                                                style: ginaTheme
                                                    .textTheme.labelLarge
                                                    ?.copyWith(
                                                  height: 1.8,
                                                ),
                                              );

                                              final textPainter = TextPainter(
                                                text: textSpan,
                                                maxLines: 8,
                                                textDirection:
                                                    TextDirection.ltr,
                                              );

                                              textPainter.layout(
                                                  maxWidth:
                                                      constraints.maxWidth);

                                              final exceedsMaxLines =
                                                  textPainter.didExceedMaxLines;

                                              return RichText(
                                                textAlign: TextAlign.left,
                                                text: TextSpan(
                                                  text: exceedsMaxLines
                                                      ? '${forumPost.content.substring(0, textPainter.getPositionForOffset(Offset(constraints.maxWidth, textPainter.height)).offset)}... '
                                                      : forumPost.content,
                                                  style: ginaTheme
                                                      .textTheme.labelMedium,
                                                  children: [
                                                    if (exceedsMaxLines)
                                                      WidgetSpan(
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            onTap: () {
                                                              // Navigate to detailed post
                                                            },
                                                            splashColor:
                                                                GinaAppTheme
                                                                    .lightPrimaryColor,
                                                            splashFactory:
                                                                InkSplash
                                                                    .splashFactory,
                                                            child: Text(
                                                              'See more',
                                                              style: TextStyle(
                                                                color: ginaTheme
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                          const Gap(10),
                                        ],
                                      ),
                                    ),
                                    const Gap(25),
                                    Row(
                                      children: [
                                        const Icon(
                                          MingCute.message_3_line,
                                          size: 20,
                                          color: GinaAppTheme.lightOutline,
                                        ),
                                        const Gap(5),
                                        Text(
                                          '${forumPost.replies.length} ${forumPost.replies.length == 1 ? 'reply' : 'replies'}',
                                          style: ginaTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: GinaAppTheme.lightOutline,
                                          ),
                                        ),
                                      ],
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
                ),
              ],
            ),
    );
  }

  Widget forumHeader({
    required ForumModel forumPost,
    required int doctorRatingId,
    required BuildContext context,
  }) {
    // Dummy forum header implementation
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(forumPost.profileImage),
        ),
        const Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doctor $doctorRatingId',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'Rating: $doctorRatingId',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
