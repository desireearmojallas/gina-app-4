import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forum_badge/2_views/bloc/doctor_forum_badge_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forum_badge/2_views/view_states/doctor_forum_badge_screen_loaded.dart';

class DoctorForumBadgeScreenProvider extends StatelessWidget {
  const DoctorForumBadgeScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorForumBadgeBloc>(
      create: (context) => sl<DoctorForumBadgeBloc>(),
      child: const DoctorForumBadgeScreen(),
    );
  }
}

class DoctorForumBadgeScreen extends StatelessWidget {
  const DoctorForumBadgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Forum Badge'),
      ),
      body: const DoctorForumBadgeScreenLoaded(),
    );
  }
}
