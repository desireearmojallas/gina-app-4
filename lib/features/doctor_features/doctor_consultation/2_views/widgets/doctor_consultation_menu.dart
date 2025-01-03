import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_upcoming_appointments/2_views/bloc/doctor_upcoming_appointments_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';
import 'package:gina_app_4/main.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

class DoctorConsultationMenu extends StatelessWidget {
  final String appointmentId;
  const DoctorConsultationMenu({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    final doctorConsultationBloc = context.read<DoctorConsultationBloc>();
    final ginaTheme = Theme.of(context).textTheme;

    return SubmenuButton(
      onOpen: () {
        HapticFeedback.lightImpact();
      },
      onClose: () {
        HapticFeedback.lightImpact();
      },
      style: const ButtonStyle(
        padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.all(10.0),
        ),
        overlayColor: MaterialStatePropertyAll<Color>(
          Colors.transparent,
        ),
        shape: MaterialStatePropertyAll<CircleBorder>(
          CircleBorder(
            side: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
      ),
      menuStyle: MenuStyle(
        backgroundColor: const MaterialStatePropertyAll<Color>(
          Colors.white,
        ),
        elevation: const MaterialStatePropertyAll<double>(0.5),
        shadowColor: MaterialStatePropertyAll<Color>(
          Colors.black.withOpacity(0.2),
        ),
        shape: const MaterialStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
            ),
          ),
        ),
      ),
      menuChildren: [
        MenuItemButton(
          onPressed: () async {
            if (canVibrate == true) {
              await Haptics.vibrate(HapticsType.selection);
            }

            if (context.mounted) {
              doctorConsultationBloc.add(NavigateToPatientDataEvent(
                patientData: patientDataFromDoctorUpcomingAppointmentsBloc!,
                appointment: appointmentDataFromDoctorUpcomingAppointmentsBloc!,
              ));
            }
          },
          child: Row(
            children: [
              const Gap(15),
              const Icon(
                Icons.account_circle_rounded,
                color: GinaAppTheme.lightOnPrimaryColor,
              ),
              const Gap(15),
              Text(
                'View patient data',
                style: ginaTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(15),
            ],
          ),
        ),
        Divider(
          color: GinaAppTheme.lightOnPrimaryColor.withOpacity(0.2),
          thickness: 0.5,
        ),
        const Gap(10),
        MenuItemButton(
          onPressed: isFromChatRoomLists || isAppointmentFinished
              ? null
              : () {
                  debugPrint('End consultation');

                  doctorConsultationBloc.add(
                      CompleteDoctorConsultationButtonEvent(
                          appointmentId: appointmentId));
                },
          child: Container(
            decoration: BoxDecoration(
              color: isFromChatRoomLists || isAppointmentFinished
                  ? Colors.grey[200]?.withOpacity(0.8)
                  : GinaAppTheme.declinedTextColor,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Gap(15),
                  Icon(
                    Icons.call_end_rounded,
                    color: isFromChatRoomLists || isAppointmentFinished
                        ? Colors.white.withOpacity(0.9)
                        : Colors.white,
                  ),
                  const Gap(15),
                  Text(
                    'End consultation',
                    style: ginaTheme.bodyMedium?.copyWith(
                      color: isFromChatRoomLists || isAppointmentFinished
                          ? Colors.white.withOpacity(0.9)
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(15),
                ],
              ),
            ),
          ),
        ),
        const Gap(10),
      ],
      child: const Icon(
        Icons.info_outline,
      ),
    );
  }
}
