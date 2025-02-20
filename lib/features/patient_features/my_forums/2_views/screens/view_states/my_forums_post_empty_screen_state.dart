import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class MyForumsEmptyScreenState extends StatelessWidget {
  const MyForumsEmptyScreenState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(Images.forumsEmptyPlaceholder),
          ),
          const Gap(40),
          const Text(
            'No forum posts',
            style: TextStyle(
              color: GinaAppTheme.lightOutline,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
