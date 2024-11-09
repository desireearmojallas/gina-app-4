import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/cancelled_state/bloc/cancelled_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/cancelled_state/screens/view_states/cancelled_request_state_screen_loaded.dart';

class CancelledRequestStateScreenProvider extends StatelessWidget {
  const CancelledRequestStateScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CancelledRequestStateBloc>(
      create: (context) => sl<CancelledRequestStateBloc>(),
      child: const CancelledRequestStateScreen(),
    );
  }
}

class CancelledRequestStateScreen extends StatelessWidget {
  const CancelledRequestStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CancelledRequestStateBloc, CancelledRequestStateState>(
      listener: (context, state) {},
      builder: (context, state) {
        return const CancelledRequestStateScreenLoaded();
      },
    );
  }
}
