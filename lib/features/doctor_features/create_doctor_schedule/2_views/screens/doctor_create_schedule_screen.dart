import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/create_doctor_schedule/2_views/bloc/create_doctor_schedule_bloc.dart';
import 'package:gina_app_4/features/doctor_features/create_doctor_schedule/2_views/screens/view_states/doctor_create_schedule_screen_loaded.dart';

class DoctorCreateScheduleScreenProvider extends StatelessWidget {
  const DoctorCreateScheduleScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateDoctorScheduleBloc>(
      create: (context) {
        final scheduleBloc = sl<CreateDoctorScheduleBloc>();
        scheduleBloc.add(CreateDoctorScheduleInitialEvent());
        return scheduleBloc;
      },
      child: const DoctorCreateScheduleScreen(),
    );
  }
}

class DoctorCreateScheduleScreen extends StatelessWidget {
  const DoctorCreateScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GinaDoctorAppBar(
          title: 'Manage Schedule',
        ),
        backgroundColor: Colors.white,
        body: BlocConsumer<CreateDoctorScheduleBloc, CreateDoctorScheduleState>(
          listenWhen: (previous, current) =>
              current is CreateDoctorScheduleActionEvent,
          buildWhen: (previous, current) =>
              current is! CreateDoctorScheduleActionEvent,
          listener: (context, state) {},
          builder: (context, state) {
            if (state is CreateDoctorScheduleInitial) {
              return DoctorCreateScheduleScreenLoaded(
                startTimes: const [],
                endTimes: const [],
                selectedDays: const [],
                selectedMode: const [],
              );
            }
            return DoctorCreateScheduleScreenLoaded(
              startTimes: const [],
              endTimes: const [],
              selectedDays: const [],
              selectedMode: const [],
            );
          },
        ));
  }
}
