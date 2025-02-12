import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/completed_appointments/appointment_consultation_history_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

class ConsultationHistoryPatientData extends StatelessWidget {
  final List<AppointmentModel> completedAppointments;
  const ConsultationHistoryPatientData({
    super.key,
    required this.completedAppointments,
  });

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
            itemCount: completedAppointments.length,
            itemBuilder: (context, index) {
              final appointment = completedAppointments[index];
              return AppointmentConsultationHistoryContainer(
                appointment: appointment,
              );
            },
          ),
        ),
      ),
    );
  }
}
