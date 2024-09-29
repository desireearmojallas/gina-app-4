// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:gina_app_4/core/theme/theme_service.dart';

class YearlyCalendarWidget extends StatefulWidget {
  final bool isEditMode;
  const YearlyCalendarWidget({
    super.key,
    this.isEditMode = false,
  });

  @override
  State<YearlyCalendarWidget> createState() => _YearlyCalendarWidgetState();
}

class _YearlyCalendarWidgetState extends State<YearlyCalendarWidget> {
  int selectedYear = DateTime.now().year;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Scroll to the current month
      _scrollToCurrentMonth();
    });
  }

  void _scrollToCurrentMonth() {
    final currentMonth = DateTime.now().month;
    const itemHeight = 380.0;
    const monthNameHeight = 10.0;
    final scrollPosition = (currentMonth - 1) * (itemHeight + monthNameHeight);
    _scrollController.jumpTo(scrollPosition);
  }

  final divider = Column(
    children: [
      const Gap(10),
      Divider(
        color: Colors.grey[300] ?? Colors.grey,
        thickness: 1,
      ),
      const Gap(10),
    ],
  );

  Widget buildMonthCalendar(int year, int month) {
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

    // Sample period dates for demonstration
    List<DateTime> periodDates = [
      DateTime(year, month, 10),
      DateTime(year, month, 11),
      DateTime(year, month, 12),
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
                      if (widget.isEditMode == false)
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

                if (widget.isEditMode) {
                  return GestureDetector(
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
                              width: 1.0,
                            ),
                          ),
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
                  backgroundColor =
                      GinaAppTheme.lightPrimaryColor.withOpacity(0.5);
                }

                if (periodDates.any((date) =>
                    date.year == day.year &&
                    date.month == day.month &&
                    date.day == day.day)) {
                  backgroundColor = GinaAppTheme.lightTertiaryContainer;
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
                      color: isPeriodDate
                          ? Colors.white
                          : GinaAppTheme.lightOnPrimaryColor,
                    ),
                  ),
                );

                if (widget.isEditMode) {
                  return GestureDetector(
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
                    child: Column(
                      children: [
                        child,
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
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
                              width: 1.0,
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
          if (month != 12) divider,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedYear--;
                    });
                  },
                ),
                Text(
                  '$selectedYear',
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: GinaAppTheme.lightTertiaryContainer,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.chevron_right,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedYear++;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              cacheExtent: 1000,
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: 12,
              itemBuilder: (context, index) {
                return buildMonthCalendar(selectedYear, index + 1);
              },
            ),
          ),
        ],
      ),
    );
  }
}
