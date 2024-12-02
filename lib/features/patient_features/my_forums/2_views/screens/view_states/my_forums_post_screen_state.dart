import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/bloc/forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/my_forums/2_views/bloc/my_forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/my_forums/2_views/screens/view_states/my_forums_post_empty_screen_state.dart';

class MyForumsPostScreenState extends StatelessWidget {
  final List<ForumModel> myForumsPost;
  const MyForumsPostScreenState({super.key, required this.myForumsPost});

  @override
  Widget build(BuildContext context) {
    final forumsBloc = context.read<ForumsBloc>();
    final myForumsBloc = context.read<MyForumsBloc>();
    final width = MediaQuery.of(context).size.width;
    final ginaTheme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: myForumsPost.isEmpty
          ? const MyForumsEmptyScreenState()
          : RefreshIndicator(
              onRefresh: () async {
                myForumsBloc.add(GetMyForumsPostEvent());
                // myForumsBloc.add(GetMyDoctorForumsPostEvent());
              },
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: myForumsPost.length,
                itemBuilder: (context, index) {
                  final forumPost = myForumsPost[index];

                  return GestureDetector(
                    onTap: () {
                      forumsBloc.add(NavigateToForumsDetailedPostEvent(
                        forumPost: forumPost,
                        doctorRatingId: forumPost.doctorRatingId,
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            GinaAppTheme.defaultBoxShadow,
                          ],
                        ),
                        child: const Text('wow'),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
