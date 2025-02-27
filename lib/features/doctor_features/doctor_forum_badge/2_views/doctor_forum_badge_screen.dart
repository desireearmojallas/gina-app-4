import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forum_badge/2_views/bloc/doctor_forum_badge_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forum_badge/2_views/view_states/doctor_forum_badge_screen_loaded.dart';

class DoctorForumBadgeScreenProvider extends StatelessWidget {
  const DoctorForumBadgeScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorForumBadgeBloc>(
      create: (context) {
        final profileBloc = sl<DoctorForumBadgeBloc>();
        profileBloc.add(GetForumBadgeEvent());
        return profileBloc;
      },
      child: const DoctorForumBadgeScreen(),
    );
  }
}

class DoctorForumBadgeScreen extends StatelessWidget {
  const DoctorForumBadgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorForumBadgeBloc, DoctorForumBadgeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: GinaDoctorAppBar(
            title: 'Forum badge',
          ),
          body: BlocConsumer<DoctorForumBadgeBloc, DoctorForumBadgeState>(
            listenWhen: (previous, current) =>
                current is DoctorForumBadgeActionState,
            buildWhen: (previous, current) =>
                current is! DoctorForumBadgeActionState,
            listener: (context, state) {},
            builder: (context, state) {
              if (state is DoctorForumBadgeLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DoctorForumBadgeScuccessState) {
                final doctorPosts = state.doctorPost;
                return DoctorForumBadgeScreenLoaded(
                  doctor: doctorPosts,
                );
              } else if (state is DoctorForumBadgeFailedState) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          ),
        );
      },
    );
  }
}
