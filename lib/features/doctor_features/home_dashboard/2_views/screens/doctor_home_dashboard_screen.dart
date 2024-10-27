import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/floating_doctor_menu_bar/floating_doctor_menu_bar.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/gina_header.dart';

class DoctorHomeScreenDashboardProvider extends StatelessWidget {
  const DoctorHomeScreenDashboardProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return const DoctorHomeScreenDashboard();
  }
}

class DoctorHomeScreenDashboard extends StatelessWidget {
  const DoctorHomeScreenDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GinaHeader(
          size: 45,
          isDoctor: true,
        ),
        actions: [
          FloatingDoctorMenuWidget(
            hasNotification: true,
          ),
          const Gap(10),
        ],
        surfaceTintColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.1),
      ),
    );
  }
}
