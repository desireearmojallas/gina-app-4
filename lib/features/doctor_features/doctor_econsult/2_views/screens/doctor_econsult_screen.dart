import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
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

        doctorEConsultBloc.add(GetRequestedEconsultsDisplayEvent());

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
      appBar: GinaDoctorAppBar(
        title: 'E-Consult',
      ),
      body: BlocConsumer<DoctorEconsultBloc, DoctorEconsultState>(
        listenWhen: (previous, current) => true,
        buildWhen: (previous, current) => true,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is DoctorEconsultLoadedState) {
            return DoctorEConsultScreenLoaded(
              upcomingAppointments: state.upcomingAppointments,
              chatRooms: state.chatRooms,
            );
          } else if (state is DoctorEconsultErrorState) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else if (state is DoctorEconsultLoadingState) {
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
