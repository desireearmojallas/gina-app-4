import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/bloc/doctor_forums_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/widgets/main_detailed_post_container.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/widgets/forum_header.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorForumsDetailedPostState extends StatelessWidget {
  final ForumModel forumPost;
  final List<ForumModel> forumReplies;
  final int doctorRatingId;
  const DoctorForumsDetailedPostState({
    super.key,
    required this.forumPost,
    required this.forumReplies,
    required this.doctorRatingId,
  });

  @override
  Widget build(BuildContext context) {
    final forumsBloc = context.read<DoctorForumsBloc>();
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
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
}
