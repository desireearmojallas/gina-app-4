import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_schedule_management/2_views/bloc/doctor_schedule_management_bloc.dart';

class DoctorScheduleManagementScreenProvider extends StatelessWidget {
  const DoctorScheduleManagementScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorScheduleManagementBloc>(
      create: (context) => sl<DoctorScheduleManagementBloc>(),
      child: const DoctorScheduleManagementScreen(),
    );
  }
}

class DoctorScheduleManagementScreen extends StatelessWidget {
  const DoctorScheduleManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
