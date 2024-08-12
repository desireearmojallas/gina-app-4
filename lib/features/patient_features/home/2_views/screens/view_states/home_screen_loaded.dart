import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/widgets/book_appointment_container.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/widgets/consultation_history_container.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/widgets/forums_container.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/widgets/home_calendar_tracker_container.dart';

class HomeScreenLoaded extends StatelessWidget {
  const HomeScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HomeCalendarTrackerContainer(),
            Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BookAppointmentContainer(),
                Gap(10),
                ForumsContainer(),
              ],
            ),
            Gap(10),
            ConsultationHistoryContainer(),
          ],
        ),
      ),
    );
  }
}
