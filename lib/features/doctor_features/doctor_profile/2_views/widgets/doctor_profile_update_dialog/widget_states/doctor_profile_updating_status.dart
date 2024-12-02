import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';

class DoctorProfileUpdatingStatus extends StatelessWidget {
  const DoctorProfileUpdatingStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 250,
        width: 250,
        padding: const EdgeInsets.all(15.0),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomLoadingIndicator(),
            Gap(30),
            Text(
              'Updating Profile...',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
