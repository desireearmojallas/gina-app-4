// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_consultation_history_container.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/consultation_history_list.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/missed_appointments_list.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/on_going_appointments_list.dart';
import 'package:icons_plus/icons_plus.dart';

import 'package:gina_app_4/core/theme/theme_service.dart';

class AppointmentsTabView extends StatelessWidget {
  Widget? title;
  AppointmentsTabView({
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;

    final List<TabData> tabs = [
      TabData(
        index: 1,
        title: const Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(MingCute.chat_2_fill, size: 16.0),
              Gap(5),
              Text('ON-GOING'),
            ],
          ),
        ),
        content: const OnGoingAppointmentsList(),
      ),
      TabData(
        index: 2,
        title: const Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 18.0),
              Gap(5),
              Text('HISTORY'),
            ],
          ),
        ),
        content: const ConsultationHistoryList(),
      ),
      TabData(
        index: 3,
        title: const Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cancel, size: 16.0),
              Gap(5),
              Text('MISSED'),
            ],
          ),
        ),
        content: const MissedAppointmentsList(),
      ),
    ];

    return Expanded(
      child: DynamicTabBarWidget(
        dynamicTabs: tabs,
        enableFeedback: true,
        indicatorColor: GinaAppTheme.lightTertiaryContainer,
        labelColor: GinaAppTheme.lightTertiaryContainer,
        labelStyle: ginaTheme.titleSmall?.copyWith(
          color: GinaAppTheme.lightTertiaryContainer,
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
        unselectedLabelColor: GinaAppTheme.lightOutline.withAlpha(204),
        onTabControllerUpdated: (controller) {
          // Handle controller updates if needed
        },
        onTabChanged: (index) {
          // Handle tab change if needed
          HapticFeedback.heavyImpact();
          debugPrint('Tab changed to: $index');
        },
      ),
    );
  }
}
