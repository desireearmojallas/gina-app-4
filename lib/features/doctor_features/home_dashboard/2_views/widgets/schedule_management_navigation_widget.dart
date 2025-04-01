import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:icons_plus/icons_plus.dart';

class ScheduleManagementNavigationWidget extends StatelessWidget {
  const ScheduleManagementNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pushNamed(
          context,
          '/doctorScheduleManagement',
        );
      },
      child: Container(
        height: size.height * 0.08,
        width: size.width / 2.18,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // gradient: LinearGradient(
          //   colors: GinaAppTheme.gradientColors,
          //   begin: Alignment.bottomLeft,
          //   end: Alignment.topRight,
          // ),
          color: Colors.white,
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // CircleAvatar(
                  //   backgroundColor: GinaAppTheme.lightSecondary.withOpacity(1),
                  //   radius: 40,
                  // ),
                  Image.asset(
                    Images.scheduleManagementIcon,
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
              const Gap(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Manage\nSchedule',
                    style: ginaTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: GinaAppTheme.lightOnPrimaryColor,
                      fontSize: 11,
                    ),
                  ),
                  // const Icon(
                  //   Bootstrap.plus_circle_fill,
                  //   color: GinaAppTheme.lightSecondary,
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
