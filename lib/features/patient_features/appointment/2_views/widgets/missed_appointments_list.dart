import 'package:flutter/material.dart';

class MissedAppointmentsList extends StatelessWidget {
  const MissedAppointmentsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        decelerationRate: ScrollDecelerationRate.fast,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: _title(context, 'Missed Appointments'),
          ),
          const Center(
            child: Text('Missed Appointments'),
          ),
        ],
      ),
    );
  }

  Widget _title(BuildContext context, String text) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
      textAlign: TextAlign.left,
    );
  }
}
