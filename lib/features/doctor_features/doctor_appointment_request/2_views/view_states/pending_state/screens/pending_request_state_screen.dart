import 'package:flutter/material.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/screens/view_states/pending_request_state_screen_loaded.dart';

class PendingRequestStateScreenProvider extends StatelessWidget {
  const PendingRequestStateScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return const PendingRequestStateScreen();
  }
}

class PendingRequestStateScreen extends StatelessWidget {
  const PendingRequestStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PendingRequestStateScreenLoaded();
  }
}
