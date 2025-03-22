import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/2_views/bloc/patient_payment_bloc.dart';

class PatientPaymentScreenProvider extends StatelessWidget {
  const PatientPaymentScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatientPaymentBloc>(
      create: (context) {
        final patientPaymentBloc = sl<PatientPaymentBloc>();

        return patientPaymentBloc;
      },
      child: const PatientPaymentScreen(),
    );
  }
}

class PatientPaymentScreen extends StatelessWidget {
  const PatientPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GinaPatientAppBar(
        title: 'Payment',
      ),
      body: Container(),
    );
  }
}
