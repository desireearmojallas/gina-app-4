// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:gina_app_4/core/theme/theme_service.dart';

class DaySelector extends StatelessWidget {
  final List<int> selectedDays;
  final Function(List<int>) onSelectedDaysChanged;
  final TextStyle? headingStyle;
  final TextStyle? dayTextStyle;
  final Color selectedColor;
  final Color unselectedColor;
  final Color borderColor;

  DaySelector({
    super.key,
    required this.selectedDays,
    required this.onSelectedDaysChanged,
    this.headingStyle,
    this.dayTextStyle,
    this.selectedColor = GinaAppTheme.lightTertiaryContainer,
    this.unselectedColor = Colors.transparent,
    Color? borderColor,
  }) : borderColor = borderColor ?? Colors.grey.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    const daysOfTheWeek = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your office days',
          style: headingStyle,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List<Widget>.generate(7, (index) {
            final isSelected = ValueNotifier<bool>(
              selectedDays.contains(index),
            );

            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: ValueListenableBuilder<bool>(
                valueListenable: isSelected,
                builder: (_, selected, __) {
                  return GestureDetector(
                    onTap: () {
                      isSelected.value = !isSelected.value;

                      final updatedDays = List<int>.from(selectedDays);
                      if (isSelected.value) {
                        updatedDays.add(index);
                      } else {
                        updatedDays.remove(index);
                      }

                      onSelectedDaysChanged(updatedDays);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14.0,
                        horizontal: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? selectedColor : unselectedColor,
                        border: Border.all(
                          color: selected ? Colors.transparent : borderColor,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: SizedBox(
                        width: 25,
                        child: Center(
                          child: Text(
                            daysOfTheWeek[index],
                            style: dayTextStyle ??
                                Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
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
      ],
    );
  }
}
