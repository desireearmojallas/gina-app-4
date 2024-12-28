import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';

class ConsultationNoAppointmentScreen extends StatelessWidget {
  const ConsultationNoAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Center(child: Image.asset(Images.consultationNoAppointment)),
        Center(
          child: Text('No appointment'),
        ),
        Gap(150),
      ],
    );
  }
}
