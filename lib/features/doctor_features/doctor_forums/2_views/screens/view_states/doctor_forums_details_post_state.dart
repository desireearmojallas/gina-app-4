// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/bloc/doctor_forums_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/widgets/main_detailed_post_container.dart';
import 'package:gina_app_4/features/doctor_features/doctor_my_forums/bloc/doctor_my_forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/widgets/forum_header.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorForumsDetailedPostState extends StatelessWidget {
  final ForumModel forumPost;
  final List<ForumModel> forumReplies;
  final int doctorRatingId;
  bool? useCustomAppBar;
  bool? isDoctor;
  final User? currentUser;
  final bool? isFromMyForums;

  DoctorForumsDetailedPostState({
    super.key,
    required this.forumPost,
    required this.forumReplies,
    required this.doctorRatingId,
    required this.currentUser,
    this.isFromMyForums = false,
    this.useCustomAppBar = false,
    this.isDoctor,
  });

  @override
  Widget build(BuildContext context) {
    final forumsBloc = context.read<DoctorForumsBloc>();
    final myForumsBloc = context.read<DoctorMyForumsBloc>();
    final width = MediaQuery.of(context).size.width;

    debugPrint('DoctorRatingId: $doctorRatingId');

    return Scaffold(
      appBar: useCustomAppBar == true
          ? (isDoctor == true
              ? GinaDoctorAppBar(title: forumPost.title) as PreferredSizeWidget
              : GinaPatientAppBar(title: forumPost.title)
                  as PreferredSizeWidget)
          : null,
      body: Stack(
        children: [
          const GradientBackground(),
          RefreshIndicator(
            onRefresh: () async {
              forumsBloc.add(GetRepliesDoctorForumsPostRequestedEvent(
                docForumPost: forumPost,
              ));
            },
            child: ScrollbarCustom(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 18, 8, 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            MainDetailedDoctorPostContainer(
                              forumPost: forumPost,
                              doctorRatingId: doctorRatingId,
                            ),
                            const Gap(20),

                            //delete icon

                            if (forumPost.posterUid == currentUser?.uid)
                              IconButton(
                                padding: const EdgeInsets.all(10),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                    context,
                                    myForumsBloc,
                                    forumsBloc,
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: GinaAppTheme.lightOnPrimaryColor,
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      GinaAppTheme.appbarColorLight
                                          .withOpacity(0.5)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            const Gap(10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Replies (${forumReplies.length})',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                            BlocBuilder<DoctorForumsBloc, DoctorForumsState>(
                              builder: (context, state) {
                                debugPrint('State: $state');
                                if (state
                                    is GetRepliesDoctorForumsPostLoadingState) {
                                  return const Center(
                                    child: CustomLoadingIndicator(),
                                  );
                                }
                                if (state
                                    is GetRepliesDoctorForumsPostFailedState) {
                                  return Center(
                                    child: Text(
                                      state.message,
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  reverse: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: forumReplies.length,
                                  itemBuilder: (context, index) {
                                    final reply = forumReplies[index];

                                    debugPrint('Reply: $reply');
                                    debugPrint(
                                        'DoctorRatingId: ${reply.doctorRatingId}');

                                    return Column(
                                      children: [
                                        const Gap(10),
                                        Container(
                                          width: width * 0.94,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                            boxShadow: [
                                              GinaAppTheme.defaultBoxShadow,
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 15.0,
                                              horizontal: 15.0,
                                            ),
                                            child: Column(
                                              children: [
                                                const Gap(10),
                                                forumHeader(
                                                  forumPost: reply,
                                                  doctorRatingId:
                                                      reply.doctorRatingId,
                                                  context: context,
                                                ),
                                                const Gap(20),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    reply.content,
                                                    style: const TextStyle(
                                                        height: 1.8),
                                                  ),
                                                ),
                                                const Gap(10),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: width / 2.5,
                child: FilledButton(
                  style: ButtonStyle(
                    splashFactory:
                        InkSparkle.constantTurbulenceSeedSplashFactory,
                    // backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    forumsBloc.add(
                      NavigateToDoctorForumsReplyPostEvent(
                        docForumPost: forumPost,
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add Reply',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap(10),
                      Icon(
                        MingCute.message_3_fill,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context,
      DoctorMyForumsBloc bloc, DoctorForumsBloc forumsBloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
              const Text('Are you sure you want to delete this announcement?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(color: GinaAppTheme.lightOutline)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              onPressed: () {
                bloc.add(
                  DeleteMyForumsPostEvent(
                    forumUid: forumPost.postId,
                  ),
                );

                bloc.stream
                    .firstWhere(
                        (state) => state is DeleteMyForumsPostSuccessState)
                    .then((_) {
                  Navigator.of(context).pop(); // Close confirmation dialog

                  if (isFromMyForums == true) {
                    Navigator.of(context).pop(); // Close detailed post screen
                    debugPrint('Fetching updated my forums posts...');
                    bloc.add(GetMyDoctorForumsPostEvent());
                    Navigator.of(context)
                        .pushReplacementNamed('/doctorMyForumPosts');
                  } else {
                    forumsBloc.add(DoctorForumsFetchRequestedEvent());
                  }
                }).catchError((error) {
                  debugPrint('Error deleting post: $error');
                });
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                  GinaAppTheme.lightTertiaryContainer,
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
