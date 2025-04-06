import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/widgets/view_patient_data/view_patient_data.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/screens/view_states/doctor_consultation_on_going_appointment_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/widgets/face_to_face_widgets/doctor_consultation_face_to_face_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/widgets/doctor_consultation_menu.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/bloc/home_dashboard_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/consultation_no_appointment.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/consultation_waiting_appointment.dart';
import 'package:gina_app_4/main.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

class DoctorConsultationScreenProvider extends StatelessWidget {
  const DoctorConsultationScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorConsultationBloc>(
      create: (context) {
        final doctorConsultationBloc = sl<DoctorConsultationBloc>();

        String formattedPatientUid =
            selectedPatientUid!.replaceAll('"', '').trim();

        doctorConsultationBloc
            .add(DoctorConsultationGetRequestedAppointmentEvent(
          recipientUid: formattedPatientUid,
        ));
        return doctorConsultationBloc;
      },
      child: const DoctorConsultationScreen(),
    );
  }
}

class DoctorConsultationScreen extends StatelessWidget {
  const DoctorConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorConsultationBloc = context.read<DoctorConsultationBloc>();
    final homeDashboardBloc = context.read<HomeDashboardBloc>();
    return BlocBuilder<DoctorConsultationBloc, DoctorConsultationState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            if (state is NavigateToPatientDataState) {
              doctorConsultationBloc.add(
                DoctorConsultationGetRequestedAppointmentEvent(
                  recipientUid: selectedPatientUid!,
                ),
              );
              return false;
            }
            return true;
          },
          child: Scaffold(
            appBar: state is NavigateToPatientDataState
                ? null
                : AppBar(
                    notificationPredicate: (notification) => false,
                    title: Text(
                      selectedPatientName!,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    actions: [
                      Builder(
                        builder: (context) {
                          debugPrint(
                              'doctor_consultation_screen selectedPatientAppointment: $selectedPatientAppointment');
                          return DoctorConsultationMenu(
                            appointmentId: selectedPatientAppointment!,
                            completedAppointments:
                                completedAppointmentsForPatientDataMenu ?? [],
                          );
                        },
                      ),
                    ],
                  ),
            body: BlocConsumer<DoctorConsultationBloc, DoctorConsultationState>(
              listenWhen: (previous, current) =>
                  current is DoctorConsultationActionState,
              buildWhen: (previous, current) =>
                  current is! DoctorConsultationActionState,
              listener: (context, state) {
                if (state is DoctorConsultationCompletedAppointmentState) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: GinaAppTheme.appbarColorLight,
                      shadowColor: GinaAppTheme.appbarColorLight,
                      surfaceTintColor: GinaAppTheme.appbarColorLight,
                      icon: const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                        size: 80,
                      ),
                      content: SizedBox(
                        height: 100,
                        width: 250,
                        child: Column(
                          children: [
                            Text(
                              'Consultation has ended',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const Gap(30),
                            SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: FilledButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (canVibrate == true) {
                                    Haptics.vibrate(HapticsType.success);
                                  }
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text('Okay'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).then((value) {
                    Future.delayed(const Duration(milliseconds: 100), () {
                      doctorConsultationBloc.add(
                        DoctorConsultationGetRequestedAppointmentEvent(
                          recipientUid: selectedPatientUid!,
                        ),
                      );
                    });
                  });
                } else if (state is DoctorConsultationF2FLoadingState) {
                  const SizedBox.shrink();
                }
              },
              builder: (context, state) {
                debugPrint('Builder state: $state');
                if (state is DoctorConsultationNoAppointmentState) {
                  return const ConsultationNoAppointmentScreen();
                } else if (state
                        is DoctorConsultationFaceToFaceAppointmentState ||
                    state is DoctorConsultationF2FSessionStartedState ||
                    state is DoctorConsultationF2FSessionEndedState) {
                  if (state is DoctorConsultationFaceToFaceAppointmentState) {
                    selectedPatientDetails = state.patientDetails;
                  }
                  final patientDetails = selectedPatientDetails;
                  final patientAppointment = selectedPatientAppointmentModel;

                  if (patientDetails == null || patientAppointment == null) {
                    return const Center(
                      child: Text('No patient details or appointment found'),
                    );
                  }

                  return DoctorConsultationFaceToFaceScreen(
                    patientAppointment: patientAppointment,
                    patientDetails: patientDetails,
                  );
                } else if (state is DoctorConsultationLoadingState) {
                  return const Center(
                    child: CustomLoadingIndicator(),
                  );
                } else if (state
                    is DoctorConsultationWaitingForAppointmentState) {
                  return ConsultationWaitingAppointmentScreen(
                    appointment: state.appointment,
                    isDoctor: true,
                  );
                } else if (state is DoctorConsultationLoadedAppointmentState) {
                  final chatRoom = state.chatRoomId;
                  final patientUid = state.recipientUid;

                  return DoctorConsultationOnGoingAppointmentScreen(
                    patientUid: patientUid,
                    chatroom: chatRoom,
                    appointment:
                        selectedPatientAppointmentModel ?? AppointmentModel(),
                  );
                } else if (state is NavigateToPatientDataState) {
                  completedAppointmentsForPatientDataMenu =
                      state.patientAppointments;
                  return ViewPatientDataScreen(
                    patient: state.patientData,
                    patientAppointment: state.appointment,
                    patientAppointments: state.patientAppointments,
                    patientPeriods: state.patientPeriods,
                  );
                }
                return const Center(
                  child: CustomLoadingIndicator(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
