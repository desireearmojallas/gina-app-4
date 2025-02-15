import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/completed_state/bloc/completed_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/completed_state/screens/view_states/completed_request_details_screen_state.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/completed_state/screens/view_states/completed_request_state_screen_loaded.dart';

class CompletedRequestStateScreenProvider extends StatelessWidget {
  const CompletedRequestStateScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CompletedRequestStateBloc>(
      create: (context) {
        final completedRequestBloc = sl<CompletedRequestStateBloc>();
        completedRequestBloc.add(CompletedRequestStateInitialEvent());
        return completedRequestBloc;
      },
      child: const CompletedRequestStateScreen(),
    );
  }
}

class CompletedRequestStateScreen extends StatelessWidget {
  const CompletedRequestStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CompletedRequestStateBloc, CompletedRequestStateState>(
        listenWhen: (previous, current) =>
            current is CompletedRequestActionState,
        buildWhen: (previous, current) =>
            current is! CompletedRequestActionState,
        listener: (context, state) {
          if (state is NavigateToCompletedRequestDetailState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompletedRequestDetailsScreenState(
                  appointment: state.appointment,
                  patientData: state.patientData,
                  completedAppointments: state.completedAppointments,
                ),
              ),
            ).then((value) => context
                .read<CompletedRequestStateBloc>()
                .add(CompletedRequestStateInitialEvent()));
          }
        },
        builder: (context, state) {
          if (state is GetCompletedRequestSuccessState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: CompletedRequestStateScreenLoaded(
                completedRequests: state.completedRequests,
              ),
            );
          } else if (state is GetCompletedRequestFailedState) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else if (state is CompletedRequestLoadingState) {
            return const Center(child: CustomLoadingIndicator());
          }
          return Container();
        },
      ),
    );
  }
}
