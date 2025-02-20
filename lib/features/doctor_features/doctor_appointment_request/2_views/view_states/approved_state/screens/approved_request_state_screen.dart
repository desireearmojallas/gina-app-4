import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/approved_state/bloc/approved_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/approved_state/screens/view_states/approved_request_details_screen_state.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/approved_state/screens/view_states/approved_request_state_screen_loaded.dart';

class ApprovedRequestStateScreenProvider extends StatelessWidget {
  const ApprovedRequestStateScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApprovedRequestStateBloc>(
      create: (context) {
        final approvedRequestBloc = sl<ApprovedRequestStateBloc>();
        approvedRequestBloc.add(ApprovedRequestStateInitialEvent());
        return approvedRequestBloc;
      },
      child: const ApprovedRequestStateScreen(),
    );
  }
}

class ApprovedRequestStateScreen extends StatelessWidget {
  const ApprovedRequestStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ApprovedRequestStateBloc, ApprovedRequestStateState>(
        listenWhen: (previous, current) =>
            current is ApprovedRequestActionState,
        buildWhen: (previous, current) =>
            current is! ApprovedRequestActionState,
        listener: (context, state) {
          if (state is NavigateToApprovedRequestDetailState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApprovedRequestDetailsScreenState(
                  appointment: state.appointment,
                  patientData: state.patientData,
                  completedAppointments: state.completedAppointments,
                ),
              ),
            ).then((value) => context
                .read<ApprovedRequestStateBloc>()
                .add(ApprovedRequestStateInitialEvent()));
          }
        },
        builder: (context, state) {
          if (state is GetApprovedRequestSuccessState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: ApprovedRequestStateScreenLoaded(
                approvedRequests: state.approvedRequests,
              ),
            );
          } else if (state is GetApprovedRequestFailedState) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else if (state is ApprovedRequestLoadingState) {
            return const Center(child: CustomLoadingIndicator());
          }
          return Container();
        },
      ),
    );
  }
}
