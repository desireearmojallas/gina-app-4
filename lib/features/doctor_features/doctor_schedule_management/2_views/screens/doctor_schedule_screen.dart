import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/create_doctor_schedule/2_views/bloc/create_doctor_schedule_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_schedule_management/2_views/bloc/doctor_schedule_management_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_schedule_management/2_views/screens/view_states/doctor_schedule_screen_loaded.dart';

class DoctorScheduleManagementScreenProvider extends StatelessWidget {
  const DoctorScheduleManagementScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorScheduleManagementBloc>(
      create: (context) {
        final scheduleBloc = sl<DoctorScheduleManagementBloc>();
        scheduleBloc.add(DoctorScheduleManagementInitialEvent());
        return scheduleBloc;
      },
      // create: (context) => sl<DoctorScheduleManagementBloc>()
      //   ..add(DoctorScheduleManagementInitialEvent()),
      child: const DoctorScheduleManagementScreen(),
    );
  }
}

class DoctorScheduleManagementScreen extends StatelessWidget {
  const DoctorScheduleManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GinaDoctorAppBar(
        leading: isFromCreateDoctorSchedule
            ? IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, '/doctorBottomNavigation');
                  isFromCreateDoctorSchedule = false;
                },
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: 'Schedule Management',
      ),
      body: BlocConsumer<DoctorScheduleManagementBloc,
          DoctorScheduleManagementState>(
        listenWhen: (previous, current) =>
            current is DoctorScheduleManagementActionState,
        buildWhen: (previous, current) =>
            current is! DoctorScheduleManagementActionState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetScheduleSuccessState) {
            return DoctorScheduleScreenLoaded(
              schedule: state.schedule,
            );
          } else if (state is GetScheduledFailedState) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is GetScheduleLoadingState) {
            return const Center(
              child: CustomLoadingIndicator(),
            );
          }
          return Container();
        },
      ),
    );
  }
}
