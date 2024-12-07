import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/bloc/doctor_consultation_fee_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/view_states/doctor_consultation_fee_screen_loaded.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/view_states/edit_doctor_consultation_fee_screen_loaded.dart';

class DoctorConsultationFeeScreenProvider extends StatelessWidget {
  const DoctorConsultationFeeScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorConsultationFeeBloc>(
      create: (context) {
        final doctorProfileBloc = sl<DoctorConsultationFeeBloc>();
        doctorProfileBloc.add(GetDoctorConsultationFeeEvent());
        return doctorProfileBloc;
      },
      child: const DoctorConsultationFeeScreen(),
    );
  }
}

class DoctorConsultationFeeScreen extends StatelessWidget {
  const DoctorConsultationFeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorConsultationFeeBloc = context.read<DoctorConsultationFeeBloc>();

    return BlocBuilder<DoctorConsultationFeeBloc, DoctorConsultationFeeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: GinaDoctorAppBar(
            leading: state is NavigateToEditDoctorConsultationFeeState
                ? IconButton(
                    onPressed: () {
                      doctorConsultationFeeBloc
                          .add(GetDoctorConsultationFeeEvent());
                    },
                    icon: const Icon(Icons.arrow_back))
                : null,
            title: state is NavigateToEditDoctorConsultationFeeState
                ? 'Edit Consultation Fees'
                : 'Consultation Fees',
          ),
          body: BlocConsumer<DoctorConsultationFeeBloc,
              DoctorConsultationFeeState>(
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
          ),
        );
      },
    );
  }
}
