import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/bloc/doctor_appointment_request_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/screens/view_states/doctor_appointment_request_screen_loaded.dart';

class DoctorAppointmentRequestProvider extends StatelessWidget {
  const DoctorAppointmentRequestProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DoctorAppointmentRequestBloc>()
        ..add(DoctorAppointmentRequestInitialEvent()), // Dispatch initial event
      child: const DoctorAppointmentRequestScreen(),
    );
  }
}

class DoctorAppointmentRequestScreen extends StatelessWidget {
  const DoctorAppointmentRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GinaDoctorAppBar(
        title: 'Appointment Requests',
      ),
      body: BlocConsumer<DoctorAppointmentRequestBloc,
          DoctorAppointmentRequestState>(
        listenWhen: (previous, current) =>
            current is DoctorAppointmentRequestActionState,
        buildWhen: (previous, current) =>
            current is! DoctorAppointmentRequestActionState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is DoctorAppointmentRequestInitial) {
            return const DoctorAppointmentRequestScreenLoaded();
          }
          return const DoctorAppointmentRequestScreenLoaded();
        },
      ),
    );
  }
}
