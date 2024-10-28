import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorForumsNavigationWidget extends StatelessWidget {
  const DoctorForumsNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);

    return Container(
      height: size.height * 0.20,
      width: size.width / 2.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: GinaAppTheme.lightOnTertiary,
        boxShadow: [
          GinaAppTheme.defaultBoxShadow,
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            Images.forumImage,
            width: 100,
            height: 90,
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Join the\nDiscussion',
                style: ginaTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Bootstrap.arrow_right_circle_fill,
                color: GinaAppTheme.lightTertiaryContainer,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
