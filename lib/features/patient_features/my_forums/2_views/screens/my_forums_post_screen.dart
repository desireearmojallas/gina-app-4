import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/my_forums/2_views/bloc/my_forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/my_forums/2_views/screens/view_states/my_forums_post_empty_screen_state.dart';
import 'package:gina_app_4/features/patient_features/my_forums/2_views/screens/view_states/my_forums_post_screen_state.dart';

class MyForumsScreenProvider extends StatelessWidget {
  const MyForumsScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyForumsBloc>(
      create: (context) => sl<MyForumsBloc>()..add(GetMyForumsPostEvent()),
      child: const MyForumsScreen(),
    );
  }
}

class MyForumsScreen extends StatelessWidget {
  const MyForumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myForumsBloc = context.read<MyForumsBloc>();
    return Scaffold(
      appBar: GinaPatientAppBar(
        title: 'My Forum Posts',
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 78),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/forumsCreatePost')
                .then((value) => myForumsBloc.add(GetMyForumsPostEvent()));
          },
          child: const Icon(
            CupertinoIcons.add,
          ),
        ),
      ),
      body: Stack(
        children: [
          const GradientBackground(),
          BlocConsumer<MyForumsBloc, MyForumsState>(
            listenWhen: (previous, current) => current is MyForumsActionState,
            buildWhen: (previous, current) => current is! MyForumsActionState,
            listener: (context, state) {},
            builder: (context, state) {
              if (state is MyForumsLoadedState) {
                return MyForumsPostScreenState(
                  myForumsPost: state.myForumsPosts,
                );
              } else if (state is MyForumsEmptyState) {
                return const MyForumsEmptyScreenState();
              } else if (state is MyForumsErrorState) {
                return Center(
                  child: Text(state.message),
                );
              } else if (state is MyForumsLoadingState) {
                return const Center(
                  child: CustomLoadingIndicator(),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
