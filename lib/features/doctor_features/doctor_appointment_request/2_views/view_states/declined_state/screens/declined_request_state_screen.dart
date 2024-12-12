import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/declined_state/bloc/declined_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/declined_state/screens/view_states/declined_request_details_screen_state.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/declined_state/screens/view_states/declined_request_state_screen_loaded.dart';

class DeclinedRequestStateScreenProvider extends StatelessWidget {
  const DeclinedRequestStateScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeclinedRequestStateBloc>(
      create: (context) {
        final declinedRequestBloc = sl<DeclinedRequestStateBloc>();
        declinedRequestBloc.add(DeclinedRequestStateInitialEvent());
        return declinedRequestBloc;
      },
      child: const DeclinedRequestStateScreen(),
    );
  }
}

class DeclinedRequestStateScreen extends StatelessWidget {
  const DeclinedRequestStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeclinedRequestStateBloc, DeclinedRequestStateState>(
      listenWhen: (previous, current) => current is DeclinedRequestActionState,
      buildWhen: (previous, current) => current is! DeclinedRequestActionState,
      listener: (context, state) {
        if (state is NavigateToDeclinedRequestDetailState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeclinedRequestDetailsScreenState(
                appointment: state.appointment,
                patient: state.patientData,
              ),
            ),
          ).then((value) => context.read<DeclinedRequestStateBloc>().add(
                DeclinedRequestStateInitialEvent(),
              ));
        }
      },
      builder: (context, state) {
        if (state is GetDeclinedRequestSuccessState) {
          return DeclinedRequestStateScreenLoaded(
            declinedRequests: state.declinedRequests,
          );
        } else if (state is GetDeclinedRequestFailedState) {
          return Center(child: Text(state.errorMessage));
        } else if (state is DeclinedRequestLoadingState) {
          return const Center(child: CustomLoadingIndicator());
        }
        return Container();
      },
    );
  }
}
