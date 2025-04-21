import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/floating_menu_bar/2_views/floating_menu_bar.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/gina_header.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/0_model/emergency_announcements_model.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/widgets/alert_dialog_for_approved_appointments_payment/screens/alert_dialog_for_approved_appointments_payment.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/widgets/emergency_notifications_alert_dialog/emergency_notifications_alert_dialog.dart';
import 'package:gina_app_4/features/patient_features/emergency_announcements/2_views/bloc/emergency_announcements_bloc.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/screens/view_states/home_screen_loaded.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/bloc/home_bloc.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/bloc/period_tracker_bloc.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/period_tracker_screen.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/widgets/period_alert_dialog.dart';

class HomeScreenProvider extends StatelessWidget {
  const HomeScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) {
            final homeBloc = sl<HomeBloc>();
            homeBloc.add(GetPatientCurrentLocationEvent());
            homeBloc.add(HomeInitialEvent());
            return homeBloc;
          },
        ),
        BlocProvider<PeriodTrackerBloc>(
          create: (context) {
            final periodTrackerBloc = sl<PeriodTrackerBloc>();
            periodDates.clear();
            periodTrackerBloc.add(GetFirstMenstrualPeriodDatesEvent());
            periodTrackerBloc.add(DisplayDialogUpcomingPeriodEvent());
            return periodTrackerBloc;
          },
        ),
        BlocProvider<AppointmentBloc>.value(
          value: sl<AppointmentBloc>(),
        ),
        BlocProvider<EmergencyAnnouncementsBloc>(
          create: (context) {
            final emergencyBloc = sl<EmergencyAnnouncementsBloc>();
            emergencyBloc.add(GetEmergencyAnnouncements());
            return emergencyBloc;
          },
        ),
      ],
      child: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static bool _isDialogShown = false;
  static bool _isPaymentDialogShown = false;
  static bool _isEmergencyDialogShown = false;
  static List<EmergencyAnnouncementModel> _pendingAnnouncements = [];

  static AppointmentModel? _pendingPaymentAppointment;
  static DateTime? _pendingPaymentApprovalTime;

  static final ValueNotifier<bool> paymentReminderNotifier =
      ValueNotifier<bool>(false);

  static bool get hasPendingPayment => _pendingPaymentAppointment != null;

  static AppointmentModel? get pendingPaymentAppointment =>
      _pendingPaymentAppointment;
  static DateTime? get pendingPaymentApprovalTime =>
      _pendingPaymentApprovalTime;

  static void setPendingPayment(AppointmentModel appointment,
      {DateTime? approvalTime}) {
    _pendingPaymentAppointment = appointment;
    _pendingPaymentApprovalTime = approvalTime ?? DateTime.now();
    paymentReminderNotifier.value = true;
    debugPrint(
        '===> PAYMENT REMINDER: Set pending payment for appointment: ${appointment.appointmentUid}');
    debugPrint('===> PAYMENT REMINDER: hasPendingPayment = true');
  }

  static void clearPendingPayment() {
    _pendingPaymentAppointment = null;
    _pendingPaymentApprovalTime = null;
    paymentReminderNotifier.value = false;
    debugPrint('===> PAYMENT REMINDER: Cleared pending payment');
    debugPrint('===> PAYMENT REMINDER: hasPendingPayment = false');
  }

  static void resetPaymentDialogShown() {
    _isPaymentDialogShown = false;
  }

  static // Add this method to the HomeScreen class
      void showNextEmergencyAnnouncement(BuildContext context) {
    // Safety check
    if (_pendingAnnouncements.isEmpty || _isEmergencyDialogShown) {
      return;
    }

    _isEmergencyDialogShown = true;

    // Get the next announcement to show
    final announcement = _pendingAnnouncements[0];

    // Capture the bloc before showing dialog
    final emergencyBloc = context.read<EmergencyAnnouncementsBloc>();
    final appointmentBloc = context.read<AppointmentBloc>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: emergencyBloc),
          BlocProvider.value(value: appointmentBloc),
        ],
        child: EmergencyNotificationsAlertDialog(
          announcement: announcement,
        ),
      ),
    ).then((_) {
      // Remove the announcement we just showed from the pending list
      _pendingAnnouncements.removeAt(0);
      _isEmergencyDialogShown = false;

      // If there are more pending announcements, show the next one
      if (_pendingAnnouncements.isNotEmpty) {
        // Short delay to prevent UI flicker between dialogs
        Future.delayed(const Duration(milliseconds: 300), () {
          showNextEmergencyAnnouncement(context);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    final periodTrackerBloc = context.read<PeriodTrackerBloc>();

    BuildContext? dialogContext;

    return Scaffold(
      appBar: AppBar(
        title: GinaHeader(size: 45),
        actions: const [
          FloatingMenuWidget(
            hasNotification: true,
          ),
          Gap(10),
        ],
        surfaceTintColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.1),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showDialog(
      //       context: context,
      //       builder: (context) => const EmergencyNotificationsAlertDialog(),
      //     );
      //   },
      //   child: const Icon(
      //     Icons.add,
      //     color: GinaAppTheme.lightSurfaceVariant,
      //   ),
      // ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<PeriodTrackerBloc, PeriodTrackerState>(
            listener: (context, state) {
              if (state is DisplayDialogUpcomingPeriodState &&
                  !_isDialogShown) {
                PeriodAlertDialog.showPeriodAlertDialog(
                  context,
                  state.startDate,
                  periodTrackerBloc,
                  state.periodTrackerModel,
                );

                _isDialogShown = true;
              } else if (state is NavigateToPeriodTrackerEditDatesState) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PeriodTrackerScreenProvider(
                    shouldTriggerEdit: true,
                    periodTrackerModel: state.periodTrackerModel,
                  );
                }));
              }
            },
          ),
          BlocListener<HomeBloc, HomeState>(
            listenWhen: (previous, current) =>
                current is DisplayApprovedAppointmentPaymentDialogState,
            listener: (context, state) {
              if (state is DisplayApprovedAppointmentPaymentDialogState &&
                  !_isPaymentDialogShown) {
                _isPaymentDialogShown = true;
                AlertDialogForApprovedAppointmentsPaymentProvider.show(context,
                    appointment: state.appointment);
              }
            },
          ),
          BlocListener<EmergencyAnnouncementsBloc, EmergencyAnnouncementsState>(
            listener: (context, state) {
              if (state is EmergencyAnnouncementsLoaded &&
                  !_isEmergencyDialogShown) {
                if (state.emergencyAnnouncements.isNotEmpty) {
                  // Find all unread announcements
                  _pendingAnnouncements = state.emergencyAnnouncements
                      .where((announcement) =>
                          announcement.clickedByPatient != true)
                      .toList();

                  // Show the first one if available
                  if (_pendingAnnouncements.isNotEmpty) {
                    showNextEmergencyAnnouncement(context);
                  }
                }
              }

              if (state is EmergencyNotificationReceivedState &&
                  !_isEmergencyDialogShown &&
                  state.announcement.clickedByPatient != true) {
                // Add the new announcement to our pending list
                _pendingAnnouncements.add(state.announcement);

                // Show it if we're not already showing something
                if (!_isEmergencyDialogShown) {
                  showNextEmergencyAnnouncement(context);
                }
              }
            },
          ),
        ],
        child: BlocConsumer<HomeBloc, HomeState>(
          listenWhen: (previous, current) => current is HomeActionState,
          buildWhen: (previous, current) => current is! HomeActionState,
          listener: (context, state) {
            // Keep this empty or handle actions from HomeBloc
          },
          builder: (context, state) {
            if (state is HomeInitial) {
              return HomeScreenLoaded(
                completedAppointments: state.completedAppointments,
              );
            }
            return HomeScreenLoaded(
              completedAppointments: storedCompletedAppointments,
            );
          },
        ),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton({
    required String heroTag,
    required IconData icon,
    required VoidCallback onPressed,
    bool? isOkayToUploadPrescription = true,
    required BuildContext context,
  }) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: isOkayToUploadPrescription == true ? onPressed : null,
      backgroundColor: isOkayToUploadPrescription == true
          ? Theme.of(context).primaryColor
          : GinaAppTheme.lightSurfaceVariant,
      elevation: isOkayToUploadPrescription == true ? 4.0 : 0.0,
      child: Icon(
        icon,
        color: isOkayToUploadPrescription == true
            ? Colors.white
            : Colors.white.withOpacity(0.5),
      ),
    );
  }
}
