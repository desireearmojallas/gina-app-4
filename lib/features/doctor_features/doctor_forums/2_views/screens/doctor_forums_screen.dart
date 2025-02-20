import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/bloc/doctor_forums_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/screens/view_states/doctor_forums_details_post_state.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/screens/view_states/doctor_forums_screen_loaded.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/screens/view_states/doctor_reply_post_screen_state.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/widgets/posted_confirmation_dialog.dart';

class DoctorForumsScreenProvider extends StatelessWidget {
  const DoctorForumsScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorForumsBloc>(
      create: (context) {
        final forumsBloc = sl<DoctorForumsBloc>();
        forumsBloc.add(DoctorForumsFetchRequestedEvent());
        return forumsBloc;
      },
      child: const DoctorForumsScreen(),
    );
  }
}

class DoctorForumsScreen extends StatelessWidget {
  const DoctorForumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final forumsBloc = context.read<DoctorForumsBloc>();
    return BlocBuilder<DoctorForumsBloc, DoctorForumsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: GinaDoctorAppBar(
            leading: state is NavigateToDoctorForumsDetailedPostState ||
                    state is GetRepliesDoctorForumsPostSuccessState
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      forumsBloc.add(DoctorForumsFetchRequestedEvent());
                    },
                  )
                : state is NavigateToDoctorForumsReplyPostState
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          forumsBloc
                              .add(NavigateToDoctorForumsDetailedPostEvent(
                            docForumPost: state.docForumPost,
                            doctorRatingId: state.docForumPost.doctorRatingId,
                          ));
                        })
                    : null,
            title: state is NavigateToDoctorForumsReplyPostState
                ? 'Reply'
                : state is NavigateToDoctorForumsDetailedPostState
                    ? state.doctorForumPost.title
                    : 'Forums',
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 78),
            child: FloatingActionButton(
              onPressed: () {
                forumsBloc.add(NavigateToDoctorForumsCreatePostEvent());
              },
              child: const Icon(
                CupertinoIcons.add,
              ),
            ),
          ),
          body: BlocConsumer<DoctorForumsBloc, DoctorForumsState>(
            listenWhen: (previous, current) =>
                current is DoctorForumsActionState,
            buildWhen: (previous, current) =>
                current is! DoctorForumsActionState,
            listener: (context, state) {
              debugPrint('Listener: Current state is $state');
              if (state is NavigateToDoctorForumsCreatePostState) {
                Navigator.pushNamed(context, '/doctorForumsCreatePost').then(
                  (value) => forumsBloc.add(
                    DoctorForumsFetchRequestedEvent(),
                  ),
                );
              }
              // else if (state is NavigateToDoctorForumsReplyPostState) {
              //   Navigator.pushNamed(context, '/forumsReplyPost').then(
              //     (value) => forumsBloc.add(
              //       DoctorForumsFetchRequestedEvent(),
              //     ),
              //   );
              // }
              else if (state is CreateDoctorForumsPostSuccessState) {
                debugPrint('Listener: CreateDoctorForumsPostSuccessState');
                postedConfirmationDialog(context, 'Posted', false);
              } else if (state is CreateReplyDoctorForumsPostSuccessState) {
                debugPrint('Listener: CreateReplyDoctorForumsPostSuccessState');
                postedConfirmationDialog(context, 'Reply posted', false);
              }
            },
            builder: (context, state) {
              debugPrint('Builder: Current state is $state');
              if (state is GetDoctorForumsPostsSuccessState) {
                final forumPosts = state.forumsPosts;
                final doctorRatingIds = state.doctorRatingIds;
                return DoctorForumsScreenLoaded(
                  docForumsPosts: forumPosts,
                  doctorRatingIds: doctorRatingIds,
                );
              } else if (state is GetDoctorForumsPostsEmptyState) {
                return const Center(
                  child: Text('No Forum Posts'),
                );
              } else if (state is GetDoctorForumsPostsLoadingState) {
                return const Center(
                  child: CustomLoadingIndicator(),
                );
              } else if (state is GetDoctorForumsPostsFailedState) {
                return Center(
                  child: Text(state.message),
                );
              } else if (state is NavigateToDoctorForumsDetailedPostState) {
                final forumPost = state.doctorForumPost;
                final forumReplies = state.forumReplies;
                final doctorRatingId = state.doctorRatingId;
                final currentUser = state.currentUser;
                return DoctorForumsDetailedPostState(
                  forumPost: forumPost,
                  forumReplies: forumReplies,
                  doctorRatingId: doctorRatingId,
                  currentUser: currentUser,
                );
              } else if (state is NavigateToDoctorForumsReplyPostState) {
                final forumPost = state.docForumPost;
                return DoctorReplyPostScreenState(
                  forumPost: forumPost,
                );
              } else if (state is GetRepliesDoctorForumsPostSuccessState) {
                final forumReplies = state.forumReplies;
                return DoctorForumsDetailedPostState(
                  forumPost: state.forumPost,
                  forumReplies: forumReplies,
                  doctorRatingId: state.doctorRatingId,
                  currentUser: state.currentUser,
                );
              }
              return const SizedBox();
            },
          ),
        );
      },
    );
  }
}
