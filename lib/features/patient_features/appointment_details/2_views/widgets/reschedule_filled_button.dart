import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/bloc/appointment_details_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

String? appointmentUidToReschedule;

class RescheduleFilledButton extends StatelessWidget {
  // final String appointmentUid;
  final AppointmentModel appointment;
  final DoctorModel doctor;
  const RescheduleFilledButton({
    super.key,
    required this.appointment,
    required this.doctor,
  });
  @override
  Widget build(BuildContext context) {
    final appointmentDetailsBloc = context.read<AppointmentDetailsBloc>();
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    appointmentUidToReschedule = appointment.appointmentUid;
    appointmentDetailsForReschedule = appointment;
    return Center(
      child: SizedBox(
        width: size.width * 0.93,
        height: size.height / 17,
        child: FilledButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          onPressed: () {
            if (appointmentDetailsBloc.isAppointmentInPast(appointment)) {
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Appointment rescheduling is only allowed up to one hour before the scheduled time.',
                    style: ginaTheme.labelMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor:
                      GinaAppTheme.declinedTextColor.withOpacity(0.9),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  elevation: 0.0,
                ),
              );
            } else {
              HapticFeedback.mediumImpact();
              isRescheduleMode = true;
              if (isFromAppointmentTabs) {
                Navigator.pushNamed(
                  context,
                  '/bookAppointment',
                  arguments: doctor,
                );
              } else {
                Navigator.pushReplacementNamed(
                  context,
                  '/bookAppointment',
                  arguments: doctor,
                );
              }
            }
          },
          child: Text(
            'Reschedule',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
