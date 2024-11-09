import 'package:flutter/material.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/widgets/view_patient_data/appointment_information_patient_data.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/widgets/view_patient_data/consultation_history_patient_data.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/widgets/view_patient_data/menstrual_cycle_information_patient_data_widget.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/widgets/view_patient_data/profile_details_patient_data.dart';

class ViewPatientDataScreen extends StatelessWidget {
  const ViewPatientDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);

    return Scaffold(
      appBar: GinaDoctorAppBar(
        title: 'Patient Data',
      ),
      body: ScrollbarCustom(
        child: Stack(
          children: [
            const GradientBackground(),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: Column(
                  children: [
                    const ProfileDetailsPatientData(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                        child: Text(
                          'Appointment Information'.toUpperCase(),
                          style: ginaTheme.textTheme.titleSmall?.copyWith(
                            color: GinaAppTheme.appbarColorLight,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const AppointmentInformationPatientData(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                        child: Text(
                          'Menstrual Cycle Information'.toUpperCase(),
                          style: ginaTheme.textTheme.titleSmall?.copyWith(
                            color: GinaAppTheme.appbarColorLight,
                            fontSize: 11,
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
                            color: GinaAppTheme.appbarColorLight,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    //! The only consultation history will show here would be the doctor & patient's consultation history together.
                    const ConsultationHistoryPatientData(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
