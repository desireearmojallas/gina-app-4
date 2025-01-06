import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/bloc/doctor_forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/widgets/forum_header.dart';
import 'package:gina_app_4/features/patient_features/my_forums/2_views/screens/view_states/my_forums_post_empty_screen_state.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorForumsScreenLoaded extends StatelessWidget {
  final List<ForumModel> docForumsPosts;
  final List<int> doctorRatingIds;
  const DoctorForumsScreenLoaded({
    super.key,
    required this.docForumsPosts,
    required this.doctorRatingIds,
  });

  @override
  Widget build(BuildContext context) {
    final forumsBloc = context.read<DoctorForumsBloc>();
    final width = MediaQuery.of(context).size.width;
    final ginaTheme = Theme.of(context);

    return Scaffold(
      body: docForumsPosts.isEmpty
          ? const MyForumsEmptyScreenState()
          : Stack(
              children: [
                const GradientBackground(),
                RefreshIndicator(
                  onRefresh: () async {
                    forumsBloc.add(DoctorForumsFetchRequestedEvent());
                  },
                  child: ScrollbarCustom(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.fast,
                        ),
                        itemCount: docForumsPosts.length,
                        itemBuilder: (context, index) {
                          final forumPost = docForumsPosts[index];
                          final doctorRatingId = index < doctorRatingIds.length
                              ? doctorRatingIds[index]
                              : -1;
                          return BlocBuilder<DoctorForumsBloc,
                              DoctorForumsState>(
                            builder: (context, state) {
                              return InkWell(
                                onTap: () {
                                  forumsBloc.add(
                                    NavigateToDoctorForumsDetailedPostEvent(
                                      docForumPost: forumPost,
                                      doctorRatingId: doctorRatingId,
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 8, 0),
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
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                LayoutBuilder(
                                                  builder:
                                                      (context, constraints) {
                                                    final textSpan = TextSpan(
                                                      text: forumPost.content,
                                                      style: ginaTheme
                                                          .textTheme.labelLarge
                                                          ?.copyWith(
                                                        height: 1.8,
                                                      ),
                                                    );

                                                    final textPainter =
                                                        TextPainter(
                                                      text: textSpan,
                                                      maxLines: 8,
                                                      textDirection:
                                                          TextDirection.ltr,
                                                    );

                                                    textPainter.layout(
                                                        maxWidth: constraints
                                                            .maxWidth);

                                                    final exceedsMaxLines =
                                                        textPainter
                                                            .didExceedMaxLines;

                                                    return RichText(
                                                      textAlign: TextAlign.left,
                                                      text: TextSpan(
                                                        text: exceedsMaxLines
                                                            ? '${forumPost.content.substring(0, textPainter.getPositionForOffset(Offset(constraints.maxWidth, textPainter.height)).offset)}... '
                                                            : forumPost.content,
                                                        style: ginaTheme
                                                            .textTheme
                                                            .labelMedium,
                                                        children: [
                                                          if (exceedsMaxLines)
                                                            WidgetSpan(
                                                              child: Material(
                                                                color: Colors
                                                                    .transparent,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    forumsBloc
                                                                        .add(
                                                                      NavigateToDoctorForumsDetailedPostEvent(
                                                                        docForumPost:
                                                                            forumPost,
                                                                        doctorRatingId:
                                                                            doctorRatingId,
                                                                      ),
                                                                    );
                                                                  },
                                                                  splashColor:
                                                                      GinaAppTheme
                                                                          .lightPrimaryColor,
                                                                  splashFactory:
                                                                      InkSplash
                                                                          .splashFactory,
                                                                  child: Text(
                                                                    'See more',
                                                                    style:
                                                                        TextStyle(
                                                                      color: ginaTheme
                                                                          .primaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
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
                                              //TODO: IMPLEMENT LIKES
                                              // const Icon(
                                              //   CupertinoIcons.heart_fill,
                                              //   size: 20,
                                              //   color: GinaAppTheme
                                              //       .lightTertiaryContainer,
                                              // ),
                                              // const Gap(5),
                                              // Text(
                                              //   '18',
                                              //   style: ginaTheme
                                              //       .textTheme.bodySmall
                                              //       ?.copyWith(
                                              //     color:
                                              //         GinaAppTheme.lightOutline,
                                              //   ),
                                              // ),
                                              // const Gap(20),
                                              const Icon(
                                                MingCute.message_3_line,
                                                size: 20,
                                                color:
                                                    GinaAppTheme.lightOutline,
                                              ),
                                              const Gap(5),
                                              Text(
                                                //TODO: IMPLEMENT REPLIES
                                                '${forumPost.replies.length} ${forumPost.replies.length == 1 ? 'reply' : 'replies'}',
                                                style: ginaTheme
                                                    .textTheme.bodySmall
                                                    ?.copyWith(
                                                  color:
                                                      GinaAppTheme.lightOutline,
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
                ),
              ],
            ),
    );
  }
}
