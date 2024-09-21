import 'package:flutter/material.dart';

class PeriodTrackerWidget extends StatelessWidget {
  final List<DateTime> periodDays; // List of period days
  final Function(DateTime) onDayTapped; // Callback for day tap

  const PeriodTrackerWidget({
    super.key,
    required this.periodDays,
    required this.onDayTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Create a monthly view (simplified for demonstration)
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, // 7 days a week
      ),
      itemBuilder: (context, index) {
        DateTime date = DateTime.now().add(Duration(days: index));
        bool isPeriodDay = periodDays.contains(date);

        return GestureDetector(
          onTap: () => onDayTapped(date),
          child: Container(
            decoration: BoxDecoration(
              color: isPeriodDay ? Colors.red : Colors.transparent,
              border: Border.all(color: Colors.grey),
            ),
            child: Center(child: Text('${date.day}')),
          ),
        );
      },
      itemCount: 30, // Display 30 days for the month
    );
  }
}

void showEditPeriodDialog(BuildContext context, DateTime selectedDate) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Period'),
        content: Text('Edit details for ${selectedDate.toLocal()}'),
        actions: [
          TextButton(
            onPressed: () {
              // Save changes
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
