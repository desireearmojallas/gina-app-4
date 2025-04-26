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
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';

class ViewPatientDataScreen extends StatelessWidget {
  final UserModel patient;
  final List<PeriodTrackerModel> patientPeriods;
  final AppointmentModel patientAppointment;
  final List<AppointmentModel> patientAppointments;
  const ViewPatientDataScreen({
    super.key,
    required this.patient,
    required this.patientPeriods,
    required this.patientAppointment,
    required this.patientAppointments,
  });

  @override
  Widget build(BuildContext context) {
    // Debug prints for patient periods
    debugPrint('================ ViewPatientDataScreen ================');
    debugPrint('Patient name: ${patient.name}');
    debugPrint('Patient periods count: ${patientPeriods.length}');
    if (patientPeriods.isEmpty) {
      debugPrint(
          'WARNING: Patient periods list is EMPTY in ViewPatientDataScreen');
    } else {
      debugPrint('Patient periods sample in ViewPatientDataScreen:');
      for (int i = 0;
          i < (patientPeriods.length > 3 ? 3 : patientPeriods.length);
          i++) {
        final period = patientPeriods[i];
        debugPrint(
            'Period[$i] - startDate: ${period.startDate}, endDate: ${period.endDate}');
      }
    }
    debugPrint('========================================================');
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

                    MenstrualCycleInformationPatientData(
                      patientPeriods: patientPeriods,
                    ),
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
