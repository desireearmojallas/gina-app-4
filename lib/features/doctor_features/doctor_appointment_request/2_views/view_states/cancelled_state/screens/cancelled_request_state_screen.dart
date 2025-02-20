import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/cancelled_state/bloc/cancelled_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/cancelled_state/screens/view_states/cancelled_request_details_screen_state.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/cancelled_state/screens/view_states/cancelled_request_state_screen_loaded.dart';

class CancelledRequestStateScreenProvider extends StatelessWidget {
  const CancelledRequestStateScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CancelledRequestStateBloc>(
      create: (context) {
        final cancelledRequestBloc = sl<CancelledRequestStateBloc>();
        cancelledRequestBloc.add(CancelledRequestStateInitialEvent());
        return cancelledRequestBloc;
      },
      child: const CancelledRequestStateScreen(),
    );
  }
}

class CancelledRequestStateScreen extends StatelessWidget {
  const CancelledRequestStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CancelledRequestStateBloc, CancelledRequestStateState>(
        listenWhen: (previous, current) =>
            current is CancelledRequestActionState,
        buildWhen: (previous, current) =>
            current is! CancelledRequestActionState,
        listener: (context, state) {
          if (state is NavigateToCancelledRequestDetailState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CancelledRequestDetailsScreenState(
                  appointment: state.appointment,
                  patient: state.patientData,
                ),
              ),
            ).then((value) => context
                .read<CancelledRequestStateBloc>()
                .add(CancelledRequestStateInitialEvent()));
          }
        },
        builder: (context, state) {
          if (state is GetCancelledRequestSuccessState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: CancelledRequestStateScreenLoaded(
                cancelledRequests: state.cancelledRequests,
              ),
            );
          } else if (state is GetCancelledRequestFailedState) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else if (state is CancelledRequestLoadingState) {
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
