import 'package:flutter/material.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/widgets/view_patient_data/consultation_history_patient_data.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/widgets/view_patient_data/menstrual_cycle_information_patient_data_widget.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/widgets/view_patient_data/profile_details_patient_data.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

class DoctorViewPatientDetailsScreenLoaded extends StatelessWidget {
  final List<AppointmentModel> completedAppointments;
  final UserModel patient;
  const DoctorViewPatientDetailsScreenLoaded({
    super.key,
    required this.completedAppointments,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);

    debugPrint(
        'Patient consultation history from doctor view patient details screen: $completedAppointments');

    return ScrollbarCustom(
      child: Stack(
        children: [
          // const GradientBackground(),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Column(
                children: [
                  //TODO: Add the patient's profile details here
                  ProfileDetailsPatientData(
                    patientData: patient,
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                      child: Text(
                        'Menstrual Cycle Information'.toUpperCase(),
                        style: ginaTheme.textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const MenstrualCycleInformationPatientData(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                      child: Text(
                        'Consultation History'.toUpperCase(),
                        style: ginaTheme.textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  //! The only consultation history will show here would be the doctor & patient's consultation history together.
                  ConsultationHistoryPatientData(
                    completedAppointments: completedAppointments,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
