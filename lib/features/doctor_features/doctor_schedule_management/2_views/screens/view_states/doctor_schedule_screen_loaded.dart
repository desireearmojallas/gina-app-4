import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/doctor_details_state_widgets/detailed_view_icon.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/widgets/doctor_name_widget.dart';
import 'package:gina_app_4/features/doctor_features/doctor_schedule_management/0_models/doctor_schedule_management.dart';
import 'package:gina_app_4/features/doctor_features/doctor_schedule_management/2_views/bloc/doctor_schedule_management_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorScheduleScreenLoaded extends StatefulWidget {
  final ScheduleModel schedule;
  const DoctorScheduleScreenLoaded({super.key, required this.schedule});

  @override
  State<DoctorScheduleScreenLoaded> createState() =>
      _DoctorScheduleScreenLoadedState();
}

class _DoctorScheduleScreenLoadedState
    extends State<DoctorScheduleScreenLoaded> {
  int? selectedDay;

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
        Expanded(
          child: ScrollbarCustom(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
      children: [
        doctorNameWidget(size, ginaTheme, currentActiveDoctor!),
                  widget.schedule.days.isEmpty
            ? Center(
                child: Text(
                  'No schedule yet',
                  style: ginaTheme.bodySmall?.copyWith(
                    color: GinaAppTheme.lightOutline,
                  ),
                ),
              )
                      : Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  BlocBuilder<DoctorScheduleManagementBloc,
                                      DoctorScheduleManagementState>(
                                    builder: (context, state) {
                                      final bool isEditMode =
                                          state is EditScheduleState &&
                                              state.isEditing;

                                      if (isEditMode) {
                                        return DropdownButton<int>(
                                          value: selectedDay,
                                          hint: const Text('Select day'),
                                          items:
                                              widget.schedule.days.map((day) {
                                            return DropdownMenuItem<int>(
                                              value: day,
                                              child: Text(_getDayName(day)),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedDay = value;
                                            });
                                          },
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      final currentState = context
                                          .read<DoctorScheduleManagementBloc>()
                                          .state;
                                      final isCurrentlyEditing =
                                          currentState is EditScheduleState;

                                      context
                                          .read<DoctorScheduleManagementBloc>()
                                          .add(ToggleScheduleEditModeEvent(
                                              isEditing: !isCurrentlyEditing));

                                      if (isCurrentlyEditing) {
                                        setState(() {
                                          selectedDay = null;
                                        });
                                      }
                                    },
                                    icon: BlocBuilder<
                                        DoctorScheduleManagementBloc,
                                        DoctorScheduleManagementState>(
                                      builder: (context, state) {
                                        final bool isEditMode =
                                            state is EditScheduleState;
                                        return Icon(
                                          isEditMode
                                              ? Icons.edit_off_rounded
                                              : Icons.edit_rounded,
                                          color: isEditMode
                                              ? GinaAppTheme
                                                  .lightTertiaryContainer
                                              : GinaAppTheme.lightOutline,
                                          size: 20,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(10),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: IntrinsicHeight(
                child: Container(
                  width: size.width * 0.93,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 30, 20, 30),
                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                      children: [
                                        _buildOfficeDaysSection(
                                            size, valueStyle, labelStyle),
                                        divider(size.width * 0.9),
                                        _buildOfficeHoursSection(
                                            size, valueStyle, labelStyle),
                                        divider(size.width * 0.9),
                                        _buildModeOfAppointmentSection(
                                            size, valueStyle, labelStyle),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
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

  Widget _buildOfficeDaysSection(
      Size size, TextStyle valueStyle, TextStyle labelStyle) {
    return Padding(
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
            child: Text(
                                  'OFFICE DAYS',
                                  style: labelStyle,
                                ),
                              ),
                              const Gap(35),
                              BlocBuilder<DoctorScheduleManagementBloc,
                                  DoctorScheduleManagementState>(
                                builder: (context, state) {
              if (state is GetScheduleSuccessState ||
                  state is EditScheduleState) {
                final currentSchedule = state is GetScheduleSuccessState
                    ? state.schedule
                    : (state as EditScheduleState).schedule;

                                    Map<int, String> dayNames = {
                                      0: 'Sunday',
                                      1: 'Monday',
                                      2: 'Tuesday',
                                      3: 'Wednesday',
                                      4: 'Thursday',
                                      5: 'Friday',
                                      6: 'Saturday',
                                    };

                List<int> sortedDays = List.from(currentSchedule.days)..sort();

                                    List<List<int>> groupedDays = [];
                                    List<int> currentRange = [sortedDays.first];

                for (int i = 1; i < sortedDays.length; i++) {
                  if (sortedDays[i] == sortedDays[i - 1] + 1) {
                                        currentRange.add(sortedDays[i]);
                                      } else {
                                        groupedDays.add(currentRange);
                                        currentRange = [sortedDays[i]];
                                      }
                                    }

                                    groupedDays.add(currentRange);

                List<String> formattedRanges = groupedDays.map((range) {
                                      if (range.length > 1) {
                                        return '${dayNames[range.first]}-${dayNames[range.last]}';
                                      } else {
                                        return dayNames[range.first]!;
                                      }
                                    }).toList();

                String scheduleText = formattedRanges.join(', ');

                return Expanded(
                                        child: Text(
                                          scheduleText,
                                          style: valueStyle,
                                          overflow: TextOverflow.visible,
                                      ),
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
                            ],
                          ),
    );
  }

  Widget _buildOfficeHoursSection(
      Size size, TextStyle valueStyle, TextStyle labelStyle) {
    return Padding(
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
            child: Text(
                                  'OFFICE HOURS',
                                  style: labelStyle,
                                ),
                              ),
                              const Gap(35),
          BlocBuilder<DoctorScheduleManagementBloc,
              DoctorScheduleManagementState>(
            builder: (context, state) {
              if (state is GetScheduleSuccessState ||
                  state is EditScheduleState) {
                final currentSchedule = state is GetScheduleSuccessState
                    ? state.schedule
                    : (state as EditScheduleState).schedule;
                final bool isEditMode = state is EditScheduleState;

                return Expanded(
                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'MORNING',
                                    style: valueStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildTimeSlots(
                          context,
                          currentSchedule,
                          isEditMode,
                          true, // isMorning
                        ),
                                  ),
                                  const Gap(15),
                                  Text(
                                    'AFTERNOON',
                                    style: valueStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildTimeSlots(
                          context,
                          currentSchedule,
                          isEditMode,
                          false, // isMorning
                        ),
                      ),
                    ],
                  ),
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
                            ],
                          ),
    );
  }

  Widget _buildModeOfAppointmentSection(
      Size size, TextStyle valueStyle, TextStyle labelStyle) {
    return Padding(
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
            child: Text(
                                  'MODE OF\nAPPOINTMENT',
                                  style: labelStyle,
                                ),
                              ),
                              const Gap(35),
                              BlocBuilder<DoctorScheduleManagementBloc,
                                  DoctorScheduleManagementState>(
                                builder: (context, state) {
              if (state is GetScheduleSuccessState ||
                  state is EditScheduleState) {
                final currentSchedule = state is GetScheduleSuccessState
                    ? state.schedule
                    : (state as EditScheduleState).schedule;

                final modes = currentSchedule.modeOfAppointment;
                if (modes.contains(0) && modes.contains(1)) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                      Text('Online Consultation', style: valueStyle),
                      Text('Face-to-face Consultation', style: valueStyle),
                                        ],
                                      );
                                    } else if (modes.contains(0)) {
                  return Text('Online Consultation', style: valueStyle);
                                    } else if (modes.contains(1)) {
                  return Text('Face-to-face Consultation', style: valueStyle);
                                    } else {
                  return Text('No Consultation Mode Defined',
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
    );
  }

  List<Widget> _buildTimeSlots(
    BuildContext context,
    ScheduleModel schedule,
    bool isEditMode,
    bool isMorning,
  ) {
    final List<Widget> timeSlots = [];
    final Set<String> addedTimeSlots = {};

    for (var i = 0; i < schedule.startTimes.length; i++) {
      String timeStart = schedule.startTimes[i];
      String timeEnd = schedule.endTimes[i];

      // Filter morning/afternoon slots
      if ((isMorning && timeStart.contains('AM')) ||
          (!isMorning && timeStart.contains('PM'))) {
        if (isEditMode) {
          // Only show time slots for selected day in edit mode
          if (selectedDay != null) {
            final bool isDisabled =
                schedule.isSlotDisabled(selectedDay!, timeStart, timeEnd);

            timeSlots.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$timeStart - $timeEnd',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Switch(
                      value: !isDisabled, // Invert the value - ON means enabled
                      onChanged: (value) {
                        context.read<DoctorScheduleManagementBloc>().add(
                              ToggleTimeSlotEvent(
                                day: selectedDay!,
                                startTime: timeStart,
                                endTime: timeEnd,
                                disable:
                                    !value, // Invert the value - switching OFF means disable
                              ),
                            );
                      },
                      activeColor: GinaAppTheme.lightTertiaryContainer,
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          // In normal mode, show each time slot only once if it's not disabled
          String timeSlotKey = '$timeStart-$timeEnd';
          if (!addedTimeSlots.contains(timeSlotKey)) {
            bool isSlotDisabledForAllDays = schedule.days.every(
              (day) => schedule.isSlotDisabled(day, timeStart, timeEnd),
            );

            if (!isSlotDisabledForAllDays) {
              timeSlots.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    '$timeStart - $timeEnd',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black87,
                ),
              ),
            ),
              );
              addedTimeSlots.add(timeSlotKey);
            }
          }
        }
      }
    }

    if (isEditMode && selectedDay == null) {
      return [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
            'Please select a day to edit time slots',
            style: TextStyle(
              fontSize: 12.0,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ),
      ];
    }

    return timeSlots;
  }

  String _getDayName(int day) {
    switch (day) {
      case 0:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return 'Unknown';
    }
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
