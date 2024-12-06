// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/create_doctor_schedule/2_views/bloc/create_doctor_schedule_bloc.dart';
import 'package:gina_app_4/features/doctor_features/create_doctor_schedule/2_views/screens/widgets/generate_timeslots_widget.dart';

class DoctorCreateScheduleScreenLoaded extends StatelessWidget {
  List<String> startTimes = [];
  List<String> endTimes = [];
  List<int> selectedDays = [];
  List<int> selectedMode = [];
  DoctorCreateScheduleScreenLoaded({
    super.key,
    required this.startTimes,
    required this.endTimes,
    required this.selectedDays,
    required this.selectedMode,
  });

  @override
  Widget build(BuildContext context) {
    final scheduleBloc = context.read<CreateDoctorScheduleBloc>();
    final ginaTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    final headingStyle = ginaTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: GinaAppTheme.lightSecondary,
    );

    final subheadingStyle = ginaTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w600,
      color: GinaAppTheme.lightOutline,
    );

    final space = Column(
      children: [
        const Gap(10),
        Divider(
          color: Colors.grey.withOpacity(0.5),
          thickness: 1.0,
        ),
        const Gap(10),
      ],
    );

    final morningTimeSlots = generateTimeSlots(context, 6, 12, false);
    final afternoonTimeSlots = generateTimeSlots(context, 1, 10, true);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your office days',
            style: headingStyle,
          ),
          const Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List<Widget>.generate(7, (index) {
              final daysOfTheWeek = [
                'Sun',
                'Mon',
                'Tue',
                'Wed',
                'Thu',
                'Fri',
                'Sat',
              ];
              final isSelected = ValueNotifier<bool>(false);

              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: ValueListenableBuilder<bool>(
                  valueListenable: isSelected,
                  builder: (_, selected, __) {
                    if (selectedDays.contains(index)) {
                      selected = true;
                    }
                    debugPrint('$selectedDays');
                    return GestureDetector(
                      onTap: () {
                        isSelected.value = !isSelected.value;
                        if (selectedDays.isEmpty) {
                          selectedDays = <int>[];
                          if (isSelected.value == true) {
                            selectedDays.add(index);
                          } else {
                            selectedDays.remove(index);
                          }
                        } else {
                          if (isSelected.value == true) {
                            selectedDays.add(index);
                          } else {
                            selectedDays.remove(index);
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? GinaAppTheme.lightTertiaryContainer
                              : Colors.transparent,
                          border: Border.all(
                            color: selected
                                ? Colors.transparent
                                : Colors.grey.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: SizedBox(
                          width: 25,
                          child: Center(
                            child: Text(
                              daysOfTheWeek[index],
                              style: ginaTheme.bodyMedium?.copyWith(
                                color: selected
                                    ? GinaAppTheme.appbarColorLight
                                    : GinaAppTheme.lightOnPrimaryColor,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
          space,
          Text(
            'Select your office hours',
            style: headingStyle,
          ),
          const Gap(10),
          Text(
            'Morning',
            style: subheadingStyle,
          ),
          Column(
            children: List<Widget>.generate(
              (morningTimeSlots.length / 3).ceil(),
              (rowIndex) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List<Widget>.generate(
                  3,
                  (columnIndex) {
                    final index = rowIndex * 3 + columnIndex;
                    if (index < morningTimeSlots.length) {
                      final isSelected = ValueNotifier<bool>(false);

                      return Expanded(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: isSelected,
                          builder: (_, selected, __) {
                            return SizedBox(
                              width: size.width * 0.309,
                              child: GestureDetector(
                                onTap: () {
                                  isSelected.value = !isSelected.value;

                                  String morningTimeSlot =
                                      morningTimeSlots[index];

                                  List<String> times =
                                      morningTimeSlot.split(' - ');

                                  String startTime = times[0];
                                  String endTime = times[1];

                                  if (startTimes.isEmpty) {
                                    startTimes = <String>[];
                                  }
                                  if (endTimes.isEmpty) {
                                    endTimes = <String>[];
                                  }

                                  if (isSelected.value == true) {
                                    if (startTime.contains('AM')) {
                                      debugPrint(
                                          'Start time: $startTime\nEnd time: $endTime');
                                      startTimes.add(startTime);
                                      endTimes.add(endTime);
                                    }
                                  } else {
                                    startTimes.remove(startTime);
                                    endTimes.remove(endTime);
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 5.5,
                                    vertical: 9.0,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14.0,
                                    horizontal: 2.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? GinaAppTheme.lightTertiaryContainer
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: selected
                                          ? Colors.transparent
                                          : Colors.grey.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      morningTimeSlots[index],
                                      textAlign: TextAlign.center,
                                      style: ginaTheme.bodyMedium?.copyWith(
                                        color: selected
                                            ? GinaAppTheme.appbarColorLight
                                            : GinaAppTheme.lightOnPrimaryColor,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
          ),
          const Gap(10),
          Text(
            'Afternoon',
            style: subheadingStyle,
          ),
          const Gap(10),
          Column(
            children: List<Widget>.generate(
              (afternoonTimeSlots.length / 3).ceil(),
              (rowIndex) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List<Widget>.generate(
                  3,
                  (columnIndex) {
                    final index = rowIndex * 3 + columnIndex;
                    if (index < afternoonTimeSlots.length) {
                      final isSelected = ValueNotifier<bool>(false);

                      return Expanded(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: isSelected,
                          builder: (_, selected, __) {
                            return SizedBox(
                              width: size.width * 0.309,
                              child: GestureDetector(
                                onTap: () {
                                  isSelected.value = !isSelected.value;

                                  String afternoonTimeSlot =
                                      afternoonTimeSlots[index];

                                  List<String> times =
                                      afternoonTimeSlot.split(' - ');

                                  String startTime = times[0];
                                  String endTime = times[1];

                                  if (startTimes.isEmpty) {
                                    startTimes = <String>[];
                                  }
                                  if (endTimes.isEmpty) {
                                    endTimes = <String>[];
                                  }

                                  if (isSelected.value == true) {
                                    if (startTime.contains('PM')) {
                                      debugPrint(
                                          'Start time: $startTime\nEnd time: $endTime');
                                      startTimes.add(startTime);
                                      endTimes.add(endTime);
                                    }
                                  } else {
                                    startTimes.remove(startTime);
                                    endTimes.remove(endTime);
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 5.5,
                                    vertical: 9.0,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14.0,
                                    horizontal: 2.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? GinaAppTheme.lightTertiaryContainer
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: selected
                                          ? Colors.transparent
                                          : Colors.grey.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      afternoonTimeSlots[index],
                                      textAlign: TextAlign.center,
                                      style: ginaTheme.bodyMedium?.copyWith(
                                        color: selected
                                            ? GinaAppTheme.appbarColorLight
                                            : GinaAppTheme.lightOnPrimaryColor,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
          ),
          space,
          Text(
            'Mode of appointment',
            style: headingStyle,
          ),
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List<Widget>.generate(
              2,
              (index) {
                final modes = [
                  'Online consultation',
                  'Face-to-face consultation',
                ];
                final isSelected = ValueNotifier<bool>(false);

                return ValueListenableBuilder<bool>(
                  valueListenable: isSelected,
                  builder: (_, selected, __) {
                    return GestureDetector(
                      onTap: () {
                        isSelected.value = !isSelected.value;
                        if (selectedMode.isEmpty) {
                          selectedMode = <int>[];
                          if (isSelected.value == true) {
                            selectedMode.add(index);
                          } else {
                            selectedMode.remove(index);
                          }
                        } else {
                          if (isSelected.value == true) {
                            selectedMode.add(index);
                          } else {
                            selectedMode.remove(index);
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 14.0,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? GinaAppTheme.lightTertiaryContainer
                              : Colors.transparent,
                          border: Border.all(
                            color: selected
                                ? Colors.transparent
                                : Colors.grey.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: SizedBox(
                          width: size.width * 0.340,
                          child: Center(
                            child: Text(
                              modes[index],
                              style: ginaTheme.bodyMedium?.copyWith(
                                color: selected
                                    ? GinaAppTheme.appbarColorLight
                                    : GinaAppTheme.lightOnPrimaryColor,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
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
                if (selectedDays.isEmpty &&
                    startTimes.isEmpty &&
                    endTimes.isEmpty &&
                    selectedMode.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Choose office days, office hours, and mode of appointment.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (selectedDays.isEmpty &&
                    (startTimes.isNotEmpty || endTimes.isNotEmpty) &&
                    (selectedMode.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text('Choose office days, and mode of appointment.'),
                    backgroundColor: Colors.red,
                  ));
                } else if (selectedDays.isNotEmpty &&
                    (startTimes.isEmpty || endTimes.isEmpty) &&
                    (selectedMode.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text('Choose office hours, and mode of appointment.'),
                    backgroundColor: Colors.red,
                  ));
                } else if (selectedDays.isEmpty &&
                    (startTimes.isEmpty || endTimes.isEmpty) &&
                    (selectedMode.isNotEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Choose office days, and office hours.'),
                    backgroundColor: Colors.red,
                  ));
                } else if (selectedMode.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Choose mode of appointment.'),
                    backgroundColor: Colors.red,
                  ));
                } else if (selectedDays.isEmpty && selectedMode.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Choose office days.'),
                    backgroundColor: Colors.red,
                  ));
                } else if ((startTimes.isEmpty || endTimes.isEmpty) &&
                    selectedMode.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Choose office hours.'),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  scheduleBloc.add(
                    SaveScheduleEvent(
                      selectedDays: selectedDays,
                      endTimes: endTimes,
                      startTimes: startTimes,
                      appointmentMode: selectedMode,
                    ),
                  );

                  debugPrint(
                    'Selected days: $selectedDays\nStart times:$startTimes\nEnd times: $endTimes\nAppointment mode: $selectedMode',
                  );

                  debugPrint('Start Times: $startTimes');
                  debugPrint('End Times: $endTimes');

                  // Navigator.pushReplacementNamed(context, '/doctorSchedule');
                  isFromCreateDoctorSchedule = true;

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Schedule created successfully.'),
                  ));
                }
              },
              child: Text(
                'Save schedule',
                style: ginaTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
