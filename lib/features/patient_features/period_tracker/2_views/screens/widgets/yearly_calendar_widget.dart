import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:table_calendar/table_calendar.dart';

class YearlyCalendarWidget extends StatefulWidget {
  const YearlyCalendarWidget({
    super.key,
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
        color: Colors.grey[300],
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

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Column(
        children: [
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
            calendarStyle: const CalendarStyle(
                // todayDecoration: BoxDecoration(
                //   color: GinaAppTheme.lightTertiaryContainer,
                //   shape: BoxShape.circle,
                // ),
                // todayTextStyle: TextStyle(
                //   color: GinaAppTheme.lightOnTertiary,
                //   fontWeight: FontWeight.bold,
                // ),
                ),
            calendarBuilders: CalendarBuilders(
              todayBuilder: (context, date, _) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Bootstrap.brightness_alt_high_fill,
                        size: 14,
                        color: GinaAppTheme.lightTertiaryContainer,
                      ),
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
