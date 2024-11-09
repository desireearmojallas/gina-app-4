import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/bloc/doctor_forums_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/screens/view_states/doctor_forums_screen_loaded.dart';

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
                  : 'Forums',
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                forumsBloc.add(NavigateToDoctorForumsCreatePostEvent());
              },
              child: const Icon(Icons.add),
            ),
            body: BlocConsumer<DoctorForumsBloc, DoctorForumsState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                return Container();
              },
            ));
      },
    );
  }
}
