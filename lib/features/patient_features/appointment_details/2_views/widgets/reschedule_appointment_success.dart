import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/bloc/appointment_details_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

Future<dynamic> showRescheduleAppointmentSuccessDialog(
  BuildContext context,
  String appointmentId,
  DoctorModel doctor,
) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: GinaAppTheme.appbarColorLight,
      shadowColor: GinaAppTheme.appbarColorLight,
      surfaceTintColor: GinaAppTheme.appbarColorLight,
      icon: const Icon(
        Icons.check_circle_rounded,
        color: Colors.green,
        size: 80,
      ),
      content: SizedBox(
        height: 100,
        width: 300,
        child: Column(
          children: [
            Text(
              'Appointment Reschedule Success',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Gap(20),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.5,
              child: FilledButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, '/appointmentDetails');
                  Navigator.of(context).pop();

                  // context.read<AppointmentDetailsBloc>().add(
                  //       NavigateToReviewRescheduledAppointmentEvent(
                  //         appointmentUid: appointmentId,
                  //       ),
                  //     );

                  // context.read<AppointmentBloc>().add(
                  //     NavigateToAppointmentDetailsEvent(
                  //         doctorUid: doctor.uid,
                  //         appointmentUid: appointmentId));
                  debugPrint('Reschedule Success Dialog');
                },
                child: Text(
                  'Okay',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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
