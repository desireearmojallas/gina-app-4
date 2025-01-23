import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/consultation_loaded_appointment.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/consultation_no_appointment.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/consultation_waiting_appointment.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';

class ConsultationScreenProvider extends StatelessWidget {
  const ConsultationScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final DoctorModel? doctorDetailsFromOnGoing = args?['doctorDetails'];
    final AppointmentModel? appointment = args?['appointment'];

    selectedDoctorAppointmentModel ??= appointment;
    storedAppointmentUid ??= appointment?.appointmentUid;

    return BlocProvider<ConsultationBloc>(
      create: (context) {
        final consultationBloc = sl<ConsultationBloc>();
        if (doctorDetailsFromOnGoing != null) {
          consultationBloc.add(
            ConsultationGetRequestedAppointmentEvent(
              recipientUid: doctorDetailsFromOnGoing.uid,
            ),
          );
        } else {
          consultationBloc.add(
            ConsultationGetRequestedAppointmentEvent(
              recipientUid: doctorDetails!.uid,
            ),
          );
        }

        return consultationBloc;
      },
      child: ConsultationScreen(
        doctorDetails: doctorDetails ?? doctorDetailsFromOnGoing!,
      ),
    );
  }
}

class ConsultationScreen extends StatelessWidget {
  final DoctorModel doctorDetails;

  const ConsultationScreen({
    super.key,
    required this.doctorDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: GinaPatientAppBar(
      //   title: 'Dr. ${doctorDetails!.name}',
      // ),
      appBar: AppBar(
        title: Text('Dr. ${doctorDetails.name}'),
      ),
      body: BlocConsumer<ConsultationBloc, ConsultationState>(
        listenWhen: (previous, current) => current is ConsultationActionState,
        buildWhen: (previous, current) => current is! ConsultationActionState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ConsultationNoAppointmentState) {
            return const ConsultationNoAppointmentScreen();
          } else if (state is ConsultationLoadingState) {
            return const Center(
              child: CustomLoadingIndicator(),
            );
          } else if (state is ConsultationWaitingForAppointmentState) {
            return ConsultationWaitingAppointmentScreen(
              appointment: state.appointment,
            );
          } else if (state is ConsultationLoadedAppointmentState) {
            final chatRoom = state.chatRoomId;
            final doctorDetails = state.recipientUid;

            return ConsultationOnGoingAppointmentScreen(
              doctorUid: doctorDetails,
              chatroom: chatRoom,
              appointment: selectedDoctorAppointmentModel!,
            );
          }
          return const Center(
            child: CustomLoadingIndicator(),
          );
        },
      ),
    );
  }
}
