import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/declined_state/bloc/declined_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/declined_state/screens/view_states/declined_request_state_screen_loaded.dart';

class DeclinedRequestStateScreenProvider extends StatelessWidget {
  const DeclinedRequestStateScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeclinedRequestStateBloc>(
      create: (context) => sl<DeclinedRequestStateBloc>(),
      child: const DeclinedRequestStateScreen(),
    );
  }
}

class DeclinedRequestStateScreen extends StatelessWidget {
  const DeclinedRequestStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeclinedRequestStateBloc, DeclinedRequestStateState>(
      listener: (context, state) {},
      builder: (context, state) {
        return const DeclinedRequestStateScreenLoaded();
      },
    );
  }
}
