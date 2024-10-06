import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/bloc/forums_bloc.dart';

class ForumsDetailedPostState extends StatelessWidget {
  final ForumModel forumPost;
  final List<ForumModel> forumReplies;
  final int doctorRatingId;

  const ForumsDetailedPostState({
    super.key,
    required this.forumPost,
    required this.forumReplies,
    required this.doctorRatingId,
  });

  @override
  Widget build(BuildContext context) {
    final forumsBloc = context.read<ForumsBloc>();
    return RefreshIndicator(
      onRefresh: () async {
        forumsBloc.add(GetRepliesForumsPostEvent(
          forumPost: forumPost,
        ));
      },
      child: const SingleChildScrollView(
          child: Center(
        child: Text('ForumsDetailedPostState'),
      )),
    );
  }
}
