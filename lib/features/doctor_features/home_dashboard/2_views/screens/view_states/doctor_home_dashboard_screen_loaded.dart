import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/view_states/edit_doctor_consultation_fee_screen_loaded.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/screens/view_states/doctor_emergency_announcement_create_announcement.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/bloc/home_dashboard_bloc.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/create_emergency_announcement_widget_navigation.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/doctor_forums_navigation_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/emergency_announcement_navigation_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/greeting_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/home_dashboard_calendar_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/pending_requests_navigation_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/schedule_management_navigation_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/upcoming_appointments_navigation_widget.dart';
import 'package:icons_plus/icons_plus.dart';

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
    final ginaTheme = Theme.of(context);

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
                BlocBuilder<HomeDashboardBloc, HomeDashboardState>(
                  builder: (context, state) {
                    if (state is GetDoctorNameState) {
                      return GreetingWidget(
                        doctorName: state.doctorName,
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const Gap(20),
                const HomeDashboardCalendarWidget(),
                const Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CreateEmergencyAnnouncementWidgetNavigation(
                      widgetText: 'Edit Consultation\nFees',
                      icon: Icons.paid,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditDoctorConsultationFeeScreenLoaded(),
                          ),
                        );
                      },
                    ),
                    CreateEmergencyAnnouncementWidgetNavigation(
                      widgetText: 'Create Emergency\nAnnouncement',
                      icon: MingCute.report_fill,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DoctorEmergencyAnnouncementCreateAnnouncementScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const Gap(30),
                Row(
                  children: [
                    Text(
                      'Upcoming Appointments'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(10),
                    Container(
                      height: 20,
                      width: 20,
                      decoration: const BoxDecoration(
                        color: GinaAppTheme.lightTertiaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '3',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        // TODO: UPCOMING APPOINTMENTS ROUTE
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'See all',
                          style: ginaTheme.textTheme.labelMedium?.copyWith(
                            color: GinaAppTheme.lightTertiaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const UpcomingAppointmentsNavigationWidget(),
                const Gap(40),
                const PendingRequestsNavigationWidget(),
                const Gap(40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Navigation Hub'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
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
