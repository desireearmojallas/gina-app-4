import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/bloc/period_tracker_bloc.dart';

import 'year_selector.dart';
import 'weekdays_row.dart';
import 'month_calendar.dart';

class YearlyCalendarWidget extends StatefulWidget {
  final bool isEditMode;
  final List<PeriodTrackerModel> periodTrackerModel;
  final List<PeriodTrackerModel> allPeriodsWithPredictions;
  final List<PeriodTrackerModel> defaultPeriodPredictions;
  const YearlyCalendarWidget({
    super.key,
    this.isEditMode = false,
    required this.periodTrackerModel,
    required this.allPeriodsWithPredictions,
    required this.defaultPeriodPredictions,
  });

  @override
  State<YearlyCalendarWidget> createState() => _YearlyCalendarWidgetState();
}

class _YearlyCalendarWidgetState extends State<YearlyCalendarWidget> {
  int selectedYear = DateTime.now().year;
  final ScrollController _scrollController = ScrollController();

  List<DateTime> periodDates = [];

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
    return Column(
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
                return MonthCalendar(
                  periodTrackerModel: widget.periodTrackerModel,
                  // allPeriodsWithPredictions: widget.allPeriodsWithPredictions,
                  // defaultPeriodPredictions: widget.defaultPeriodPredictions,
                  year: selectedYear,
                  month: index + 1,
                  // periodDates: periodDates,
                  isEditMode: widget.isEditMode,
                  // onPeriodDatesChanged: (newDates) {
                  //   setState(() {
                  //     periodDates = newDates;
                  //   });
                  // },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
