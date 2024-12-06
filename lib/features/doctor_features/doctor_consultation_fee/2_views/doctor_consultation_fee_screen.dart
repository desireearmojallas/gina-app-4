import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/bloc/doctor_consultation_fee_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/view_states/doctor_consultation_fee_screen_loaded.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/view_states/edit_doctor_consultation_fee_screen_loaded.dart';

class DoctorConsultationFeeScreenProvider extends StatelessWidget {
  const DoctorConsultationFeeScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorConsultationFeeBloc>(
      create: (context) => sl<DoctorConsultationFeeBloc>(),
      child: const DoctorConsultationFeeScreen(),
    );
  }
}

class DoctorConsultationFeeScreen extends StatelessWidget {
  const DoctorConsultationFeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Consultation fees'),
        ),
        body:
            BlocConsumer<DoctorConsultationFeeBloc, DoctorConsultationFeeState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is DoctorConsultationFeeLoadingState) {
              return const Center(child: CustomLoadingIndicator());
            } else if (state is DoctorConsultationFeeLoadedState) {
              final doctorData = state.doctor;
              return DoctorConsultationFeeScreenLoaded(
                doctorData: doctorData,
              );
            } else if (state is DoctorConsultationFeeErrorState) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else if (state is NavigateToEditDoctorConsultationFeeState) {
              return EditDoctorConsultationFeeScreenLoaded(
                doctorData: state.doctorData,
              );
            }
            return Container();
          },
        ));
  }
}
