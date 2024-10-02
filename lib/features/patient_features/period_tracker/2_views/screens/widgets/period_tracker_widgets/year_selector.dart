// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:gina_app_4/core/theme/theme_service.dart';

class YearSelector extends StatelessWidget {
  final int selectedYear;
  final ValueChanged<int> onYearChanged;

  const YearSelector({
    super.key,
    required this.selectedYear,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              onYearChanged(selectedYear - 1);
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
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              onYearChanged(selectedYear + 1);
            },
          ),
        ],
      ),
    );
  }
}
