import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:gina_app_4/features/patient_features/book_appointment/1_controllers/appointment_controller.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class AppointmentScreenProvider extends StatelessWidget {
  final int? initialIndex;
  const AppointmentScreenProvider({
    super.key,
    this.initialIndex,
  });

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
    // final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    // final int initialIndexFromArgs = arguments?['initialIndex'] ?? 3;

    final AppointmentController appointmentController =
        sl<AppointmentController>();
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
            child:
                //TODO: WILL DO THIS COMPLETED APPOINTMENT STATE LATER
                state is ConsultationHistoryState &&
                        state.appointment.appointmentStatus ==
                            AppointmentStatus.completed.index
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              isFromConsultationHistory = true;
                              Navigator.pushNamed(context, '/consultation');
                            },
                            child: const Icon(Icons.message),
                          ),
                          const Gap(10),
                          FloatingActionButton(
                            heroTag: 'uploadPrescription',
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              Navigator.pushNamed(
                                  context, '/uploadPrescription');
                            },
                            child: const Icon(Icons.upload_file),
                          ),
                        ],
                      )
                    : state is AppointmentDetailsState &&
                            state.appointment.appointmentStatus ==
                                AppointmentStatus.confirmed.index &&
                            state.appointment.modeOfAppointment ==
                                ModeOfAppointmentId.onlineConsultation.index
                        ? FloatingActionButton(
                            onPressed: () async {
                              HapticFeedback.mediumImpact();
                              isFromConsultationHistory = false;
                              selectedDoctorAppointmentModel =
                                  state.appointment;
                              final appointmentUid =
                                  state.appointment.appointmentUid;
                              if (appointmentUid != null) {
                                debugPrint(
                                    'Fetching appointment details for UID: $appointmentUid');
                                final appointment = await appointmentController
                                    .getAppointmentDetailsNew(appointmentUid);
                                if (appointment != null) {
                                  final DateFormat dateFormat =
                                      DateFormat('MMMM d, yyyy');
                                  final DateFormat timeFormat =
                                      DateFormat('hh:mm a');
                                  final DateTime now = DateTime.now();

                                  final DateTime appointmentDate =
                                      dateFormat.parse(
                                          appointment.appointmentDate!.trim());
                                  final List<String> times =
                                      appointment.appointmentTime!.split(' - ');
                                  final DateTime startTime =
                                      timeFormat.parse(times[0].trim());
                                  final DateTime endTime =
                                      timeFormat.parse(times[1].trim());

                                  final DateTime appointmentStartDateTime =
                                      DateTime(
                                    appointmentDate.year,
                                    appointmentDate.month,
                                    appointmentDate.day,
                                    startTime.hour,
                                    startTime.minute,
                                  );

                                  final DateTime appointmentEndDateTime =
                                      DateTime(
                                    appointmentDate.year,
                                    appointmentDate.month,
                                    appointmentDate.day,
                                    endTime.hour,
                                    endTime.minute,
                                  );

                                  debugPrint('Current time: $now');
                                  debugPrint(
                                      'Appointment start time: $appointmentStartDateTime');
                                  debugPrint(
                                      'Appointment end time: $appointmentEndDateTime');

                                  if (now.isAfter(appointmentStartDateTime) &&
                                      now.isBefore(appointmentEndDateTime) &&
                                      state.appointment.appointmentStatus ==
                                          AppointmentStatus.confirmed.index) {
                                    debugPrint(
                                        'Marking appointment as visited for UID: $appointmentUid');
                                    await appointmentController
                                        .markAsVisitedConsultationRoom(
                                            appointmentUid);
                                  } else {
                                    debugPrint(
                                        'Appointment is not within the valid time range or status is not confirmed.');
                                  }
                                } else {
                                  debugPrint('Appointment not found.');
                                }
                              } else {
                                debugPrint('Appointment UID is null.');
                              }

                              if (context.mounted) {
                                Navigator.pushNamed(context, '/consultation')
                                    .then((value) => appointmentBloc.add(
                                            NavigateToAppointmentDetailsEvent(
                                          doctorUid: doctorDetails!.uid,
                                          appointmentUid:
                                              state.appointment.appointmentUid!,
                                        )));
                              }
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
                  initialIndex: initialIndex,
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
