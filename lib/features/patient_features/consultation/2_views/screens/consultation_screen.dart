import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/consultation_loaded_appointment.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/consultation_no_appointment.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/consultation_waiting_appointment.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';

class ConsultationScreenProvider extends StatelessWidget {
  const ConsultationScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConsultationBloc>(
      create: (context) {
        final consultationBloc = sl<ConsultationBloc>();
        consultationBloc.add(ConsultationGetRequestedAppointmentEvent(
          recipientUid: doctorDetails!.uid,
        ));
        return consultationBloc;
      },
      child: const ConsultationScreen(),
    );
  }
}

class ConsultationScreen extends StatelessWidget {
  const ConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsultationBloc, ConsultationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: GinaPatientAppBar(
            title: 'Dr. ${doctorDetails!.name}',
          ),
          backgroundColor: state is ConsultationNoAppointmentState
              ? Colors.white
              : Colors.grey[200],
          body: BlocConsumer<ConsultationBloc, ConsultationState>(
            listenWhen: (previous, current) =>
                current is ConsultationActionState,
            buildWhen: (previous, current) =>
                current is! ConsultationActionState,
            listener: (context, state) {},
            builder: (context, state) {
              if (state is ConsultationNoAppointmentState) {
                return const ConsultationNoAppointmentScreen();
              } else if (state is ConsultationLoadingState) {
                return const Center(
                  child: CustomLoadingIndicator(),
                );
              } else if (state is ConsultationWaitingAppointmentState) {
                return const ConsultationWaitingAppointmentScreen();
              } else if (state is ConsultationLoadedAppointmentState) {
                final doctorDetails = state.recipientUid;
                final chatRoom = state.chatroomId;
                return ConsultationOnGoingAppointmentScreen(
                  doctorUid: doctorDetails,
                  chatroom: chatRoom,
                );
              }
              return const Center(
                child: CustomLoadingIndicator(),
              );
            },
          ),
        );
      },
    );
  }
}
