import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_payment_feature/2_views/bloc/doctor_payment_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_payment_feature/2_views/screens/doctor_xendit_activation_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_payment_feature/2_views/screens/view_states/doctor_payment_screen_initial.dart';

class DoctorPaymentFeatureProvider extends StatelessWidget {
  const DoctorPaymentFeatureProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorPaymentBloc>(
      create: (context) {
        final doctorPaymentFeatureBloc = sl<DoctorPaymentBloc>();

        return doctorPaymentFeatureBloc;
      },
      child: const DoctorPaymentFeature(),
    );
  }
}

class DoctorPaymentFeature extends StatelessWidget {
  const DoctorPaymentFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GinaDoctorAppBar(title: 'My Payment Account'),
        body: BlocConsumer<DoctorPaymentBloc, DoctorPaymentState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            // return const DoctorPaymentScreenInitial();

            return const DoctorXenditActivationScreen();
          },
        ));
  }
}
