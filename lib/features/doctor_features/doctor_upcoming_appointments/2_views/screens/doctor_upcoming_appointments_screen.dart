import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_upcoming_appointments/2_views/bloc/doctor_upcoming_appointments_bloc.dart';

class DoctorUpcomingAppointmentScreenProvider extends StatelessWidget {
  const DoctorUpcomingAppointmentScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorUpcomingAppointmentsBloc>(
      create: (context) {
        final doctorUpcomingAppointmentsBloc =
            sl<DoctorUpcomingAppointmentsBloc>();

        isFromChatRoomLists = false;
        doctorUpcomingAppointmentsBloc
            .add(const UpcomingAppointmentsFilterEvent(isSelected: true));

        return doctorUpcomingAppointmentsBloc;
      },
      child: const DoctorUpcomingAppointmentsScreen(),
    );
  }
}

class DoctorUpcomingAppointmentsScreen extends StatelessWidget {
  const DoctorUpcomingAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
