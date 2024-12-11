import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/patient_features/consultation_fee_details/2_views/bloc/consultation_fee_details_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation_fee_details/2_views/screens/view_states/consultation_fee_details_initial_screen.dart';
import 'package:gina_app_4/features/patient_features/consultation_fee_details/2_views/screens/view_states/consultation_fee_no_pricing_screen.dart';

class ConsultationFeeDetailsScreenProvider extends StatelessWidget {
  const ConsultationFeeDetailsScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConsultationFeeDetailsBloc>(
      create: (context) {
        final consultationFeeDetailsBloc = sl<ConsultationFeeDetailsBloc>();

        consultationFeeDetailsBloc.add(ToggleConsultationFeePricingEvent());

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
    final DoctorModel doctor =
        ModalRoute.of(context)?.settings.arguments as DoctorModel;
    return Scaffold(
      appBar: GinaPatientAppBar(
        title: 'Consultation Fee Details',
      ),
      body:
          BlocConsumer<ConsultationFeeDetailsBloc, ConsultationFeeDetailsState>(
        listenWhen: (previous, current) =>
            current is ConsultationFeeDetailsActionState,
        buildWhen: (previous, current) =>
            current is! ConsultationFeeDetailsActionState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ConsultationFeeDetailsInitial) {
            return ConsultationFeeDetailsInitialScreen(
              doctor: doctor,
              isPricingShown: state.isPricingShown,
            );
          } else if (state is ConsultationFeeNoPricingState) {
            return ConsultationFeeNoPricingScreen(
              doctor: doctor,
            );
          }
          return Container();
        },
      ),
    );
  }
}
