import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';

class MyForumsEmptyScreenState extends StatelessWidget {
  const MyForumsEmptyScreenState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(Images.forumsEmptyPlaceholder),
        ),
        const Gap(25),
        const Text('No forum posts'),
      ],
    );
  }
}
