import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_list/2_views/bloc/admin_doctor_list_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_list/2_views/screens/view_states/admin_doctor_details_state.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_list/2_views/screens/view_states/admin_doctor_loaded_state.dart';

class AdminDoctorListScreenProvider extends StatelessWidget {
  const AdminDoctorListScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminDoctorListBloc>(
      create: (context) {
        final adminDoctorListBloc = sl<AdminDoctorListBloc>();
        adminDoctorListBloc.add(AdminDoctorListGetRequestEvent());
        return adminDoctorListBloc;
      },
      child: const AdminDoctorListScreen(),
    );
  }
}

class AdminDoctorListScreen extends StatelessWidget {
  const AdminDoctorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AdminDoctorListBloc, AdminDoctorListState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is AdminDoctorListLoadingState) {
          return const Center(
            child: CustomLoadingIndicator(),
          );
        } else if (state is AdminDoctorListLoadedState) {
          return AdminDoctorListLoaded(
            approvedDoctorList: state.approvedDoctorList,
          );
        } else if (state is AdminDoctorListErrorState) {
          return Center(
            child: Text(state.message),
          );
        } else if (state is AdminDoctorListDoctorDetailsState) {
          return AdminDoctorDetailsState(
            approvedDoctorDetails: state.approvedDoctorDetails,
            doctorVerification: state.doctorVerification,
            appointments: state.appointmentDetails,
          );
        }
        return Container();
      },
    ));
  }
}
