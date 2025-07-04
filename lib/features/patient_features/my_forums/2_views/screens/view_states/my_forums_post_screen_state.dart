// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/screens/view_states/doctor_forums_details_post_state.dart';
import 'package:gina_app_4/features/doctor_features/doctor_my_forums/bloc/doctor_my_forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/bloc/forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/screens/view_states/forums_detailed_post_state.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/widgets/forum_header.dart';
import 'package:gina_app_4/features/patient_features/my_forums/2_views/bloc/my_forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/my_forums/2_views/screens/view_states/my_forums_post_empty_screen_state.dart';
import 'package:icons_plus/icons_plus.dart';

class MyForumsPostScreenState extends StatelessWidget {
  final List<ForumModel> myForumsPost;
  final User? currentUser;
  final bool? isDoctor;
  final DoctorModel? doctorModel;
  const MyForumsPostScreenState({
    super.key,
    required this.myForumsPost,
    required this.currentUser,
    this.isDoctor = false,
    this.doctorModel,
  });

  Future<List<ForumModel>> getUpdatedRepliesWithDoctorRatingIds(
      List<ForumModel> forums) async {
    final updatedForums = await Future.wait(forums.map((forum) async {
      final updatedReplies = await Future.wait(forum.replies.map((reply) async {
        final doctorDoc = await FirebaseFirestore.instance
            .collection('doctors')
            .doc(reply.posterUid)
            .get();
        if (doctorDoc.exists) {
          final doctor = DoctorModel.fromDocumentSnap(doctorDoc);
          debugPrint(
              'Fetched doctorRatingId: ${doctor.doctorRatingId} for reply: ${reply.postId}');
          return reply.copyWith(doctorRatingId: doctor.doctorRatingId);
        } else {
          debugPrint('Doctor not found for reply: ${reply.postId}');
        }
        return reply;
      }).toList());
      return forum.copyWith(replies: updatedReplies);
    }).toList());
    return updatedForums;
  }

  @override
  Widget build(BuildContext context) {
    final forumsBloc = context.read<ForumsBloc>();
    final myForumsBloc = context.read<MyForumsBloc>();
    final doctorMyForumsBloc = context.read<DoctorMyForumsBloc>();
    final width = MediaQuery.of(context).size.width;
    final ginaTheme = Theme.of(context);

    debugPrint('DoctorModel $doctorModel');
    debugPrint('doctorModel?.doctorRatingId ${doctorModel?.doctorRatingId}');
    debugPrint('isDoctor $isDoctor');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: myForumsPost.isEmpty
          ? const MyForumsEmptyScreenState()
          : RefreshIndicator(
              onRefresh: () async {
                isDoctor == true
                    ? doctorMyForumsBloc.add(GetMyDoctorForumsPostEvent())
                    : myForumsBloc.add(GetMyForumsPostEvent());
              },
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: myForumsPost.length,
                itemBuilder: (context, index) {
                  final forumPost = myForumsPost[index];

                  return InkWell(
                    onTap: () async {
                      final updatedForums =
                          await getUpdatedRepliesWithDoctorRatingIds(
                              [forumPost]);
                      final updatedForumPost = updatedForums.first;
                      forumsBloc.add(
                        NavigateToForumsDetailedPostEvent(
                          forumPost: updatedForumPost,
                          doctorRatingId: doctorModel?.doctorRatingId ?? 0,
                          isFromMyForums: true,
                        ),
                      );

                      debugPrint('Event added to Bloc');

                      // Navigate based on isDoctor flag
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => isDoctor == true
                              ? DoctorForumsDetailedPostState(
                                  forumPost: updatedForumPost,
                                  forumReplies: updatedForumPost.replies,
                                  doctorRatingId:
                                      doctorModel?.doctorRatingId ?? 0,
                                  useCustomAppBar: true,
                                  isDoctor: isDoctor,
                                  isFromMyForums: true,
                                  currentUser: currentUser,
                                )
                              : ForumsDetailedPostState(
                                  forumPost: updatedForumPost,
                                  forumReplies: updatedForumPost.replies,
                                  doctorRatingId:
                                      doctorModel?.doctorRatingId ?? 0,
                                  useCustomAppBar: true,
                                  isDoctor: isDoctor,
                                  isFromMyForums: true,
                                  currentUser: currentUser,
                                ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                                doctorRatingId:
                                    doctorModel?.doctorRatingId ?? 0,
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
