import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_my_forums/bloc/doctor_my_forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/my_forums/2_views/screens/view_states/my_forums_post_empty_screen_state.dart';
import 'package:gina_app_4/features/patient_features/my_forums/2_views/screens/view_states/my_forums_post_screen_state.dart';

class DoctorMyForumsScreenProvider extends StatelessWidget {
  const DoctorMyForumsScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorMyForumsBloc>(
      create: (context) =>
          sl<DoctorMyForumsBloc>()..add(GetMyDoctorForumsPostEvent()),
      child: const DoctorMyForumsScreen(),
    );
  }
}

class DoctorMyForumsScreen extends StatelessWidget {
  const DoctorMyForumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myForumsBloc = context.read<DoctorMyForumsBloc>();
    return Scaffold(
        appBar: GinaDoctorAppBar(
          title: 'My Forum Posts',
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 78),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/doctorForumsCreatePost').then(
                  (value) => myForumsBloc.add(GetMyDoctorForumsPostEvent()));
            },
            child: const Icon(
              CupertinoIcons.add,
            ),
          ),
        ),
        body: Stack(
          children: [
            const GradientBackground(),
            BlocConsumer<DoctorMyForumsBloc, DoctorMyForumsState>(
              listenWhen: (previous, current) =>
                  current is DoctorMyForumsActionState,
              buildWhen: (previous, current) =>
                  current is! DoctorMyForumsActionState,
              listener: (context, state) {},
              builder: (context, state) {
                if (state is GetMyForumsPostState) {
                  return MyForumsPostScreenState(
                    myForumsPost: state.myForumsPost,
                  );
                } else if (state is GetMyForumsPostEmptyState) {
                  return const MyForumsEmptyScreenState();
                } else if (state is GetMyForumsPostErrorState) {
                  final errorMessage = state.error;
                  return Center(
                    child: Text(errorMessage),
                  );
                } else if (state is GetMyForumsLoadingState) {
                  return const Center(
                    child: CustomLoadingIndicator(),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ));
  }
}
