import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ConsultationNoAppointmentScreen extends StatelessWidget {
  const ConsultationNoAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text('No appointment found')),
        Gap(150),
      ],
    );
  }
}
