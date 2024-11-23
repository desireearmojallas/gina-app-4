import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/screens/view_states/doctor_consultation_on_going_appointment_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/widgets/doctor_consultation_menu.dart';

class DoctorConsultationScreenProvider extends StatelessWidget {
  const DoctorConsultationScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorConsultationBloc>(
      create: (context) => sl<DoctorConsultationBloc>(),
      child: const DoctorConsultationScreen(),
    );
  }
}

class DoctorConsultationScreen extends StatelessWidget {
  const DoctorConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //! Chat view with patient's name. different appbar for the patient information. to be changed with bloc implementation
      appBar: AppBar(
        title: Text(
          'Desiree Armojallas',
        ),
        actions: [
          DoctorConsultationMenu(),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: const DoctorConsultationOnGoingAppointmentScreen(),
    );
  }
}
