import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/bloc/appointment_details_bloc.dart';

String? appointmentUidToReschedule;

class RescheduleFilledButton extends StatelessWidget {
  final String appointmentUid;
  final DoctorModel doctor;
  const RescheduleFilledButton({
    super.key,
    required this.appointmentUid,
    required this.doctor,
  });
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    appointmentUidToReschedule = appointmentUid;
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
            HapticFeedback.mediumImpact();
            isRescheduleMode = true;
            if (isFromAppointmentTabs) {
              Navigator.pushNamed(
                context,
                '/bookAppointment',
                arguments: doctor,
              );
            } else {
              Navigator.pushNamed(
                context,
                '/bookAppointment',
                arguments: doctor,
              );
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
