import 'package:flutter/material.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_consultation_history_container.dart';

class ConsultationHistoryList extends StatelessWidget {
  const ConsultationHistoryList({
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
            child: _title(context, 'Consultation History'),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return const AppointmentConsultationHistoryContainer();
            },
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
