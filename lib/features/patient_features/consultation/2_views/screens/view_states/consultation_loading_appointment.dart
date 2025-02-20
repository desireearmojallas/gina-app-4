import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';

class ConsultationLoadingAppointmentState extends StatelessWidget {
  const ConsultationLoadingAppointmentState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomLoadingIndicator(),
          Gap(8),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Loading Appointment...',
            ),
          ),
        ],
      ),
    );
  }
}
