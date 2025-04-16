import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/bloc/appointment_details_bloc.dart';

Future<dynamic> showCancelModalDialog(
  BuildContext context, {
  required String appointmentId,
}) {
  final appointmentDetailBloc = context.read<AppointmentDetailsBloc>();
  final appointmentBloc = context.read<AppointmentBloc>();

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
        Icons.question_mark_rounded,
        color: GinaAppTheme.lightTertiaryContainer,
        size: 60,
      ),
      content: SizedBox(
        height: 170,
        width: 330,
        child: Column(
          children: [
            Text(
              'Are you sure you want to cancel\n your appointment?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const Gap(30),
            SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.7,
                child: OutlinedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    if (isFromAppointmentTabs) {
                      isFromAppointmentTabs = false;
                      appointmentBloc.add(
                        CancelAppointmentInAppointmentTabsEvent(
                            appointmentUid: appointmentId),
                      );
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(
                        context,
                        '/bottomNavigation',
                        arguments: {'initialIndex': 2},
                      );
                    } else {
                      appointmentDetailBloc.add(
                        CancelAppointmentEvent(appointmentUid: appointmentId),
                      );
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(
                        context,
                        '/bottomNavigation',
                        arguments: {'initialIndex': 2},
                      );
                    }
                  },
                  child: Text(
                    'Yes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                )),
            const Gap(10),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.7,
              child: OutlinedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'No',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  )),
            ),
          ],
        ),
      ),
    ),
  );
}
