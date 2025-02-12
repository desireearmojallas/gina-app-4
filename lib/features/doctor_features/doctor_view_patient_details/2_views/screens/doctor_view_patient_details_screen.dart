import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patient_details/2_views/bloc/doctor_view_patient_details_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patient_details/2_views/screens/view_states/doctor_view_patient_details_screen_loaded.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patients/2_views/bloc/doctor_view_patients_bloc.dart';

class DoctorViewPatientDetailsScreenProvider extends StatelessWidget {
  const DoctorViewPatientDetailsScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorViewPatientDetailsBloc>(
      create: (context) {
        final patientDetailsBloc = sl<DoctorViewPatientDetailsBloc>();

        patientDetailsBloc.add(DoctorViewPatientDetailsFetchRequestedEvent());
        return patientDetailsBloc;
      },
      child: const DoctorViewPatientDetailsScreen(),
    );
  }
}

class DoctorViewPatientDetailsScreen extends StatelessWidget {
  const DoctorViewPatientDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GinaDoctorAppBar(title: 'Patient Details'),
      body: BlocConsumer<DoctorViewPatientDetailsBloc,
          DoctorViewPatientDetailsState>(
        listenWhen: (previous, current) =>
            current is DoctorViewPatientDetailsActionState,
        buildWhen: (previous, current) =>
            current is! DoctorViewPatientDetailsActionState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is DoctorViewPatientDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DoctorViewPatientDetailsInitial) {
            return DoctorViewPatientDetailsScreenLoaded(
              //TODO: edit this later
              // patient: patient!,
              completedAppointments: patientAppointments!,
              // patientPeriods: patientPeriods!,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
