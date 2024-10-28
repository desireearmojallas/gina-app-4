// ignore_for_file: deprecated_member_use

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class HomeDashboardCalendarWidget extends StatelessWidget {
  const HomeDashboardCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        // navigate to doctor calendar
      },
      child: Container(
        height: size.height * 0.26,
        width: size.width / 1.05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: GinaAppTheme.lightOnTertiary,
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        child: Column(
          children: [
            const Gap(25),
            EasyDateTimeLine(
              initialDate: DateTime.now(),
              headerProps: EasyHeaderProps(
                monthStyle:
                    ginaTheme.textTheme.headlineSmall?.copyWith(fontSize: 16),
                monthPickerType: MonthPickerType.dropDown,
                selectedDateFormat: SelectedDateFormat.dayOnly,
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
                    color:
                        GinaAppTheme.lightSecondaryContainer.withOpacity(0.2),
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
          ],
        ),
      ),
    );
  }
}
