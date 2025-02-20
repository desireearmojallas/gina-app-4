import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/missed_state/bloc/missed_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/missed_state/screens/view_states/missed_request_details_screen_state.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/missed_state/screens/view_states/missed_request_state_screen_loaded.dart';

class MissedRequestStateScreenProvider extends StatelessWidget {
  const MissedRequestStateScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MissedRequestStateBloc>(
      create: (context) {
        final missedRequestBloc = sl<MissedRequestStateBloc>();
        missedRequestBloc.add(MissedRequestStateInitialEvent());
        return missedRequestBloc;
      },
      child: const MissedRequestStateScreen(),
    );
  }
}

class MissedRequestStateScreen extends StatelessWidget {
  const MissedRequestStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //! continue here....
    return Scaffold(
      body: BlocConsumer<MissedRequestStateBloc, MissedRequestStateState>(
        listenWhen: (previous, current) => current is MissedRequestActionState,
        buildWhen: (previous, current) => current is! MissedRequestActionState,
        listener: (context, state) {
          if (state is NavigateToMissedRequestDetailState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MissedRequestDetailsScreenState(
                  appointment: state.appointment,
                  patientData: state.patientData,
                ),
              ),
            ).then((value) => context
                .read<MissedRequestStateBloc>()
                .add(MissedRequestStateInitialEvent()));
          }
        },
        builder: (context, state) {
          if (state is GetMissedRequestSuccessState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: MissedRequestStateScreenLoaded(
                missedRequests: state.missedRequests,
              ),
            );
          } else if (state is GetMissedRequestFailedState) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else if (state is MissedRequestLoadingState) {
            return const CustomLoadingIndicator();
          }
          return Container();
        },
      ),
    );
  }
}
