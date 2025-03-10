import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';

import 'year_selector.dart';
import 'weekdays_row.dart';
import 'month_calendar.dart';

class YearlyCalendarWidget extends StatefulWidget {
  final List<DateTime> periodDates;
  final List<DateTime> averageBasedPredictionDates;
  final List<DateTime> day28PredictionDates;
  final bool isEditMode;
  final Function(List<DateTime> newDates) onPeriodDatesChanged;

  const YearlyCalendarWidget({
    super.key,
    required this.periodDates,
    required this.averageBasedPredictionDates,
    required this.day28PredictionDates,
    this.isEditMode = false,
    required this.onPeriodDatesChanged,
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
      _scrollToCurrentMonth();
    });
  }

  void _scrollToCurrentMonth() {
    final currentMonth = DateTime.now().month;
    const itemHeight = 375.0;
    const monthNameHeight = 10.0;
    final scrollPosition = (currentMonth - 1) * (itemHeight + monthNameHeight);
    _scrollController.jumpTo(scrollPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          YearSelector(
            selectedYear: selectedYear,
            onYearChanged: (newYear) {
              setState(() {
                selectedYear = newYear;
              });
            },
          ),
          const WeekdaysRow(),
          const Gap(20),
          Expanded(
            child: ScrollbarCustom(
              scrollController: _scrollController,
              child: ListView.builder(
                cacheExtent: 1000,
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final month = index + 1;
                  final monthPeriodDates = widget.periodDates
                      .where((date) =>
                          date.year == selectedYear && date.month == month)
                      .toList();
                  final monthAverageBasedPredictionDates = widget
                      .averageBasedPredictionDates
                      .where((date) =>
                          date.year == selectedYear && date.month == month)
                      .toList();
                  final monthDay28PredictionDates = widget.day28PredictionDates
                      .where((date) =>
                          date.year == selectedYear && date.month == month)
                      .toList();
                  return MonthCalendar(
                    year: selectedYear,
                    month: month,
                    periodDates: monthPeriodDates,
                    averageBasedPredictionDates:
                        monthAverageBasedPredictionDates,
                    day28PredictionDates: monthDay28PredictionDates,
                    isEditMode: widget.isEditMode,
                    onPeriodDatesChanged: (newDates) {
                      final updatedDates = widget.periodDates
                          .where((date) =>
                              date.year != selectedYear || date.month != month)
                          .toList();
                      updatedDates.addAll(newDates);
                      widget.onPeriodDatesChanged(updatedDates);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
