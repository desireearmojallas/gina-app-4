import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
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
      child: const ScrollbarCustom(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Gap(30),
                GreetingWidget(),
                Gap(20),
                HomeDashboardCalendarWidget(),
                Gap(50),
                UpcomingAppointmentsNavigationWidget(),
                Gap(50),
                PendingRequestsNavigationWidget(),
                Gap(50),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Navigation Hub',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Gap(20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      EmergencyAnnouncementNavigationWidget(),
                      Gap(25),
                      ScheduleManagementNavigationWidget(),
                      Gap(25),
                      DoctorForumsNavigationWidget(),
                    ],
                  ),
                ),
                Gap(120),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
