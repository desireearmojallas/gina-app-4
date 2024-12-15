import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/screens/view_states/doctor_econsult_screen_loaded.dart';

class DoctorEConsultScreenProvider extends StatelessWidget {
  const DoctorEConsultScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorEconsultBloc>(
      create: (context) {
        final doctorEConsultBloc = sl<DoctorEconsultBloc>();
        isFromChatRoomLists = false;
        doctorEConsultBloc.add(GetRequestedEConsultsDiplayEvent());
        return doctorEConsultBloc;
      },
      child: const DoctorEConsultScreen(),
    );
  }
}

class DoctorEConsultScreen extends StatelessWidget {
  const DoctorEConsultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<DoctorEconsultBloc, DoctorEConsultState>(
        listenWhen: (previous, current) => true,
        buildWhen: (previous, current) => true,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is DoctorEConsultLoadedState) {
            return DoctorEConsultScreenLoaded(
              upcomingAppointments: state.upcomingAppointments,
              chatRooms: state.chatRooms,
            );
          } else if (state is DoctorEConsultErrorState) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is DoctorEConsultLoadingState) {
            return const Center(
              child: CustomLoadingIndicator(),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
