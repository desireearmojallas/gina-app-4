import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/core/reusable_widgets/gina_divider.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/bloc/doctor_consultation_fee_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/view_states/edit_doctor_consultation_fee_screen_loaded.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/screens/doctor_emergency_announcement_screen.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/bloc/home_dashboard_bloc.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/my_past_appointments_navigation_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/widget_navigation_cards.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/doctor_forums_navigation_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/emergency_announcement_navigation_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/greeting_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/home_dashboard_calendar_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/pending_requests_navigation_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/schedule_management_navigation_widget.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/upcoming_appointments_navigation_widget.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/main.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorHomeScreenDashboardLoaded extends StatelessWidget {
  final int pendingRequests;
  final int confirmedAppointments;
  final String doctorName;
  final AppointmentModel upcomingAppointment;
  final AppointmentModel pendingAppointment;
  final UserModel patientData;
  final Map<DateTime, List<AppointmentModel>> completedAppointmentsList;

  const DoctorHomeScreenDashboardLoaded({
    super.key,
    required this.pendingRequests,
    required this.confirmedAppointments,
    required this.doctorName,
    required this.upcomingAppointment,
    required this.pendingAppointment,
    required this.patientData,
    required this.completedAppointmentsList,
  });

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);
    final homeDashboardBloc = context.read<HomeDashboardBloc>();

    return RefreshIndicator(
      onRefresh: () async {
        try {
          homeDashboardBloc.add(const HomeInitialEvent());

          await Future.delayed(
              const Duration(milliseconds: 800)); // Simulating delay

          if (canVibrate == true) {
            await Haptics.vibrate(HapticsType.success);
          }
        } catch (e) {
          if (canVibrate == true) {
            await Haptics.vibrate(HapticsType.error);
          }

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Failed to refresh. Please try again.')),
            );
          }
        }
      },
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
                GreetingWidget(
                  doctorName: doctorName,
                ),
                const Gap(20),
                const HomeDashboardCalendarWidget(),
                const Gap(5),
                GinaDivider(
                  space: 0.0,
                ),
                const Gap(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<DoctorConsultationFeeBloc,
                        DoctorConsultationFeeState>(
                      builder: (context, state) {
                        if (state is NavigateToEditDoctorConsultationFeeState) {
                          Future.microtask(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  appBar: GinaDoctorAppBar(
                                    title: 'Edit Consultation Fees',
                                  ),
                                  body: EditDoctorConsultationFeeScreenLoaded(
                                    doctorData: state.doctorData,
                                    isFromDashboard: true,
                                  ),
                                ),
                              ),
                            );
                          });
                        }

                        return WidgetNavigationCards(
                          widgetText: 'Edit Consultation\nFees',
                          icon: Icons.paid,
                          onPressed: () async {
                            if (canVibrate == true) {
                              await Haptics.vibrate(HapticsType.selection);
                            }

                            if (context.mounted) {
                              context.read<DoctorConsultationFeeBloc>().add(
                                  NavigateToEditDoctorConsultationFeeEvent());
                            }
                          },
                        );
                      },
                    ),
                    WidgetNavigationCards(
                      widgetText: 'Create Emergency\nAnnouncement',
                      icon: MingCute.report_fill,
                      onPressed: () async {
                        // Trigger haptic feedback
                        // final canVibrate = await Haptics.canVibrate();
                        if (canVibrate == true) {
                          await Haptics.vibrate(HapticsType.selection);
                        }

                        // Navigate to the next screen
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DoctorEmergencyAnnouncementScreenProvider(
                                navigateToCreate: true,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const Gap(10),
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
                      decoration: BoxDecoration(
                        color: confirmedAppointments == 0
                            ? Colors.grey[300]
                            : GinaAppTheme.lightTertiaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          confirmedAppointments == 0
                              ? '0'
                              : confirmedAppointments.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        confirmedAppointments == 0
                            ? null
                            : Navigator.of(context)
                                .pushNamed('/doctorEConsult');
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'See all',
                          style: ginaTheme.textTheme.labelMedium?.copyWith(
                            color: confirmedAppointments == 0
                                ? Colors.grey[300]
                                : GinaAppTheme.lightTertiaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                UpcomingAppointmentsNavigationWidget(
                  upcomingAppointment: upcomingAppointment,
                  patientData: patientDataForUpcomingAppointment ??
                      UserModel(
                        name: '',
                        email: '',
                        uid: '',
                        gender: '',
                        dateOfBirth: '',
                        profileImage: '',
                        headerImage: '',
                        accountType: '',
                        address: '',
                        chatrooms: const [],
                        appointmentsBooked: const [],
                      ),
                ),
                const Gap(20),
                PendingRequestsNavigationWidget(
                  pendingRequests: pendingRequests,
                  pendingAppointment: pendingAppointment,
                  patientData: patientDataForPendingAppointment ??
                      UserModel(
                        name: '',
                        email: '',
                        uid: '',
                        gender: '',
                        dateOfBirth: '',
                        profileImage: '',
                        headerImage: '',
                        accountType: '',
                        address: '',
                        chatrooms: const [],
                        appointmentsBooked: const [],
                      ),
                ),
                const Gap(30),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyPastAppointmentsNavigationWidget(
                        completedAppointmentsList: completedAppointmentsList,
                        patientData: patientDataForPastAppointment ??
                            UserModel(
                              name: '',
                              email: '',
                              uid: '',
                              gender: '',
                              dateOfBirth: '',
                              profileImage: '',
                              headerImage: '',
                              accountType: '',
                              address: '',
                              chatrooms: const [],
                              appointmentsBooked: const [],
                            ),
                      ),
                      const Gap(15),
                      const EmergencyAnnouncementNavigationWidget(),
                      const Gap(15),
                      const ScheduleManagementNavigationWidget(),
                      const Gap(15),
                      const DoctorForumsNavigationWidget(),
                    ],
                  ),
                ),
                const Gap(100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
