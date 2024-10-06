import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/doctor_rating_badge/doctor_rating_badge.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/bloc/forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/my_forums/2_views/screens/view_states/my_forums_post_empty_screen_state.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class ForumScreenLoaded extends StatelessWidget {
  final List<ForumModel> forumsPosts;
  final List<int> doctorRatingIds;
  const ForumScreenLoaded({
    super.key,
    required this.forumsPosts,
    required this.doctorRatingIds,
  });

  @override
  Widget build(BuildContext context) {
    final forumsBloc = context.read<ForumsBloc>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final ginaTheme = Theme.of(context);

    return Scaffold(
      body: forumsPosts.isEmpty
          ? const MyForumsEmptyScreenState()
          : Stack(
              children: [
                const GradientBackground(),
                RefreshIndicator(
                  onRefresh: () async {
                    forumsBloc.add(ForumsFetchRequestedEvent());
                  },
                  child: ScrollbarCustom(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: forumsPosts.length,
                      itemBuilder: (context, index) {
                        final forumPost = forumsPosts[index];
                        final doctorRatingId = doctorRatingIds[index];
                        return BlocBuilder<ForumsBloc, ForumsState>(
                          builder: (context, state) {
                            return InkWell(
                              onTap: () {
                                forumsBloc.add(
                                  NavigateToForumsDetailedPostEvent(
                                    forumPost: forumPost,
                                    doctorRatingId: doctorRatingId,
                                  ),
                                );
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
                                        forumPost.isDoctor
                                            ? Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 20,
                                                    foregroundImage: AssetImage(
                                                      Images.doctorProfileIcon2,
                                                    ),
                                                  ),
                                                  const Gap(10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      DoctorRatingBadge(
                                                        doctorRating:
                                                            doctorRatingId,
                                                        width: 100,
                                                      ),
                                                      Text(
                                                        'Dr. ${forumPost.postedBy}',
                                                        style: ginaTheme
                                                            .textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      const Gap(5),
                                                      const Icon(
                                                        Icons.verified,
                                                        color: Colors.blue,
                                                        size: 15,
                                                      ),
                                                      Text(
                                                        "Posted ${timeago.format(forumPost.postedAt.toDate(), locale: 'en')}",
                                                        style: ginaTheme
                                                            .textTheme.bodySmall
                                                            ?.copyWith(
                                                          color: GinaAppTheme
                                                              .lightOutline,
                                                        ),
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
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        forumPost.postedBy,
                                                        style: ginaTheme
                                                            .textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Posted ${timeago.format(forumPost.postedAt.toDate(), locale: 'en')}",
                                                        style: ginaTheme
                                                            .textTheme.bodySmall
                                                            ?.copyWith(
                                                          color: GinaAppTheme
                                                              .lightOutline,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                        const Gap(10),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            forumPost.title,
                                            style: ginaTheme
                                                .textTheme.bodyMedium
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
                                          child: Text(
                                            forumPost.content.isNotEmpty
                                                ? forumPost.content
                                                : 'No content available',
                                            style:
                                                ginaTheme.textTheme.labelMedium,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 8,
                                          ),
                                        ),
                                        const Gap(25),
                                        Row(
                                          children: [
                                            //TODO: IMPLEMENT LIKES
                                            const Icon(
                                              CupertinoIcons.heart_fill,
                                              size: 20,
                                              color: GinaAppTheme
                                                  .lightTertiaryContainer,
                                            ),
                                            const Gap(5),
                                            Text(
                                              '18',
                                              style: ginaTheme
                                                  .textTheme.bodySmall
                                                  ?.copyWith(
                                                color: GinaAppTheme
                                                    .lightOnPrimaryColor,
                                              ),
                                            ),
                                            const Gap(20),
                                            const Icon(
                                              Bootstrap.chat_left_text,
                                              size: 18,
                                              color: GinaAppTheme
                                                  .lightOnPrimaryColor,
                                            ),
                                            const Gap(5),
                                            Text(
                                              //TODO: IMPLEMENT REPLIES
                                              '5 replies',
                                              style: ginaTheme
                                                  .textTheme.bodySmall
                                                  ?.copyWith(
                                                color: GinaAppTheme
                                                    .lightOnPrimaryColor,
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
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
