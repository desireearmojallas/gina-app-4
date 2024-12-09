import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/consultation_fee_details/2_views/bloc/consultation_fee_details_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation_fee_details/2_views/screens/view_states/consultation_fee_details_initial_screen.dart';

class ConsultationFeeDetailsScreenProvider extends StatelessWidget {
  const ConsultationFeeDetailsScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConsultationFeeDetailsBloc>(
      create: (context) {
        final consultationFeeDetailsBloc = sl<ConsultationFeeDetailsBloc>();

        return consultationFeeDetailsBloc;
      },
      child: const ConsultationFeeDetailsScreen(),
    );
  }
}

class ConsultationFeeDetailsScreen extends StatelessWidget {
  const ConsultationFeeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GinaPatientAppBar(
        title: 'Consultation Fee Details',
      ),
      body: const ConsultationFeeDetailsInitialScreen(),
    );
  }
}
