import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/gina_divider.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/bloc/forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/widgets/create_post_textfields.dart';

class CreatePostScreenState extends StatelessWidget {
  CreatePostScreenState({super.key});
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final forumsBloc = context.read<ForumsBloc>();
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: GinaPatientAppBar(title: 'Create Post'),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
            bottom: 20.0,
            left: 20.0,
            right: 20.0,
            top: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CreatePostTextFields(
                textFieldController: titleController,
                contentTitle: 'Title',
                maxLines: 3,
                isTitle: true,
              ),
              GinaDivider(),
              CreatePostTextFields(
                textFieldController: contentController,
                contentTitle: 'Content',
                maxLines: 10,
              ),
              const Gap(35),
              BlocConsumer<ForumsBloc, ForumsState>(
                listenWhen: (previous, current) => current is ForumsActionState,
                buildWhen: (previous, current) => current is! ForumsActionState,
                listener: (context, state) {
                  // TODO: Implement listener if needed
                },
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: height * 0.05,
                        width: width * 0.43,
                        child: FilledButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color?>(
                              Colors.grey[300],
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () {
                            forumsBloc.add(ForumsFetchRequestedEvent());
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: GinaAppTheme.lightOnPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                        width: width * 0.43,
                        child: FilledButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (titleController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Title cannot be empty'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else if (contentController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Content cannot be empty'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              forumsBloc.add(
                                CreateForumsPostEvent(
                                  title: titleController.text,
                                  content: contentController.text,
                                  postedAt: Timestamp.now(),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Post',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
