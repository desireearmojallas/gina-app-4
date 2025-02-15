import 'package:flutter/material.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/widgets/view_patient_data/appointment_information_patient_data.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/widgets/view_patient_data/consultation_history_patient_data.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/widgets/view_patient_data/menstrual_cycle_information_patient_data_widget.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/widgets/view_patient_data/profile_details_patient_data.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

class ViewPatientDataScreen extends StatelessWidget {
  final UserModel patient;
  // TODO: Will add this after implementing the period tracker
  //! will add this after implementing the period tracker
  // final List<PeriodTrackerModel> patientPeriods;
  final AppointmentModel patientAppointment;
  final List<AppointmentModel> patientAppointments;
  const ViewPatientDataScreen({
    super.key,
    required this.patient,
    required this.patientAppointment,
    required this.patientAppointments,
  });

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);

    debugPrint(
        'Patient consultation history from view patient data screen: $patientAppointments');

    return Scaffold(
      appBar: GinaDoctorAppBar(
        title: 'Patient Data',
      ),
      body: ScrollbarCustom(
        child: Stack(
          children: [
            // const GradientBackground(),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: Column(
                  children: [
                    ProfileDetailsPatientData(
                      patientData: patient,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                        child: Text(
                          'Appointment Information'.toUpperCase(),
                          style: ginaTheme.textTheme.titleSmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    AppointmentInformationPatientData(
                      appointment: patientAppointment,
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
                    //! no data yet
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

                    //! to be continued here...
                    //! The only consultation history will show here would be the doctor & patient's consultation history together.
                    ConsultationHistoryPatientData(
                      completedAppointments: patientAppointments,
                    ),
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
