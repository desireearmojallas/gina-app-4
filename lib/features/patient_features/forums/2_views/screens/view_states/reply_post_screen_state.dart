import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/bloc/forums_bloc.dart';

class ReplyPostScreenState extends StatelessWidget {
  final ForumModel forumPost;
  const ReplyPostScreenState({super.key, required this.forumPost});

  @override
  Widget build(BuildContext context) {
    final forumsBloc = context.read<ForumsBloc>();
    return const Center(
      child: Text('ReplyPostScreenState'),
    );
  }
}
