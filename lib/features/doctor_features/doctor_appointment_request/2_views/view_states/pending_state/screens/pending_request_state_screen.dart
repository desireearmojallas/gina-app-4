import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/bloc/pending_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/screens/view_states/pending_request_details_screen_state.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/screens/view_states/pending_request_state_screen_loaded.dart';

class PendingRequestStateScreenProvider extends StatelessWidget {
  const PendingRequestStateScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PendingRequestStateBloc>(
      create: (context) {
        final pendingRequestBloc = sl<PendingRequestStateBloc>();
        isFromPendingRequest = false;
        pendingRequestBloc.add(PendingRequestStateInitialEvent());
        return pendingRequestBloc;
      },
      child: const PendingRequestStateScreen(),
    );
  }
}

class PendingRequestStateScreen extends StatelessWidget {
  const PendingRequestStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PendingRequestStateBloc, PendingRequestStateState>(
        listenWhen: (previous, current) => current is PendingRequestActionState,
        buildWhen: (previous, current) => current is! PendingRequestActionState,
        listener: (context, state) {
          // Debugging: Print when the listener is triggered
          debugPrint('Listener triggered with state: $state');
          if (state is NavigateToPendingRequestDetailedState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PendingRequestDetailsScreenState(
                  appointment: state.appointment,
                  patientData: state.patientData,
                ),
              ),
            ).then((value) => context
                .read<PendingRequestStateBloc>()
                .add(PendingRequestStateInitialEvent()));
          }
        },
        builder: (context, state) {
          // Debugging: Print when the builder is triggered
          debugPrint('Builder triggered with state: $state');
          if (state is GetPendingRequestSuccessState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: PendingRequestStateScreenLoaded(
                pendingRequests: state.pendingRequests,
              ),
            );
          } else if (state is GetPendingRequestFailedState) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else if (state is PendingRequestLoadingState) {
            return const Center(child: CustomLoadingIndicator());
          }
          return Container();
        },
      ),
    );
  }
}
