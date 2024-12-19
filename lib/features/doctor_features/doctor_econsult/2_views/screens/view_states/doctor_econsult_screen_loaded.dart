import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/widgets/chat_econsult_card_list.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/widgets/upcoming_appointments_navigation_widget.dart';

class DoctorEConsultScreenLoaded extends StatelessWidget {
  const DoctorEConsultScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: GinaDoctorAppBar(
        title: 'E-Consult',
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Upcoming Appointments'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // TODO: View all upcoming appointments and make it slidable like the patient side
              //! will work on the upcoming appointments slideable widget
              const UpcomingAppointmentsNavigationWidget(),
              const Gap(20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Consultation History'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Gap(10),
              const ChatEConsultCardList(),
            ],
          ),
        ),
      ),
    );
  }
}
