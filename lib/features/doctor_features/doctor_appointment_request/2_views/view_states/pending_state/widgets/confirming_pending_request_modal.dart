import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/approved_state/screens/view_states/approved_request_details_screen_state.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/declined_state/screens/view_states/declined_request_details_screen_state.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/bloc/pending_request_state_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:icons_plus/icons_plus.dart';

Future<dynamic> showConfirmingPendingRequestDialog(
  BuildContext context, {
  required String appointmentId,
  required AppointmentModel appointment,
  required UserModel patientData,
}) {
  final pendingRequestStateBloc = context.read<PendingRequestStateBloc>();

  // Debug prints to check the values of patientData
  debugPrint('Parent Patient Name: ${patientData.name}');
  debugPrint('Parent Patient Date of Birth: ${patientData.dateOfBirth}');
  debugPrint('Parent Patient Gender: ${patientData.gender}');
  debugPrint('Parent Patient Address: ${patientData.address}');
  debugPrint('Parent Patient Email: ${patientData.email}');

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: GinaAppTheme.appbarColorLight,
      shadowColor: Colors.black.withOpacity(0.5),
      surfaceTintColor: GinaAppTheme.appbarColorLight,
      icon: const Icon(
        Bootstrap.question_circle,
        size: 50,
      ),
      content: SizedBox(
        height: 280,
        width: 330,
        child: Column(
          children: [
            Text(
              'Please confirm your action.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  const Gap(30),
                  Text(
                    '• Approving the appointment request will add it to your schedule.',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: GinaAppTheme.lightOutline,
                        ),
                  ),
                  const Gap(10),
                  Text(
                    '• Declining will inform the patient that their request has been cancelled.',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: GinaAppTheme.lightOutline,
                        ),
                  ),
                ],
              ),
            ),
            const Gap(40),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width * 0.7,
              child: OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                onPressed: () {
                  pendingRequestStateBloc.add(
                      ApproveAppointmentEvent(appointmentId: appointmentId));
                  // Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return ApprovedRequestDetailsScreenState(
                        appointment: appointment,
                        patientData: patientData,
                        appointmentStatus: 1,
                      );
                    },
                  ));
                },
                child: Text(
                  'Approve',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            const Gap(15),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width * 0.7,
              child: OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                onPressed: () {
                  pendingRequestStateBloc.add(
                      DeclineAppointmentEvent(appointmentId: appointmentId));
                  // Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DeclinedRequestDetailsScreenState(
                                appointment: appointment,
                                patient: patientData,
                                // appointmentStatus:
                                //     appointment.appointmentStatus,
                                appointmentStatus: 4,
                              )));
                },
                child: Text(
                  'Decline',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
