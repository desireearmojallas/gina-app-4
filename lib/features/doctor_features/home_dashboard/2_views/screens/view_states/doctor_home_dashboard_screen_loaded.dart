import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/doctor_forums_navigation_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/emergency_announcement_navigation_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/greeting_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/home_dashboard_calendar_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/pending_requests_navigation_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/schedule_management_navigation_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/upcoming_appointments_navigation_widget.dart';

class DoctorHomeScreenDashboardLoaded extends StatelessWidget {
  final int pendingRequests;
  final int confirmedAppointments;
  const DoctorHomeScreenDashboardLoaded({
    super.key,
    required this.pendingRequests,
    required this.confirmedAppointments,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: ScrollbarCustom(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Gap(30),
                const GreetingWidget(),
                const Gap(20),
                const HomeDashboardCalendarWidget(),
                const Gap(30),
                const UpcomingAppointmentsNavigationWidget(),
                const Gap(50),
                const PendingRequestsNavigationWidget(),
                const Gap(50),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Navigation Hub'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Gap(20),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      EmergencyAnnouncementNavigationWidget(),
                      Gap(15),
                      ScheduleManagementNavigationWidget(),
                      Gap(15),
                      DoctorForumsNavigationWidget(),
                    ],
                  ),
                ),
                const Gap(120),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
