import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/screens/view_states/appointment_screen_loaded.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/screens/view_states/consultation_history_details.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/screens/view_states/appointment_details_status_screen.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/cancel_appointment_widgets/cancellation_success_modal.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

class AppointmentScreenProvider extends StatelessWidget {
  const AppointmentScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppointmentBloc>(
      create: (context) {
        final appointmentBloc = sl<AppointmentBloc>();

        if (isUploadPrescriptionMode) {
          appointmentBloc.add(NavigateToConsultationHistoryEvent(
              doctorUid: doctorDetails!.uid,
              appointmentUid: storedAppointmentUid!));
        } else {
          appointmentBloc.add(GetAppointmentsEvent());
        }

        return appointmentBloc;
      },
      child: const AppointmentScreen(),
    );
  }
}

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentBloc = context.read<AppointmentBloc>();
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        return Scaffold(
          appBar: GinaPatientAppBar(
            title: state is AppointmentDetailsState ||
                    state is AppointmentDetailsLoading
                ? 'Appointment Details'
                : state is ConsultationHistoryState ||
                        state is ConsultationHistoryLoading
                    ? 'Consultation History'
                    : 'Appointments',
            leading: state is AppointmentDetailsState ||
                    state is ConsultationHistoryState
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      isFromAppointmentTabs = false;
                      appointmentBloc.add(GetAppointmentsEvent());
                    },
                  )
                : isUploadPrescriptionMode
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          isUploadPrescriptionMode = false;
                          Navigator.pushReplacementNamed(
                              context, '/bottomNavigation');
                        },
                      )
                    : null,
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: state is ConsultationHistoryState &&
                    state.appointment.appointmentStatus ==
                        AppointmentStatus.completed.index
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          isFromConsultationHistory = true;
                          Navigator.pushNamed(context, '/consultation');
                        },
                        child: const Icon(Icons.message),
                      ),
                      const Gap(10),
                      FloatingActionButton(
                        heroTag: 'uploadPrescription',
                        onPressed: () {
                          Navigator.pushNamed(context, '/uploadPrescription');
                        },
                        child: const Icon(Icons.upload_file),
                      ),
                    ],
                  )
                : state is AppointmentDetailsState
                    ? FloatingActionButton(
                        onPressed: () {
                          isFromConsultationHistory = false;
                          Navigator.pushNamed(context, '/consultation');
                        },
                        child: const Icon(MingCute.message_3_fill),
                      )
                    : const SizedBox(),
          ),
          body: BlocConsumer<AppointmentBloc, AppointmentState>(
            listenWhen: (previous, current) => state is AppointmentActionState,
            buildWhen: (previous, current) => state is! AppointmentActionState,
            listener: (context, state) {
              if (state is CancelAppointmentState) {
                showCancellationSuccessDialog(context).then(
                    (value) => appointmentBloc.add(GetAppointmentsEvent()));
              }
            },
            builder: (context, state) {
              if (state is GetAppointmentsLoading) {
                return const Center(
                  child: CustomLoadingIndicator(),
                );
              } else if (state is ConsultationHistoryLoading) {
                return const Center(
                  child: CustomLoadingIndicator(),
                );
              } else if (state is GetAppointmentsLoaded) {
                return AppointmentScreenLoaded(
                  appointments: state.appointments,
                );
              } else if (state is GetAppointmentsError) {
                return Center(
                  child: Text(state.errorMessage),
                );
              } else if (state is AppointmentDetailsLoading) {
                return const Center(
                  child: CustomLoadingIndicator(),
                );
              } else if (state is AppointmentDetailsState) {
                return AppointmentDetailsStatusScreen(
                  appointment: state.appointment,
                  doctorDetails: state.doctorDetails,
                  currentPatient: state.currentPatient,
                );
              } else if (state is ConsultationHistoryState) {
                return ConsultationHistoryDetailScreen(
                  appointment: state.appointment,
                  doctorDetails: state.doctorDetails,
                  currentPatient: state.currentPatient,
                  prescriptionImages: state.prescriptionImages,
                );
              }
              return Container();
            },
          ),
        );
      },
    );
  }
}
