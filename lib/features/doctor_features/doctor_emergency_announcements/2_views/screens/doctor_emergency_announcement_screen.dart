import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/1_controller/doctor_emergency_announcements_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/bloc/doctor_emergency_announcements_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/screens/view_states/doctor_emergency_announcement_create_announcement.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/screens/view_states/doctor_emergency_announcement_initial.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/screens/view_states/doctor_emergency_announcement_loaded_details_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/screens/view_states/doctor_emergency_announcement_patient_list.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/screens/view_states/doctor_emergency_announcements_loaded.dart';

class DoctorEmergencyAnnouncementScreenProvider extends StatelessWidget {
  final bool navigateToCreate;
  const DoctorEmergencyAnnouncementScreenProvider(
      {super.key, required this.navigateToCreate});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorEmergencyAnnouncementsBloc>(
      create: (context) {
        final doctorEmergencyAnnouncementsBloc =
            sl<DoctorEmergencyAnnouncementsBloc>();
        // doctorEmergencyAnnouncementsBloc
        //     .add(GetDoctorEmergencyAnnouncementsEvent());
        if (navigateToCreate) {
          doctorEmergencyAnnouncementsBloc
              .add(NavigateToDoctorEmergencyCreateAnnouncementEvent());
        } else {
          doctorEmergencyAnnouncementsBloc
              .add(GetDoctorEmergencyAnnouncementsEvent());
        }
        return doctorEmergencyAnnouncementsBloc;
      },
      child: const DoctorEmergencyAnnouncementScreen(),
    );
  }
}

class DoctorEmergencyAnnouncementScreen extends StatelessWidget {
  const DoctorEmergencyAnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorEmergencyAnnouncementsBloc =
        context.read<DoctorEmergencyAnnouncementsBloc>();

    return BlocBuilder<DoctorEmergencyAnnouncementsBloc,
        DoctorEmergencyAnnouncementsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: GinaDoctorAppBar(
            leading: state is DoctorEmergencyGetApprovedPatientList
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      doctorEmergencyAnnouncementsBloc.add(
                          NavigateToDoctorEmergencyCreateAnnouncementEvent());
                    },
                  )
                : state is CreateAnnouncementState ||
                        state is NavigateToDoctorCreatedAnnouncementState
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          doctorEmergencyAnnouncementsBloc
                              .add(GetDoctorEmergencyAnnouncementsEvent());
                        },
                      )
                    : null,
            title: state is DoctorEmergencyGetApprovedPatientList
                ? 'Select patients'
                : state is CreateAnnouncementState
                    ? 'Create Announcement'
                    : 'Emergency Announcements',
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 78),
            child: state is DoctorEmergencyAnnouncementsLoaded ||
                    state is DoctorEmergencyAnnouncementsInitial ||
                    state is DoctorEmergencyAnnouncementsEmpty ||
                    state is DoctorEmergencyAnnouncementsLoaded
                ? FloatingActionButton(
                    onPressed: () {
                      doctorEmergencyAnnouncementsBloc.add(
                          NavigateToDoctorEmergencyCreateAnnouncementEvent());
                    },
                    child: const Icon(
                      CupertinoIcons.add,
                    ),
                  )
                : null,
          ),
          body: BlocConsumer<DoctorEmergencyAnnouncementsBloc,
              DoctorEmergencyAnnouncementsState>(
            listenWhen: (previous, current) =>
                current is DoctorEmergencyAnnouncementsActionState,
            buildWhen: (previous, current) =>
                current is! DoctorEmergencyAnnouncementsActionState,
            listener: (context, state) {},
            builder: (context, state) {
              if (state is DoctorEmergencyAnnouncementsInitial) {
                return const DoctorEmergencyAnnouncementInitialScreen();
              } else if (state is DoctorEmergencyAnnouncementsLoaded) {
                return DoctorEmergencyAnnouncementsLoadedScreen(
                  emergencyAnnouncements: state.emergencyAnnouncements,
                );
              } else if (state is DoctorEmergencyAnnouncementsLoading) {
                return const Center(
                  child: CustomLoadingIndicator(),
                );
              } else if (state is DoctorEmergencyAnnouncementsError) {
                return Center(
                  child: Text(state.errorMessage),
                );
              } else if (state is CreateAnnouncementState ||
                  state is CreateAnnouncementLoadingState) {
                return DoctorEmergencyAnnouncementCreateAnnouncementScreen(
                  isLoading: state is CreateAnnouncementLoadingState,
                );
              } else if (state is DoctorEmergencyAnnouncementsEmpty) {
                return const DoctorEmergencyAnnouncementInitialScreen();
              } else if (state is DoctorEmergencyGetApprovedPatientList) {
                return DoctorEmergencyAnnouncementPatientList(
                  approvedPatients: state.approvedPatientList,
                );
              } else if (state is SelectedPatientsState) {
                debugPrint(
                    '✅ Showing Create Announcement with Selected Patients: ${state.selectedAppointments.length}');
                for (int i = 0; i < state.selectedAppointments.length; i++) {
                  debugPrint(
                      '👤 Selected patient #${i + 1}: ${state.selectedAppointments[i].patientName}');
                }
                return DoctorEmergencyAnnouncementCreateAnnouncementScreen(
                  isLoading: false,
                );
              } else if (state is NavigateToDoctorCreatedAnnouncementState) {
                return DoctorEmergencyAnnouncementsLoadedDetailsScreen(
                  emergencyAnnouncement: state.emergencyAnnouncement,
                  appointment: chosenAppointment!,
                );
              }
              return const SizedBox();
            },
          ),
        );
      },
    );
  }
}
