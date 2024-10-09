import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/bloc/forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/widgets/create_post_textfields.dart';

class ReplyPostScreenState extends StatelessWidget {
  final ForumModel forumPost;
  ReplyPostScreenState({
    super.key,
    required this.forumPost,
  });

  final TextEditingController replyTextFieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final forumsBloc = context.read<ForumsBloc>();
    final size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CreatePostTextFields(
                textFieldController: replyTextFieldController,
                contentTitle: forumPost.isDoctor
                    ? 'Replying to Dr. ${forumPost.postedBy}'
                    : 'Replying to ${forumPost.postedBy}',
                maxLines: 14,
              ),
              const Gap(20),
              SizedBox(
                width: size.width * 0.9,
                height: size.height / 18,
                child: FilledButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (replyTextFieldController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Reply can\'t be empty',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: GinaAppTheme.lightError,
                        ),
                      );
                    } else {
                      forumsBloc.add(
                        CreateReplyForumsPostEvent(
                          forumPost: forumPost,
                          replyContent: replyTextFieldController.text,
                          repliedAt: Timestamp.now(),
                        ),
                      );
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Success'),
                            content: const Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                Gap(10),
                                Expanded(
                                  child: Text(
                                      'Your reply has been successfully posted.'),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text(
                    'Post',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
