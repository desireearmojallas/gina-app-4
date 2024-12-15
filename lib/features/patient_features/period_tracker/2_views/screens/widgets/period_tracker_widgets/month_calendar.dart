// // ignore_for_file: library_private_types_in_public_api

// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:gina_app_4/core/theme/theme_service.dart';
// import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
// import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/widgets/period_tracker_widgets/custom_divider.dart';
// import 'package:table_calendar/table_calendar.dart';

// class MonthCalendar extends StatefulWidget {
//   final int year;
//   final int month;
//   final List<PeriodTrackerModel> periodTrackerModel;
//   final bool isEditMode;

//   const MonthCalendar({
//     super.key,
//     required this.year,
//     required this.month,
//     required this.periodTrackerModel,
//     required this.isEditMode,
//   });

//   @override
//   _MonthCalendarState createState() => _MonthCalendarState();
// }

// class _MonthCalendarState extends State<MonthCalendar> {
//   late List<DateTime> periodDates = [];
//   late List<DateTime> averageBasedPredictionDates = [];
//   late List<DateTime> day28PredictionDates = [];

//   @override
//   void initState() {
//     super.initState();
//     _extractDates();
//   }

//   void _extractDates() {
//     periodDates =
//         widget.periodTrackerModel.expand((p) => p.periodDates).toList();
//     averageBasedPredictionDates = widget.periodTrackerModel
//         .expand((p) => p.averageBasedPredictionDates)
//         .toList();
//     day28PredictionDates = widget.periodTrackerModel
//         .expand((p) => p.day28PredictionDates)
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return buildMonthCalendar(
//       widget.year,
//       widget.month,
//       periodDates,
//       averageBasedPredictionDates,
//       day28PredictionDates,
//       widget.isEditMode,
//     );
//   }

//   Widget buildMonthCalendar(
//     int year,
//     int month,
//     List<DateTime> periodDates,
//     List<DateTime> averageBasedPredictionDates,
//     List<DateTime> day28PredictionDates,
//     bool isEditMode,
//   ) {
//     DateTime firstDayOfMonth = DateTime(year, month, 1);

//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         vertical: 8.0,
//       ),
//       child: Column(
//         children: [
//           const Gap(10),
//           TableCalendar(
//             firstDay: firstDayOfMonth,
//             lastDay: DateTime(year, month + 1, 0),
//             focusedDay: firstDayOfMonth,
//             headerVisible: true,
//             headerStyle: const HeaderStyle(
//               formatButtonVisible: false,
//               leftChevronVisible: false,
//               rightChevronVisible: false,
//               titleCentered: true,
//               headerPadding: EdgeInsets.only(bottom: 30.0),
//               titleTextStyle: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             daysOfWeekVisible: false,
//             calendarFormat: CalendarFormat.month,
//             calendarBuilders: CalendarBuilders(
//               todayBuilder: (context, date, _) {
//                 bool isPeriodDate = periodDates.any((d) =>
//                     d.year == date.year &&
//                     d.month == date.month &&
//                     d.day == date.day);

//                 Widget child = Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       if (!isEditMode)
//                         const Text(
//                           'Today',
//                           style: TextStyle(
//                             color: GinaAppTheme.lightTertiaryContainer,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 10.0,
//                           ),
//                         )
//                       else
//                         const SizedBox.shrink(),
//                       Text(
//                         date.day.toString(),
//                         style: const TextStyle(
//                           color: GinaAppTheme.lightTertiaryContainer,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );

//                 if (isEditMode) {
//                   return InkWell(
//                     onTap: () {
//                       setState(() {
//                         if (isPeriodDate) {
//                           periodDates.removeWhere((d) =>
//                               d.year == date.year &&
//                               d.month == date.month &&
//                               d.day == date.day);
//                         } else {
//                           periodDates.add(date);
//                         }
//                       });
//                     },
//                     radius: 40,
//                     child: Column(
//                       children: [
//                         child,
//                         Container(
//                           margin: const EdgeInsets.only(top: 2.0),
//                           width: 20.0,
//                           height: 20.0,
//                           decoration: BoxDecoration(
//                             color: isPeriodDate
//                                 ? GinaAppTheme.lightTertiaryContainer
//                                 : Colors.transparent,
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: isPeriodDate
//                                   ? Colors.transparent
//                                   : Colors.grey,
//                               width: 2.0,
//                             ),
//                           ),
//                           child: isPeriodDate && !isEditMode
//                               ? const Icon(
//                                   Icons.check,
//                                   color: Colors.white,
//                                   size: 15,
//                                 )
//                               : const SizedBox.shrink(),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 return child;
//               },
//               defaultBuilder: (context, day, focusedDay) {
//                 Color? backgroundColor;
//                 bool isAverageBasedPredictionDate = false;
//                 bool is28DayPredictionDate = false;
//                 bool isPeriodDate = false;

//                 if (day28PredictionDates.any((date) =>
//                     date.year == day.year &&
//                     date.month == day.month &&
//                     date.day == day.day)) {
//                   is28DayPredictionDate = true;
//                 }

//                 if (averageBasedPredictionDates.any((date) =>
//                     date.year == day.year &&
//                     date.month == day.month &&
//                     date.day == day.day)) {
//                   isAverageBasedPredictionDate = true;
//                   backgroundColor =
//                       GinaAppTheme.lightPrimaryColor.withOpacity(0.5);
//                 }

//                 if (periodDates.any((date) =>
//                     date.year == day.year &&
//                     date.month == day.month &&
//                     date.day == day.day)) {
//                   backgroundColor = isEditMode
//                       ? Colors.transparent
//                       : GinaAppTheme.lightTertiaryContainer;
//                   isPeriodDate = true;
//                 }

//                 Widget child = Container(
//                   width: 35.0,
//                   decoration: BoxDecoration(
//                     color: backgroundColor,
//                     shape: BoxShape.circle,
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     day.day.toString(),
//                     style: TextStyle(
//                       color: isPeriodDate
//                           ? Colors.white
//                           : GinaAppTheme.lightOnPrimaryColor,
//                       fontWeight:
//                           isPeriodDate ? FontWeight.bold : FontWeight.normal,
//                     ),
//                   ),
//                 );

//                 if (isEditMode) {
//                   return InkWell(
//                     onTap: () {
//                       setState(() {
//                         if (isPeriodDate) {
//                           periodDates.removeWhere((date) =>
//                               date.year == day.year &&
//                               date.month == day.month &&
//                               date.day == day.day);
//                         } else {
//                           periodDates.add(day);
//                         }
//                       });
//                     },
//                     radius: 40,
//                     child: Column(
//                       children: [
//                         child,
//                         Container(
//                           margin: const EdgeInsets.only(top: 5.0),
//                           width: 20.0,
//                           height: 20.0,
//                           child: is28DayPredictionDate
//                               ? DottedBorder(
//                                   borderType: BorderType.Circle,
//                                   color: GinaAppTheme.lightTertiaryContainer,
//                                   dashPattern: const [4, 2],
//                                   strokeWidth: 2,
//                                   child: Container(
//                                     width: 20.0,
//                                     height: 20.0,
//                                     decoration: BoxDecoration(
//                                       color: isPeriodDate
//                                           ? GinaAppTheme.lightTertiaryContainer
//                                           : Colors.transparent,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: (isPeriodDate ||
//                                             isAverageBasedPredictionDate ||
//                                             is28DayPredictionDate)
//                                         ? Icon(
//                                             Icons.check,
//                                             color: isPeriodDate
//                                                 ? Colors.white
//                                                 : GinaAppTheme
//                                                     .lightTertiaryContainer,
//                                             size: 15,
//                                           )
//                                         : const SizedBox.shrink(),
//                                   ),
//                                 )
//                               : Container(
//                                   width: 20.0,
//                                   height: 20.0,
//                                   decoration: BoxDecoration(
//                                     color: isPeriodDate
//                                         ? GinaAppTheme.lightTertiaryContainer
//                                         : Colors.transparent,
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                       color: isPeriodDate
//                                           ? Colors.transparent
//                                           : isAverageBasedPredictionDate
//                                               ? GinaAppTheme.lightPrimaryColor
//                                               : Colors.grey,
//                                       width: 2,
//                                     ),
//                                   ),
//                                   child: (isPeriodDate ||
//                                           isAverageBasedPredictionDate ||
//                                           is28DayPredictionDate)
//                                       ? Icon(
//                                           Icons.check,
//                                           color: isPeriodDate
//                                               ? Colors.white
//                                               : GinaAppTheme.lightPrimaryColor,
//                                           size: 15,
//                                         )
//                                       : const SizedBox.shrink(),
//                                 ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 if (is28DayPredictionDate) {
//                   child = DottedBorder(
//                     borderType: BorderType.Circle,
//                     color: GinaAppTheme.lightTertiaryContainer,
//                     dashPattern: const [4, 2],
//                     child: Container(
//                       width: 30.0,
//                       height: 30.0,
//                       alignment: Alignment.center,
//                       child: child,
//                     ),
//                   );
//                 }

//                 return child;
//               },
//             ),
//           ),
//           const Gap(20),
//           if (month != 12) const CustomDivider(),
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: library_private_types_in_public_api

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/widgets/period_tracker_widgets/custom_divider.dart';
import 'package:table_calendar/table_calendar.dart';

class MonthCalendar extends StatefulWidget {
  final int year;
  final int month;
  final List<PeriodTrackerModel> periodTrackerModel;
  final bool isEditMode;

  const MonthCalendar({
    super.key,
    required this.year,
    required this.month,
    required this.periodTrackerModel,
    required this.isEditMode,
  });

  @override
  _MonthCalendarState createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  late List<DateTime> periodDates;
  late List<DateTime> averageBasedPredictionDates;
  late List<DateTime> day28PredictionDates;

  @override
  void initState() {
    super.initState();
    _generateDummyData();
  }

  void _generateDummyData() {
    periodDates = [
      DateTime(widget.year, widget.month, 3),
      DateTime(widget.year, widget.month, 4),
      DateTime(widget.year, widget.month, 5),
    ];
    averageBasedPredictionDates = [
      DateTime(widget.year, widget.month, 10),
      DateTime(widget.year, widget.month, 11),
      DateTime(widget.year, widget.month, 12),
    ];
    day28PredictionDates = [
      DateTime(widget.year, widget.month, 20),
      DateTime(widget.year, widget.month, 21),
      DateTime(widget.year, widget.month, 22),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return buildMonthCalendar(
      widget.year,
      widget.month,
      periodDates,
      averageBasedPredictionDates,
      day28PredictionDates,
      widget.isEditMode,
    );
  }

  Widget buildMonthCalendar(
    int year,
    int month,
    List<DateTime> periodDates,
    List<DateTime> averageBasedPredictionDates,
    List<DateTime> day28PredictionDates,
    bool isEditMode,
  ) {
    DateTime firstDayOfMonth = DateTime(year, month, 1);

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

                if (day28PredictionDates.any((date) =>
                    date.year == day.year &&
                    date.month == day.month &&
                    date.day == day.day)) {
                  is28DayPredictionDate = true;
                }

                if (averageBasedPredictionDates.any((date) =>
                    date.year == day.year &&
                    date.month == day.month &&
                    date.day == day.day)) {
                  isAverageBasedPredictionDate = true;
                  backgroundColor =
                      GinaAppTheme.lightPrimaryColor.withOpacity(0.5);
                }

                if (periodDates.any((date) =>
                    date.year == day.year &&
                    date.month == day.month &&
                    date.day == day.day)) {
                  backgroundColor = isEditMode
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
                    style: TextStyle(
                      color: isPeriodDate && !isEditMode
                          ? Colors.white
                          : GinaAppTheme.lightOnPrimaryColor,
                      fontWeight: isPeriodDate && !isEditMode
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );

                if (isEditMode) {
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
                          child: is28DayPredictionDate
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
                                          : isAverageBasedPredictionDate
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

                if (is28DayPredictionDate) {
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
