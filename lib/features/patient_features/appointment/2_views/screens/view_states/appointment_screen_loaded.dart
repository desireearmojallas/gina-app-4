import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';

class AppointmentScreenLoaded extends StatelessWidget {
  const AppointmentScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Appointment Screen Loaded'),
            Gap(20),
            CustomLoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
