import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/doctor_details_state_widgets/detailed_view_icon.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/widgets/doctor_name_widget.dart';
import 'package:gina_app_4/features/doctor_features/doctor_schedule_management/0_models/doctor_schedule_management.dart';
import 'package:gina_app_4/features/doctor_features/doctor_schedule_management/2_views/bloc/doctor_schedule_management_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorScheduleScreenLoaded extends StatelessWidget {
  final ScheduleModel schedule;
  const DoctorScheduleScreenLoaded({super.key, required this.schedule});

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
        schedule.days.isEmpty
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
                              BlocBuilder<DoctorScheduleManagementBloc,
                                  DoctorScheduleManagementState>(
                                builder: (context, state) {
                                  if (state is GetScheduleSuccessState) {
                                    Map<int, String> dayNames = {
                                      0: 'Sunday',
                                      1: 'Monday',
                                      2: 'Tuesday',
                                      3: 'Wednesday',
                                      4: 'Thursday',
                                      5: 'Friday',
                                      6: 'Saturday',
                                    };

                                    List<int> sortedDays =
                                        List.from(state.schedule.days)..sort();

                                    List<List<int>> groupedDays = [];
                                    List<int> currentRange = [sortedDays.first];

                                    for (int i = 1;
                                        i < sortedDays.length;
                                        i++) {
                                      if (sortedDays[i] ==
                                          sortedDays[i - 1] + 1) {
                                        currentRange.add(sortedDays[i]);
                                      } else {
                                        groupedDays.add(currentRange);
                                        currentRange = [sortedDays[i]];
                                      }
                                    }

                                    groupedDays.add(currentRange);

                                    List<String> formattedRanges =
                                        groupedDays.map((range) {
                                      if (range.length > 1) {
                                        return '${dayNames[range.first]}-${dayNames[range.last]}';
                                      } else {
                                        return dayNames[range.first]!;
                                      }
                                    }).toList();

                                    String scheduleText =
                                        formattedRanges.join(', ');

                                    return SizedBox(
                                      width: size.width * 0.3,
                                      child: Flexible(
                                        child: Text(
                                          scheduleText,
                                          style: valueStyle,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    );
                                  }

                                  if (state is GetScheduledFailedState) {
                                    return Text(
                                      'Schedule fetch faileddd: ${state.message}',
                                      style: valueStyle.copyWith(
                                        color: Colors.red,
                                      ),
                                    );
                                  }

                                  return const CustomLoadingIndicator();
                                },
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
                                  // const Text(
                                  //   '8:00 AM - 12:00 PM',
                                  //   style: valueStyle,
                                  // ),
                                  BlocBuilder<DoctorScheduleManagementBloc,
                                      DoctorScheduleManagementState>(
                                    builder: (context, state) {
                                      if (state is GetScheduleSuccessState) {
                                        List<Widget> timeSlots = [];
                                        for (var i = 0;
                                            i <
                                                state
                                                    .schedule.startTimes.length;
                                            i++) {
                                          String timeStart =
                                              state.schedule.startTimes[i];
                                          String timeEnd =
                                              state.schedule.endTimes[i];
                                          if (timeStart.contains('AM')) {
                                            timeSlots.add(Text(
                                              '$timeStart - $timeEnd',
                                              style: valueStyle,
                                            ));
                                          }
                                        }
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: timeSlots,
                                        );
                                      }
                                      if (state is GetScheduledFailedState) {
                                        return Text(
                                          'Schedule fetch failed: ${state.message}',
                                          style: valueStyle.copyWith(
                                            color: Colors.red,
                                          ),
                                        );
                                      }
                                      return const CustomLoadingIndicator();
                                    },
                                  ),
                                  const Gap(15),
                                  Text(
                                    'AFTERNOON',
                                    style: valueStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  BlocBuilder<DoctorScheduleManagementBloc,
                                      DoctorScheduleManagementState>(
                                    builder: (context, state) {
                                      if (state is GetScheduleSuccessState) {
                                        List<Widget> timeSlots = [];
                                        for (var i = 0;
                                            i <
                                                state
                                                    .schedule.startTimes.length;
                                            i++) {
                                          String timeStart =
                                              state.schedule.startTimes[i];
                                          String timeEnd =
                                              state.schedule.endTimes[i];
                                          if (timeStart.contains('PM')) {
                                            timeSlots.add(Text(
                                              '$timeStart - $timeEnd',
                                              style: valueStyle,
                                            ));
                                          }
                                        }
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: timeSlots,
                                        );
                                      }
                                      if (state is GetScheduledFailedState) {
                                        return Text(
                                          'Schedule fetch failed: ${state.message}',
                                          style: valueStyle.copyWith(
                                            color: Colors.red,
                                          ),
                                        );
                                      }
                                      return const CustomLoadingIndicator();
                                    },
                                  )
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
                              BlocBuilder<DoctorScheduleManagementBloc,
                                  DoctorScheduleManagementState>(
                                builder: (context, state) {
                                  if (state is GetScheduleSuccessState) {
                                    final modes =
                                        state.schedule.modeOfAppointment;
                                    if (modes.contains(0) &&
                                        modes.contains(1)) {
                                      return const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Online Consultation',
                                              style: valueStyle),
                                          Text('Face-to-face Consultation',
                                              style: valueStyle),
                                        ],
                                      );
                                    } else if (modes.contains(0)) {
                                      return const Text('Online Consultation',
                                          style: valueStyle);
                                    } else if (modes.contains(1)) {
                                      return const Text(
                                          'Face-to-face Consultation',
                                          style: valueStyle);
                                    } else {
                                      return const Text(
                                          'No Consultation Mode Defined',
                                          style: valueStyle);
                                    }
                                  }
                                  if (state is GetScheduledFailedState) {
                                    return Text(
                                      'Schedule fetch failed: ${state.message}',
                                      style: valueStyle.copyWith(
                                        color: Colors.red,
                                      ),
                                    );
                                  }
                                  return const CustomLoadingIndicator();
                                },
                              )
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
