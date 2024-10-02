import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class WeekdaysRow extends StatelessWidget {
  const WeekdaysRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Sun',
          style: TextStyle(
            color: GinaAppTheme.lightTertiaryContainer,
          ),
        ),
        Text('Mon'),
        Text('Tue'),
        Text('Wed'),
        Text('Thu'),
        Text('Fri'),
        Text(
          'Sat',
          style: TextStyle(
            color: GinaAppTheme.lightOutline,
          ),
        ),
      ],
    );
  }
}
