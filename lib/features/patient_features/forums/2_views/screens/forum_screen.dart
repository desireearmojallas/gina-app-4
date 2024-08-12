import 'package:flutter/material.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/screens/view_states/forum_screen_loaded.dart';

class ForumScreenProvider extends StatelessWidget {
  const ForumScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return const ForumScreen();
  }
}

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GinaPatientAppBar(
        title: 'Forums',
      ),
      body: const ForumScreenLoaded(),
    );
  }
}
