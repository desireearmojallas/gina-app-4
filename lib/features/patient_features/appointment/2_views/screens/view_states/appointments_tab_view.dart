import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/cancelled_appointments/cancelled_appointments_list.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/completed_appointments/consultation_history_list.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/declined_appointments/declined_appointments_list.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/missed_appointments/missed_appointments_list.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/on_going_appointments/on_going_appointments_list.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/pending_appointments/pending_appointments_list.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class AppointmentsTabView extends StatelessWidget {
  final List<AppointmentModel> missedAppointments;
  final List<AppointmentModel> completedAppointments;
  final List<AppointmentModel> cancelledAppointments;
  final List<AppointmentModel> declinedAppointments;
  final List<AppointmentModel> pendingAppointments;
  final List<AppointmentModel> ongoingAppointments;
  final int initialIndex;

  const AppointmentsTabView({
    super.key,
    required this.missedAppointments,
    required this.completedAppointments,
    required this.cancelledAppointments,
    required this.declinedAppointments,
    required this.pendingAppointments,
    required this.ongoingAppointments,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;

    final List<TabData> tabs = [
      TabData(
        index: 0,
        title: const Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.do_not_disturb_on, size: 18.0),
              Gap(5),
              Text('CANCELLED'),
            ],
          ),
        ),
        content: CancelledAppointmentsList(appointments: cancelledAppointments),
      ),
      TabData(
        index: 1,
        title: const Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cancel, size: 18.0),
              Gap(5),
              Text('MISSED'),
            ],
          ),
        ),
        content: MissedAppointmentsList(appointments: missedAppointments),
      ),
      TabData(
        index: 2,
        title: const Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time_filled_rounded, size: 18.0),
              Gap(5),
              Text('PENDING'),
            ],
          ),
        ),
        content: PendingAppointmentsList(appointments: pendingAppointments),
      ),
      TabData(
        index: 3,
        title: const Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(MingCute.chat_2_fill, size: 17.0),
              Gap(5),
              Text('ON-GOING'),
            ],
          ),
        ),
        content: OnGoingAppointmentsList(
          appointments: ongoingAppointments,
        ),
      ),
      TabData(
        index: 4,
        title: const Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded, size: 18.0),
              Gap(5),
              Text('COMPLETED'),
            ],
          ),
        ),
        content: ConsultationHistoryList(appointments: completedAppointments),
      ),
      TabData(
        index: 5,
        title: const Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.thumb_down, size: 18.0),
              Gap(5),
              Text('DECLINED'),
            ],
          ),
        ),
        content: DeclinedAppointmentsList(appointments: declinedAppointments),
      ),
    ];

    return Expanded(
      child: DynamicTabBarWidget(
        physicsTabBarView: const BouncingScrollPhysics(),
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        isScrollable: true, // Enable scrolling for long tab labels
        showBackIcon: false,
        showNextIcon: false,
        leading: null,
        trailing: null,
        dynamicTabs: tabs,
        enableFeedback: true,
        splashBorderRadius: BorderRadius.circular(10.0),
        splashFactory: InkSparkle.splashFactory,
        indicatorColor: GinaAppTheme.lightTertiaryContainer,
        labelColor: GinaAppTheme.lightTertiaryContainer,
        labelStyle: ginaTheme.titleSmall?.copyWith(
          // color: GinaAppTheme.lightTertiaryContainer,
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
        unselectedLabelStyle: ginaTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 11.5,
        ),
        unselectedLabelColor: GinaAppTheme.lightOutline.withAlpha(204),
        labelPadding: const EdgeInsets.symmetric(horizontal: 15.0),
        indicatorPadding: EdgeInsets.zero,
        onTabControllerUpdated: (controller) {
          controller.index = initialIndex;
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
