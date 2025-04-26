import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/floating_doctor_menu_bar/floating_doctor_menu_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/gina_header.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/1_controllers/doctor_appointment_request_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/widgets/face_to_face_widgets/alert_dialog_for_exceeding_face_to_face_appointment.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/bloc/home_dashboard_bloc.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/screens/view_states/doctor_home_dashboard_screen_loaded.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/appointment_time_monitor.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

class DoctorHomeScreenDashboardProvider extends StatelessWidget {
  const DoctorHomeScreenDashboardProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homeDashboardBloc = sl<HomeDashboardBloc>();
        homeDashboardBloc.add(const HomeInitialEvent());
        return homeDashboardBloc;
      },
      child: const DoctorHomeScreenDashboard(),
    );
  }
}

class DoctorHomeScreenDashboard extends StatelessWidget {
  const DoctorHomeScreenDashboard({super.key});

  static bool _isExceededAppointmentDialogShown = false;

  static void resetExceededAppointmentDialog() {
    _isExceededAppointmentDialogShown = false;
  }

  @override
  Widget build(BuildContext context) {
    return AppointmentTimeMonitor(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: GinaHeader(
            size: 45,
            isDoctor: true,
          ),
          actions: const [
            FloatingDoctorMenuWidget(
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
        //       builder: (context) => AlertDialogForExceedingFaceToFaceAppointment(
        //         patientName: "Jane Doe",
        //         scheduledEndTime: DateTime(2025, 4, 24, 14, 30), // 2:30 PM
        //         currentTime: DateTime(2025, 4, 24, 15, 10), // 3:10 PM
        //         onConcludeAppointment: () {
        //           // Handle concluding the appointment
        //           Navigator.of(context).pop();
        //           // Add your appointment conclusion logic
        //         },
        //         onExtendAppointment: () {
        //           // Handle extending the appointment
        //           Navigator.of(context).pop();
        //           // Show extension options or update schedule
        //         },
        //         onDismiss: () {
        //           // Just close the dialog but perhaps show again later
        //           Navigator.of(context).pop();
        //         },
        //       ),
        //     );
        //   },
        //   child: const Icon(Icons.add),
        // ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<HomeDashboardBloc, HomeDashboardState>(
              listenWhen: (previous, current) =>
                  current is HomeDashboardActionState,
              listener: (context, state) {
                if (state is HomeDashboardNavigateToFindDoctorActionState) {
                  Navigator.pushNamed(context, '/find');
                } else if (state is AppointmentExceededTimeState &&
                    !_isExceededAppointmentDialogShown) {
                  _isExceededAppointmentDialogShown = true;

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        AlertDialogForExceedingFaceToFaceAppointment(
                      patientName: state.patientName,
                      scheduledEndTime: state.scheduledEndTime,
                      currentTime: state.currentTime,
                      onConcludeAppointment: () {
                        // Handle concluding the appointment
                        final controller =
                            sl<DoctorAppointmentRequestController>();
                        controller
                            .concludeF2FPatientAppointment(
                          appointmentId: state.appointmentId,
                        )
                            .then((value) {
                          // Refresh dashboard data
                          context
                              .read<HomeDashboardBloc>()
                              .add(const HomeInitialEvent());
                          Navigator.of(context).pop();
                          f2fAppointmentEnded = true;
                          resetExceededAppointmentDialog();
                        });
                      },
                      // In your BlocListener where you show the dialog:

                      onExtendAppointment: () {
                        // Handle extending appointment time
                        Navigator.of(context).pop();
                        resetExceededAppointmentDialog();
                        // Reset timer to check again after 30 minutes
                        AppointmentTimeMonitor.resetTimerGlobally(
                            context, const Duration(minutes: 30));
                        // Show extension dialog or navigate to appointment details
                      },
                      onDismiss: () {
                        // Just close dialog but check again after 5 minutes
                        Navigator.of(context).pop();
                        resetExceededAppointmentDialog();
                        // Reset timer to check again after 5 minutes
                        AppointmentTimeMonitor.resetTimerGlobally(
                            context, const Duration(minutes: 5));
                      },
                    ),
                  );
                }
              },
            ),
          ],
          child: BlocConsumer<HomeDashboardBloc, HomeDashboardState>(
            listenWhen: (previous, current) =>
                current is HomeDashboardActionState,
            buildWhen: (previous, current) =>
                current is! HomeDashboardActionState,
            listener: (context, state) {
              if (state is HomeDashboardNavigateToFindDoctorActionState) {
                Navigator.pushNamed(context, '/find');
              }
            },
            builder: (context, state) {
              if (state is HomeDashboardInitial) {
                // Debug statements to check patientData
                debugPrint('Patient Data: ${state.patientData}');
                debugPrint(
                    'Completed Appointments from HomeDashboardInitial: ${state.completedAppointmentsForPatientData}');
                debugPrint(
                    'Doctor Home Dashboard Screen Patient Periods: ${state.patientPeriods}');
                return DoctorHomeScreenDashboardLoaded(
                  pendingRequests: state.pendingAppointments,
                  confirmedAppointments: state.confirmedAppointments,
                  doctorName: state.doctorName,
                  upcomingAppointment: state.upcomingAppointment!,
                  pendingAppointment: state.pendingAppointmentLatest!,
                  patientData: state.patientData ??
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
                  completedAppointmentsList: state.completedAppointmentList!,
                  completedAppointments:
                      state.completedAppointmentsForPatientData,
                  patientPeriods: state.patientPeriods,
                );
              }
              return DoctorHomeScreenDashboardLoaded(
                pendingRequests: 0,
                confirmedAppointments: 0,
                doctorName: '',
                upcomingAppointment: AppointmentModel(),
                pendingAppointment: AppointmentModel(),
                patientData: UserModel(
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
                completedAppointmentsList: const {},
                completedAppointments: const [],
                patientPeriods: const [],
              );
            },
          ),
        ),
      ),
    );
  }
}
