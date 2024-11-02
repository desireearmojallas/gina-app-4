import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/cancelled_state/screens/view_states/cancelled_request_details_screen_state.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';

class CancelledRequestStateScreenLoaded extends StatelessWidget {
  const CancelledRequestStateScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollbarCustom(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemBuilder: itemBuilder,
          itemCount: 20,
        ),
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CancelledRequestDetailsScreenState(),
          ),
        );
      },
      child: Container(
        height: size.height * 0.11,
        width: size.width / 1.05,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: GinaAppTheme.lightOnTertiary,
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CircleAvatar(
                radius: 37,
                backgroundImage: AssetImage(
                  Images.patientProfileIcon,
                ),
                backgroundColor: Colors.white,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Desiree Armojallas',
                  style: ginaTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(5),
                Text(
                  'Online Consultation'.toUpperCase(),
                  style: ginaTheme.textTheme.labelSmall?.copyWith(
                    color: GinaAppTheme.lightTertiaryContainer,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(5),
                Text(
                  'Tuesday, December 19\n8:00 AM - 9:00 AM',
                  style: ginaTheme.textTheme.labelMedium?.copyWith(
                    color: GinaAppTheme.lightOutline,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppointmentStatusContainer(
                    // todo: to change the status
                    appointmentStatus: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
