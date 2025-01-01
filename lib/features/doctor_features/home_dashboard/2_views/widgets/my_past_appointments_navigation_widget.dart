import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_upcoming_appointments/2_views/screens/view_states/completed_appointment_details_screen_state.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:icons_plus/icons_plus.dart';

class MyPastAppointmentsNavigationWidget extends StatelessWidget {
  final Map<DateTime, List<AppointmentModel>> completedAppointmentsList;
  final UserModel patientData;
  const MyPastAppointmentsNavigationWidget({
    super.key,
    required this.completedAppointmentsList,
    required this.patientData,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompletedAppointmentDetailScreenState(
              completedAppointmentsList: completedAppointmentsList,
              patientData: patientData,
            ),
          ),
        );
      },
      child: Container(
        height: size.height * 0.16,
        width: size.width / 2.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // gradient: LinearGradient(
          //   colors: GinaAppTheme.gradientColors,
          //   begin: Alignment.bottomLeft,
          //   end: Alignment.topRight,
          // ),
          color: Colors.white,
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // CircleAvatar(
                //   backgroundColor: GinaAppTheme.lightSecondary.withOpacity(1),
                //   radius: 40,
                // ),
                Image.asset(
                  Images.pastAppointmentsIcon,
                  width: 105,
                  height: 85,
                ),
              ],
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'My Past\nAppointments',
                  style: ginaTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: GinaAppTheme.lightOnPrimaryColor,
                  ),
                ),
                const Icon(
                  Bootstrap.arrow_right_circle_fill,
                  color: GinaAppTheme.lightSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
