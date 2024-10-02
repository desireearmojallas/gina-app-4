// ignore_for_file: library_private_types_in_public_api

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/widgets/period_tracker_widgets/custom_divider.dart';
import 'package:table_calendar/table_calendar.dart';

class MonthCalendar extends StatefulWidget {
  final int year;
  final int month;
  final List<DateTime> periodDates;
  final bool isEditMode;

  const MonthCalendar({
    super.key,
    required this.year,
    required this.month,
    required this.periodDates,
    required this.isEditMode, required Null Function(dynamic newDates) onPeriodDatesChanged,
  });

  @override
  _MonthCalendarState createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  @override
  Widget build(BuildContext context) {
    return buildMonthCalendar(
      widget.year,
      widget.month,
      widget.periodDates,
      widget.isEditMode,
    );
  }

  Widget buildMonthCalendar(
      int year, int month, List<DateTime> periodDates, bool isEditMode) {
    DateTime firstDayOfMonth = DateTime(year, month, 1);

    // Sample predicted dates for demonstration
    List<DateTime> averageBasedPredictionDates = [
      DateTime(year, month, 5),
      DateTime(year, month, 6),
      DateTime(year, month, 7),
    ];

    List<DateTime> day28PredictionDates = [
      DateTime(year, month, 15),
      DateTime(year, month, 16),
      DateTime(year, month, 17),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Column(
        children: [
          const Gap(10),
          TableCalendar(
            firstDay: firstDayOfMonth,
            lastDay: DateTime(year, month + 1, 0),
            focusedDay: firstDayOfMonth,
            headerVisible: true,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              leftChevronVisible: false,
              rightChevronVisible: false,
              titleCentered: true,
              headerPadding: EdgeInsets.only(bottom: 30.0),
              titleTextStyle: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            daysOfWeekVisible: false,
            calendarFormat: CalendarFormat.month,
            calendarBuilders: CalendarBuilders(
              todayBuilder: (context, date, _) {
                bool isPeriodDate = periodDates.any((d) =>
                    d.year == date.year &&
                    d.month == date.month &&
                    d.day == date.day);

                Widget child = Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isEditMode)
                        const Text(
                          'Today',
                          style: TextStyle(
                            color: GinaAppTheme.lightTertiaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      Text(
                        date.day.toString(),
                        style: const TextStyle(
                          color: GinaAppTheme.lightTertiaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                );

                if (isEditMode) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isPeriodDate) {
                          periodDates.removeWhere((d) =>
                              d.year == date.year &&
                              d.month == date.month &&
                              d.day == date.day);
                        } else {
                          periodDates.add(date);
                        }
                      });
                    },
                    radius: 40,
                    child: Column(
                      children: [
                        child,
                        Container(
                          margin: const EdgeInsets.only(top: 2.0),
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: isPeriodDate
                                ? GinaAppTheme.lightTertiaryContainer
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isPeriodDate
                                  ? Colors.transparent
                                  : Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          child: isPeriodDate
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 15,
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  );
                }

                return child;
              },
              defaultBuilder: (context, day, focusedDay) {
                Color? backgroundColor;
                bool isAverageBasedPredictionDate = false;
                bool is28DayPredictionDate = false;
                bool isPeriodDate = false;

                if (averageBasedPredictionDates.any((date) =>
                    date.year == day.year &&
                    date.month == day.month &&
                    date.day == day.day)) {
                  isAverageBasedPredictionDate = true;
                }

                if (day28PredictionDates.any((date) =>
                    date.year == day.year &&
                    date.month == day.month &&
                    date.day == day.day)) {
                  is28DayPredictionDate = true;
                  backgroundColor =
                      GinaAppTheme.lightPrimaryColor.withOpacity(0.5);
                }

                if (widget.periodDates.any((date) =>
                    date.year == day.year &&
                    date.month == day.month &&
                    date.day == day.day)) {
                  backgroundColor = widget.isEditMode
                      ? Colors.transparent
                      : GinaAppTheme.lightTertiaryContainer;
                  isPeriodDate = true;
                }

                Widget child = Container(
                  width: 35.0,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    day.day.toString(),
                    style: const TextStyle(
                      color: GinaAppTheme.lightOnPrimaryColor,
                    ),
                  ),
                );

                if (widget.isEditMode) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isPeriodDate) {
                          periodDates.removeWhere((date) =>
                              date.year == day.year &&
                              date.month == day.month &&
                              date.day == day.day);
                        } else {
                          periodDates.add(day);
                        }
                      });
                    },
                    radius: 40,
                    child: Column(
                      children: [
                        child,
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          width: 20.0,
                          height: 20.0,
                          child: isAverageBasedPredictionDate
                              ? DottedBorder(
                                  borderType: BorderType.Circle,
                                  color: GinaAppTheme.lightTertiaryContainer,
                                  dashPattern: const [4, 2],
                                  strokeWidth: 2,
                                  child: Container(
                                    width: 20.0,
                                    height: 20.0,
                                    decoration: BoxDecoration(
                                      color: isPeriodDate
                                          ? GinaAppTheme.lightTertiaryContainer
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: (isPeriodDate ||
                                            isAverageBasedPredictionDate ||
                                            is28DayPredictionDate)
                                        ? Icon(
                                            Icons.check,
                                            color: isPeriodDate
                                                ? Colors.white
                                                : GinaAppTheme
                                                    .lightTertiaryContainer,
                                            size: 15,
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                )
                              : Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    color: isPeriodDate
                                        ? GinaAppTheme.lightTertiaryContainer
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isPeriodDate
                                          ? Colors.transparent
                                          : is28DayPredictionDate
                                              ? GinaAppTheme.lightPrimaryColor
                                              : Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                  child: (isPeriodDate ||
                                          isAverageBasedPredictionDate ||
                                          is28DayPredictionDate)
                                      ? Icon(
                                          Icons.check,
                                          color: isPeriodDate
                                              ? Colors.white
                                              : GinaAppTheme.lightPrimaryColor,
                                          size: 15,
                                        )
                                      : const SizedBox.shrink(),
                                ),
                        ),
                      ],
                    ),
                  );
                }

                if (isAverageBasedPredictionDate) {
                  child = DottedBorder(
                    borderType: BorderType.Circle,
                    color: GinaAppTheme.lightTertiaryContainer,
                    dashPattern: const [4, 2],
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      alignment: Alignment.center,
                      child: child,
                    ),
                  );
                }

                return child;
              },
            ),
          ),
          const Gap(20),
          if (month != 12) const CustomDivider(),
        ],
      ),
    );
  }
}
