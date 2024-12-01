import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/bloc/admin_patient_list_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/screens/view_states/admin_patient_details_state.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/screens/view_states/admin_patient_list_loaded_state.dart';

class AdminPatientListScreenProvider extends StatelessWidget {
  const AdminPatientListScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminPatientListBloc>(
      create: (context) {
        final adminPatientListBloc = sl<AdminPatientListBloc>();
        adminPatientListBloc.add(AdminPatientListGetRequestedEvent());
        return adminPatientListBloc;
      },
      child: const AdminPatientListScreen(),
    );
  }
}

class AdminPatientListScreen extends StatelessWidget {
  const AdminPatientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AdminPatientListBloc, AdminPatientListState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AdminPatientListLoadingState) {
            return const Center(
              child: CustomLoadingIndicator(),
            );
          }
          if (state is AdminPatientListLoadedState) {
            return AdminPatientListLoaded(
              patientList: state.patients,
            );
          } else if (state is AdminPatientListErrorState) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is AdminPatientListPatientDetailsState) {
            return AdminPatientDetailsState(
              patientDetails: state.patientDetails,
              appointmentDetails: state.appointmentDetails,
            );
          }
          return Container();
        },
      ),
    );
  }
}
