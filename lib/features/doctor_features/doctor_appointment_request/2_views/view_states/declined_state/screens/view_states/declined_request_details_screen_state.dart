import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';

class DeclinedRequestDetailsScreenState extends StatelessWidget {
  const DeclinedRequestDetailsScreenState({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);

    final labelStyle = ginaTheme.textTheme.bodySmall?.copyWith(
      color: GinaAppTheme.lightOutline,
    );
    final textStyle = ginaTheme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );

    final divider = Column(
      children: [
        const Gap(5),
        SizedBox(
          width: size.width / 1.15,
          child: const Divider(
            thickness: 0.5,
            color: GinaAppTheme.lightSurfaceVariant,
          ),
        ),
        const Gap(25),
      ],
    );

    return Scaffold(
      appBar: GinaDoctorAppBar(
        title: 'Appointment Request',
      ),
      body: Stack(
        children: [
          const GradientBackground(),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                height: size.height * 0.82,
                width: size.width / 1.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: GinaAppTheme.lightOnTertiary,
                  boxShadow: [
                    GinaAppTheme.defaultBoxShadow,
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 30, 15, 20),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                              Images.patientProfileIcon,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: size.width * 0.5,
                              child: Text(
                                'Desiree Armojallas',
                                style: ginaTheme.textTheme.titleSmall?.copyWith(
                                  color: GinaAppTheme.lightOnBackground,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.5,
                              child: Text(
                                'Appointment ID: 123456',
                                style: ginaTheme.textTheme.labelSmall?.copyWith(
                                  color: GinaAppTheme.lightOutline,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        //const Spacer(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppointmentStatusContainer(
                                // todo: to change the status
                                appointmentStatus: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Birth date',
                                style: labelStyle,
                              ),
                              const Gap(10),
                              Text(
                                '',
                                style: textStyle,
                              ),
                            ],
                          ),
                          const Gap(130),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gender',
                                style: labelStyle,
                              ),
                              const Gap(10),
                              Text(
                                '',
                                style: textStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    divider,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address',
                              style: labelStyle,
                            ),
                            const Gap(10),
                            Text(
                              '',
                              style: textStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    divider,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contact number',
                              style: labelStyle,
                            ),
                            const Gap(10),
                            Text(
                              '',
                              style: textStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    divider,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email address',
                              style: labelStyle,
                            ),
                            const Gap(10),
                            Text(
                              '',
                              style: textStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    divider,
                    Container(
                      height: size.height * 0.08,
                      width: size.width / 1.12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: GinaAppTheme.lightSurfaceVariant,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Online Consultation'.toUpperCase(),
                            style: ginaTheme.textTheme.labelSmall?.copyWith(
                              color: GinaAppTheme.lightTertiaryContainer,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(5),
                          Text(
                            'Tuesday, December 19 | 8:00 AM - 9:00 AM',
                            style: ginaTheme.textTheme.labelMedium?.copyWith(
                              color: GinaAppTheme.lightOutline,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    TextButton(
                      onPressed: null,
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View Patient Data',
                            style: TextStyle(
                              fontSize: 11,
                              color: GinaAppTheme.lightSurfaceVariant,
                            ),
                          ),
                          Gap(10),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: GinaAppTheme.lightSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'You have declined this appointment request.',
                      style: TextStyle(
                        color: GinaAppTheme.lightOutline,
                        fontSize: 11,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
                      child: Container(
                        height: size.height * 0.06,
                        width: size.width / 1.15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: GinaAppTheme.declinedTextColor,
                        ),
                        child: Center(
                          child: Text(
                            'Declined',
                            style: ginaTheme.textTheme.labelLarge?.copyWith(
                              color: GinaAppTheme.lightBackground,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
