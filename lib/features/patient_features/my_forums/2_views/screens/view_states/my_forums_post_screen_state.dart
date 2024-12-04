import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/bloc/forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/screens/view_states/forums_detailed_post_state.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/widgets/forum_header.dart';
import 'package:gina_app_4/features/patient_features/my_forums/2_views/bloc/my_forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/my_forums/2_views/screens/view_states/my_forums_post_empty_screen_state.dart';
import 'package:icons_plus/icons_plus.dart';

class MyForumsPostScreenState extends StatelessWidget {
  final List<ForumModel> myForumsPost;
  const MyForumsPostScreenState({super.key, required this.myForumsPost});

  @override
  Widget build(BuildContext context) {
    final forumsBloc = context.read<ForumsBloc>();
    final myForumsBloc = context.read<MyForumsBloc>();
    final width = MediaQuery.of(context).size.width;
    final ginaTheme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: myForumsPost.isEmpty
          ? const MyForumsEmptyScreenState()
          : RefreshIndicator(
              onRefresh: () async {
                myForumsBloc.add(GetMyForumsPostEvent());
              },
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: myForumsPost.length,
                itemBuilder: (context, index) {
                  final forumPost = myForumsPost[index];

                  return InkWell(
                    onTap: () {
                      forumsBloc.add(
                        NavigateToForumsDetailedPostEvent(
                          forumPost: forumPost,
                          doctorRatingId: forumPost.doctorRatingId,
                        ),
                      );

                      debugPrint('Event added to Bloc');

                      // Navigate directly here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForumsDetailedPostState(
                            forumPost: forumPost,
                            forumReplies: forumPost.replies,
                            doctorRatingId: forumPost.doctorRatingId,
                            useCustomAppBar: true,
                            isDoctor: false,
                            isFromMyForums: true,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: width * 0.94,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            GinaAppTheme.defaultBoxShadow,
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 15.0),
                          child: Column(
                            children: [
                              forumHeader(
                                forumPost: forumPost,
                                doctorRatingId: forumPost.doctorRatingId,
                                context: context,
                              ),
                              const Gap(10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  forumPost.title,
                                  style:
                                      ginaTheme.textTheme.bodyMedium?.copyWith(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final textSpan = TextSpan(
                                          text: forumPost.content,
                                          style: ginaTheme.textTheme.labelLarge
                                              ?.copyWith(
                                            height: 1.8,
                                          ),
                                        );

                                        final textPainter = TextPainter(
                                          text: textSpan,
                                          maxLines: 8,
                                          textDirection: TextDirection.ltr,
                                        );

                                        textPainter.layout(
                                            maxWidth: constraints.maxWidth);

                                        final exceedsMaxLines =
                                            textPainter.didExceedMaxLines;

                                        return RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                            text: exceedsMaxLines
                                                ? '${forumPost.content.substring(0, textPainter.getPositionForOffset(Offset(constraints.maxWidth, textPainter.height)).offset)}... '
                                                : forumPost.content,
                                            style:
                                                ginaTheme.textTheme.labelMedium,
                                            children: [
                                              if (exceedsMaxLines)
                                                WidgetSpan(
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () {
                                                        forumsBloc.add(
                                                          NavigateToForumsDetailedPostEvent(
                                                            forumPost:
                                                                forumPost,
                                                            doctorRatingId:
                                                                forumPost
                                                                    .doctorRatingId,
                                                          ),
                                                        );

                                                        // Navigate directly here
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ForumsDetailedPostState(
                                                              forumPost:
                                                                  forumPost,
                                                              forumReplies:
                                                                  forumPost
                                                                      .replies,
                                                              doctorRatingId:
                                                                  forumPost
                                                                      .doctorRatingId,
                                                              useCustomAppBar:
                                                                  true,
                                                              isDoctor: false,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      splashColor: GinaAppTheme
                                                          .lightPrimaryColor,
                                                      splashFactory: InkSplash
                                                          .splashFactory,
                                                      child: Text(
                                                        'See more',
                                                        style: TextStyle(
                                                          color: ginaTheme
                                                              .primaryColor,
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                    style:
                                        ginaTheme.textTheme.bodySmall?.copyWith(
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
    );
  }
}
