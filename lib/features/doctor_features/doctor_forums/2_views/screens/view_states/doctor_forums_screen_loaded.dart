import 'package:flutter/material.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';

class DoctorForumsScreenLoaded extends StatelessWidget {
  const DoctorForumsScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GinaDoctorAppBar(
        title: 'Forums',
      ),
    );
  }
}
