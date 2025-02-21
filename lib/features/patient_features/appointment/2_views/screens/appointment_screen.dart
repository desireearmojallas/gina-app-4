import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/screens/view_states/appointment_screen_loaded.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/screens/view_states/consultation_history_details.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/screens/view_states/appointment_details_status_screen.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/cancel_appointment_widgets/cancellation_success_modal.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/1_controllers/appointment_controller.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

class AppointmentScreenProvider extends StatelessWidget {
  final int? initialIndex;
  const AppointmentScreenProvider({
    super.key,
    this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('AppointmentScreenProvider build method called');

    return BlocProvider<AppointmentBloc>(
      create: (context) {
        final appointmentBloc = sl<AppointmentBloc>();
        debugPrint('AppointmentBloc created');

        if (isUploadPrescriptionMode) {
          appointmentBloc.add(NavigateToConsultationHistoryEvent(
              doctorUid: doctorDetails!.uid,
              appointmentUid: storedAppointmentUid!));
        } else {
          appointmentBloc.add(GetAppointmentsEvent());
        }

        return appointmentBloc;
      },
      child: AppointmentScreen(
        initialIndex: initialIndex ?? 3,
      ),
    );
  }
}

class AppointmentScreen extends StatelessWidget {
  final int initialIndex;
  const AppointmentScreen({
    super.key,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    final AppointmentController appointmentController =
        sl<AppointmentController>();
    final appointmentBloc = context.read<AppointmentBloc>();
    return BlocConsumer<AppointmentBloc, AppointmentState>(
      listenWhen: (previous, current) => current is AppointmentActionState,
      buildWhen: (previous, current) => current is! AppointmentActionState,
      listener: (context, state) {
        debugPrint('AppointmentScreen listener: $state');
        if (state is CancelAppointmentState) {
          showCancellationSuccessDialog(context)
              .then((value) => appointmentBloc.add(GetAppointmentsEvent()));
        } else if (state is AppointmentDetailsState) {
          debugPrint('Received AppointmentDetailsState');
        }
      },
      builder: (context, state) {
        debugPrint('AppointmentScreen builder: $state');
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
            child: (state is ConsultationHistoryState &&
                        state.appointment.appointmentStatus ==
                            AppointmentStatus.completed.index) ||
                    (state is AppointmentDetailsState &&
                        (state.appointment.appointmentStatus ==
                                AppointmentStatus.confirmed.index ||
                            state.appointment.appointmentStatus ==
                                AppointmentStatus.completed.index))
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildFloatingActionButton(
                        heroTag: 'consultation',
                        icon: MingCute.message_3_fill,
                        onPressed: () async {
                          await appointmentBloc.handleConsultationNavigation(
                              state, context);
                        },
                        context: context,
                      ),
                      const Gap(10),
                      buildFloatingActionButton(
                        heroTag: 'uploadPrescription',
                        icon: MingCute.upload_line,
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          Navigator.pushNamed(context, '/uploadPrescription');
                        },
                        context: context,
                        // isOkayToUploadPrescription: state.appointment.appointmentStatus ==
                        //         AppointmentStatus.completed.index
                        //     ? true
                        //     : false,
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
          body: BlocConsumer<AppointmentBloc, AppointmentState>(
            listenWhen: (previous, current) =>
                current is AppointmentActionState,
            buildWhen: (previous, current) =>
                current is! AppointmentActionState,
            listener: (context, state) {
              debugPrint('AppointmentScreen listener: $state');
              if (state is CancelAppointmentState) {
                showCancellationSuccessDialog(context).then(
                    (value) => appointmentBloc.add(GetAppointmentsEvent()));
              } else if (state is AppointmentDetailsState) {
                debugPrint('🔎 Received AppointmentDetailsState');
              }
            },
            builder: (context, state) {
              debugPrint('AppointmentScreen builder: $state');
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
                  initialIndex: initialIndex,
                  chatRooms: state.chatRooms,
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
                debugPrint('Navigating to AppointmentDetailsStatusScreen');
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
