import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class AppointmentStatusCard extends StatelessWidget {
  final int appointmentStatus;
  const AppointmentStatusCard({
    super.key,
    required this.appointmentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    AppointmentStatus status = AppointmentStatus.values[appointmentStatus];
    String buttonText;
    Color buttonColor;
    String statusText;

    switch (status) {
      case AppointmentStatus.pending:
        buttonText = 'Pending';
        buttonColor = const Color(0xffFF9839);
        statusText = 'Your appointment is waiting for approval.';
        break;
      case AppointmentStatus.confirmed:
        buttonText = 'Approved';
        buttonColor = const Color(0xff33D176);
        statusText = 'Your appointment has been approved.';
        break;
      case AppointmentStatus.completed:
        buttonText = 'Completed';
        buttonColor = GinaAppTheme.lightSecondary;
        statusText = 'Your appointment is finished.';
        break;
      case AppointmentStatus.cancelled:
        buttonText = 'Cancelled';
        buttonColor = GinaAppTheme.lightOutline;
        statusText = 'You cancelled your appointment.';
        break;
      case AppointmentStatus.declined:
        buttonText = 'Declined';
        buttonColor = const Color(0xffD14633);
        statusText = 'Your appointment has been declined.';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      width: size.width * 0.93,
      height: size.height * 0.09,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  'Status',
                  style: ginaTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: GinaAppTheme.lightOutline,
                  ),
                ),
                const Gap(10),
                SizedBox(
                  height: 17,
                  width: 70,
                  child: FilledButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(buttonColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.symmetric(
                        horizontal: 8,
                      )),
                    ),
                    onPressed: () {},
                    child: Text(
                      buttonText,
                      style: ginaTheme.labelSmall?.copyWith(
                        color: GinaAppTheme.lightOnTertiary,
                      ),
                    ),
                  ),
                ),
                const Gap(20),
              ],
            ),
            const Gap(10),
            Text(
              statusText,
              style: ginaTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
