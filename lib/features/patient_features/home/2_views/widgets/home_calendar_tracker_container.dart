// ignore_for_file: deprecated_member_use

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class HomeCalendarTrackerContainer extends StatelessWidget {
  const HomeCalendarTrackerContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final ginaTheme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: GinaAppTheme.lightOnTertiary,
        boxShadow: [
          GinaAppTheme.defaultBoxShadow,
        ],
      ),
      height: height * 0.28,
      width: width / 1.05,
      // TODO: WRAP THE COLUMN WITH BLOC BUILDER
      child: Column(
        children: [
          const Gap(15),
          EasyDateTimeLine(
            initialDate: DateTime.now(),
            // disabledDates: periodTrackerModel,
            headerProps: EasyHeaderProps(
              monthStyle:
                  ginaTheme.textTheme.headlineSmall?.copyWith(fontSize: 16),
              monthPickerType: MonthPickerType.dropDown,
              selectedDateFormat: SelectedDateFormat.fullDateMonthAsStrDY,
              selectedDateStyle:
                  ginaTheme.textTheme.headlineSmall?.copyWith(fontSize: 20),
            ),
            dayProps: EasyDayProps(
              height: 100,
              width: 75,
              disabledDayStyle: DayStyle(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  color: GinaAppTheme.lightSecondaryContainer.withOpacity(0.2),
                ),
              ),
              inactiveDayNumStyle: ginaTheme.textTheme.headlineSmall
                  ?.copyWith(color: GinaAppTheme.lightOutline),
              inactiveDayStrStyle: ginaTheme.textTheme.labelMedium
                  ?.copyWith(color: GinaAppTheme.lightOutline),
              todayHighlightStyle: TodayHighlightStyle.withBackground,
              todayHighlightColor: GinaAppTheme.lightPrimaryContainer,
              todayStyle: DayStyle(
                dayNumStyle: ginaTheme.textTheme.headlineSmall
                    ?.copyWith(color: GinaAppTheme.lightOutline),
              ),
              dayStructure: DayStructure.monthDayNumDayStr,
              inactiveDayStyle: DayStyle(
                dayNumStyle: ginaTheme.textTheme.headlineSmall
                    ?.copyWith(color: GinaAppTheme.lightOutline),
                dayStrStyle: ginaTheme.textTheme.labelMedium
                    ?.copyWith(color: GinaAppTheme.lightOutline),
              ),
              activeDayStyle: DayStyle(
                dayNumStyle: ginaTheme.textTheme.headlineSmall
                    ?.copyWith(color: Colors.white),
                dayStrStyle: ginaTheme.textTheme.labelMedium
                    ?.copyWith(color: Colors.white),
                monthStrStyle: ginaTheme.textTheme.labelMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
          const Gap(25),
          SizedBox(
            height: 35,
            child: FilledButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                ),
              ),
              child: Text(
                'Log Period',
                style: ginaTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                // TODO PERIOD TRACKER ROUTE
                Navigator.pushNamed(context, '/periodTracker');
              },
            ),
          ),
        ],
      ),
    );
  }
}
