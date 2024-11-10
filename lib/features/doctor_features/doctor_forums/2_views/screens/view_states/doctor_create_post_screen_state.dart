import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/bloc/doctor_forums_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/widgets/doctor_create_post_textfields.dart';

class CreateDoctorPostScreenState extends StatelessWidget {
  CreateDoctorPostScreenState({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final forumsBloc = context.read<DoctorForumsBloc>();
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: GinaDoctorAppBar(title: 'Create Post'),
      body: ScrollbarCustom(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  DoctorCreatePostTextFields(
                    textFieldController: titleController,
                    contentTitle: 'Title',
                    maxLines: 3,
                    isTitle: true,
                  ),
                  const Gap(15),
                  DoctorCreatePostTextFields(
                    textFieldController: contentController,
                    contentTitle: 'Content',
                    maxLines: 14,
                  ),
                  const Gap(40),
                  BlocConsumer<DoctorForumsBloc, DoctorForumsState>(
                    listenWhen: (previous, current) =>
                        current is DoctorForumsActionState,
                    buildWhen: (previous, current) =>
                        current is! DoctorForumsActionState,
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width * 0.4,
                            child: FilledButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color?>(
                                  Colors.grey[350],
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                forumsBloc
                                    .add(DoctorForumsFetchRequestedEvent());
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
                            width: width * 0.4,
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
                                    CreateDoctorForumsPostEvent(
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
        ),
      ),
    );
  }
}
