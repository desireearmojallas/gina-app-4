import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/floating_doctor_menu_bar/floating_doctor_menu_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/gina_header.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/bloc/home_dashboard_bloc.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/screens/view_states/doctor_home_dashboard_screen_loaded.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

class DoctorHomeScreenDashboardProvider extends StatelessWidget {
  const DoctorHomeScreenDashboardProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homeDashboardBloc = sl<HomeDashboardBloc>();
        homeDashboardBloc.add(HomeInitialEvent());
        return homeDashboardBloc;
      },
      child: const DoctorHomeScreenDashboard(),
    );
  }
}

class DoctorHomeScreenDashboard extends StatelessWidget {
  const DoctorHomeScreenDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GinaHeader(
          size: 45,
          isDoctor: true,
        ),
        actions: [
          FloatingDoctorMenuWidget(
            hasNotification: true,
          ),
          const Gap(10),
        ],
        surfaceTintColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.1),
      ),
      body: BlocConsumer<HomeDashboardBloc, HomeDashboardState>(
        listenWhen: (previous, current) => current is HomeDashboardActionState,
        buildWhen: (previous, current) => current is! HomeDashboardActionState,
        listener: (context, state) {
          if (state is HomeDashboardNavigateToFindDoctorActionState) {
            Navigator.pushNamed(context, '/find');
          }
        },
        builder: (context, state) {
          if (state is HomeDashboardInitial) {
            // Debug statements to check patientData
            debugPrint('Patient Data: ${state.patientData}');
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
          );
        },
      ),
    );
  }
}
