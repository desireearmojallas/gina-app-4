import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/bloc/appointment_details_bloc.dart';

class AppointmentDetailsScreenProvider extends StatelessWidget {
  const AppointmentDetailsScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppointmentDetailsBloc>(
      create: (context) {
        final appointmentDetailsBloc = sl<AppointmentDetailsBloc>();
        return appointmentDetailsBloc;
      },
      child: const AppointmentDetailsScreen(),
    );
  }
}

class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GinaPatientAppBar(
        title: 'Appointment Details',
      ),
      body: BlocConsumer<AppointmentDetailsBloc, AppointmentDetailsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Container();
        },
      ),
    );
  }
}
