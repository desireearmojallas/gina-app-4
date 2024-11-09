import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/approved_state/bloc/approved_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/approved_state/screens/view_states/approved_request_state_screen_loaded.dart';

class ApprovedRequestStateScreenProvider extends StatelessWidget {
  const ApprovedRequestStateScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApprovedRequestStateBloc>(
      create: (context) => sl<ApprovedRequestStateBloc>(),
      child: const ApprovedRequestStateScreen(),
    );
  }
}

class ApprovedRequestStateScreen extends StatelessWidget {
  const ApprovedRequestStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApprovedRequestStateBloc, ApprovedRequestStateState>(
      listener: (context, state) {},
      builder: (context, state) {
        return const ApprovedRequestStateScreenLoaded();
      },
    );
  }
}
