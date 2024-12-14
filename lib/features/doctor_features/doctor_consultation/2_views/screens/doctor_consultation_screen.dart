import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/screens/view_states/doctor_consultation_on_going_appointment_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/screens/view_states/patient_data_details_state.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/widgets/doctor_consultation_menu.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/consultation_no_appointment.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/consultation_waiting_appointment.dart';

class DoctorConsultationScreenProvider extends StatelessWidget {
  const DoctorConsultationScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorConsultationBloc>(
      create: (context) {
        final doctorConsultationBloc = sl<DoctorConsultationBloc>();

        String formattedPatientUid =
            selectedPatientUid!.replaceAll('"', '').trim();

        doctorConsultationBloc.add(
          DoctorConsultationGetRequestedAppointmentEvent(
            recipientUid: formattedPatientUid,
          ),
        );

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
    final ginaTheme = Theme.of(context);
    final doctorConsultationBloc = context.read<DoctorConsultationBloc>();
    return BlocBuilder<DoctorConsultationBloc, DoctorConsultationState>(
      builder: (context, state) {
        return Scaffold(
          //! Chat view with patient's name. different appbar for the patient information. to be changed with bloc implementation
          // appBar: AppBar(
          //   title: Text(
          //     'Desiree Armojallas',
          //   ),
          //   actions: [
          //     DoctorConsultationMenu(),
          //   ],
          // ),

          appBar: state is NavigateToPatientDataState
              ? GinaDoctorAppBar(
                  title: 'Patient Details',
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      doctorConsultationBloc
                          .add(DoctorConsultationGetRequestedAppointmentEvent(
                        recipientUid: selectedPatientUid!,
                      ));
                    },
                  ),
                )
              : AppBar(
                  notificationPredicate: (notification) => false,
                  title: Text(
                    selectedPatientName!,
                    style: ginaTheme.textTheme.headlineMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  actions: [
                    DoctorConsultationMenu(
                      appointmentId: selectedPatientAppointment!,
                    ),
                  ],
                ),
          resizeToAvoidBottomInset: true,
          body: BlocConsumer<DoctorConsultationBloc, DoctorConsultationState>(
            listenWhen: (previous, current) =>
                current is DoctorConsultationActionState,
            buildWhen: (previous, current) =>
                current is! DoctorConsultationActionState,
            listener: (context, state) {},
            builder: (context, state) {
              if (state is DoctorConsultationNoAppointmentState) {
                return const ConsultationNoAppointmentScreen();
              } else if (state is DoctorConsultationLoadingState) {
                return const Center(
                  child: CustomLoadingIndicator(),
                );
              } else if (state is DoctorConsultationWaitingAppointmentState) {
                return const ConsultationWaitingAppointmentScreen();
              } else if (state is DoctorConsultationLoadedAppointmentState) {
                final chatRoom = state.chatRoomId;
                final patientUid = state.recipientUid;

                return DoctorConsultationOnGoingAppointmentScreen(
                  patientUid: patientUid,
                  chatroom: chatRoom,
                );
              } else if (state is NavigateToPatientDataState) {
                return PatientDataScreenState(
                  patient: state.patientData,
                  patientAppointment: state.appointment,
                  patientAppointments: state.patientAppointments,
                  patientPeriods: state.patientPeriods,
                );
              }

              //! to be continued....
              return const CustomLoadingIndicator();
            },
          ),
        );
      },
    );
  }
}
