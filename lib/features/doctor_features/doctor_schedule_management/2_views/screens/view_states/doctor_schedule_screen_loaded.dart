import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/doctor_details_state_widgets/detailed_view_icon.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/widgets/doctor_name_widget.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorScheduleScreenLoaded extends StatelessWidget {
  const DoctorScheduleScreenLoaded({super.key});

  final sampleChecker = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    const valueStyle = TextStyle(
      fontSize: 12.0,
    );

    const labelStyle = TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
    );
    return Column(
      children: [
        doctorNameWidget(size, ginaTheme),
        const Gap(10),
        sampleChecker
            ? Center(
                child: Text(
                  'No schedule yet',
                  style: ginaTheme.bodySmall?.copyWith(
                    color: GinaAppTheme.lightOutline,
                  ),
                ),
              )
            : IntrinsicHeight(
                child: Container(
                  width: size.width * 0.93,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              const DetailedViewIcon(
                                icon: Icon(
                                  Icons.calendar_today_rounded,
                                  color: GinaAppTheme.lightOutline,
                                  size: 20,
                                ),
                              ),
                              const Gap(20),
                              SizedBox(
                                width: size.width * 0.21,
                                child: const Text(
                                  'OFFICE DAYS',
                                  style: labelStyle,
                                ),
                              ),
                              const Gap(35),
                              const Text(
                                'Monday - Friday',
                                style: valueStyle,
                              ),
                            ],
                          ),
                        ),
                        divider(size.width * 0.9),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              const DetailedViewIcon(
                                icon: Icon(
                                  MingCute.time_fill,
                                  color: GinaAppTheme.lightOutline,
                                  size: 20,
                                ),
                              ),
                              const Gap(20),
                              SizedBox(
                                width: size.width * 0.21,
                                child: const Text(
                                  'OFFICE HOURS',
                                  style: labelStyle,
                                ),
                              ),
                              const Gap(35),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'MORNING',
                                    style: valueStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    '8:00 AM - 12:00 PM',
                                    style: valueStyle,
                                  ),
                                  const Gap(15),
                                  Text(
                                    'AFTERNOON',
                                    style: valueStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    '3:00 PM - 5:00 PM',
                                    style: valueStyle,
                                  ),
                                  const Text(
                                    '6:00 PM - 7:00 PM',
                                    style: valueStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        divider(size.width * 0.9),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              const DetailedViewIcon(
                                icon: Icon(
                                  Icons.assignment_ind,
                                  color: GinaAppTheme.lightOutline,
                                  size: 20,
                                ),
                              ),
                              const Gap(20),
                              SizedBox(
                                width: size.width * 0.21,
                                child: const Text(
                                  'MODE OF\nAPPOINTMENT',
                                  style: labelStyle,
                                ),
                              ),
                              const Gap(35),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Online Consultation',
                                    style: valueStyle,
                                  ),
                                  Text(
                                    'Face-to-face Consultation',
                                    style: valueStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        const Spacer(),
        Container(
          height: size.height * 0.06,
          width: size.width * 0.9,
          margin: const EdgeInsets.only(bottom: 30),
          child: FilledButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () {
              //TODO: Will apply bloc event here. Temporary route only for edit consultation fees
              Navigator.pushNamed(context, '/doctorCreateSchedule');
            },
            child: Text(
              'Manage schedule',
              style: ginaTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget divider(width) {
    return Column(
      children: [
        const Gap(10),
        SizedBox(
          width: width,
          child: const Divider(
            color: GinaAppTheme.lightOutline,
            thickness: 0.3,
          ),
        ),
        const Gap(10),
      ],
    );
  }
}
