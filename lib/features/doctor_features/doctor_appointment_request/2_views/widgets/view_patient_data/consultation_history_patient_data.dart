import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_consultation_history_container.dart';

class ConsultationHistoryPatientData extends StatelessWidget {
  const ConsultationHistoryPatientData({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
      child: Container(
        width: size.width / 1.08,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        child: Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return const AppointmentConsultationHistoryContainer();
            },
          ),
        ),
      ),
    );
  }
}
