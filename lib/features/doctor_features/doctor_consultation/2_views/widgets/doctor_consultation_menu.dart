// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_upcoming_appointments/2_views/bloc/doctor_upcoming_appointments_bloc.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/bloc/home_dashboard_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:gina_app_4/main.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

class DoctorConsultationMenu extends StatelessWidget {
  final String appointmentId;
  final List<AppointmentModel> completedAppointments;

  const DoctorConsultationMenu({
    super.key,
    required this.appointmentId,
    required this.completedAppointments,
  });

  @override
  Widget build(BuildContext context) {
    final doctorConsultationBloc = context.read<DoctorConsultationBloc>();
    final homeDashboardBloc = context.read<HomeDashboardBloc>();
    final ginaTheme = Theme.of(context).textTheme;

    debugPrint(
        '========================= DEBUG INFO =========================');
    debugPrint('DoctorConsultationMenu build - appointmentId: $appointmentId');
    debugPrint(
        'DoctorConsultationMenu build - completedAppointments count: ${completedAppointments.length}');

    // Check if patientPeriodsForPatientDataMenu is already populated
    debugPrint(
        'Global patientPeriodsForPatientDataMenu: ${patientPeriodsForPatientDataMenu?.length ?? 'null'}');

    debugPrint('isAppointmentFinished: $isAppointmentFinished');
    debugPrint('isChatWaiting: $isChatWaiting');
    debugPrint('isF2FSession: $isF2FSession');
    debugPrint('===========================================================');

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

            debugPrint(
                '=================== VIEW PATIENT DATA PRESSED ===================');

            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CustomLoadingIndicator(
                  colors: [Colors.white],
                ),
              ),
            );

            // Get the patient UID from the global variables
            final patientUid = selectedPatientAppointmentModel?.patientUid ??
                appointmentDataFromDoctorUpcomingAppointmentsBloc?.patientUid;

            debugPrint('DoctorConsultationMenu - patientUid: $patientUid');

            if (patientUid == null) {
              // Close loading dialog
              Navigator.pop(context);
              // Show error if patient UID is not available
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Patient UID not available')),
              );
              return;
            }

            debugPrint(
                'DoctorConsultationMenu - Begin fetching data for patientUid: $patientUid');

            // Fetch completed appointments
            debugPrint(
                'DoctorConsultationMenu - Fetching completed appointments...');
            final completedAppointmentsResult = await homeDashboardBloc
                .doctorHomeDashboardController
                .getCompletedAppointments();

            debugPrint(
                'DoctorConsultationMenu - completedAppointmentsResult: ${completedAppointmentsResult.isRight() ? "Success" : "Error"}');

            if (context.mounted) {
              // Check if doctorAppointmentRequestController is available
              if (doctorConsultationBloc.doctorAppointmentRequestController ==
                  null) {
                debugPrint('ERROR: doctorAppointmentRequestController is NULL');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Controller not initialized')),
                );
                return;
              }

              debugPrint(
                  'DoctorConsultationMenu - Fetching patient periods for UID: $patientUid');

              try {
                final patientPeriodsResult = await doctorConsultationBloc
                    .doctorAppointmentRequestController
                    .getPatientPeriods(patientUid);

                debugPrint(
                    'DoctorConsultationMenu - patientPeriodsResult: ${patientPeriodsResult.isRight() ? "Success" : "Error: ${patientPeriodsResult.fold((l) => l, (r) => "Data received")}"}');

                if (patientPeriodsResult.isRight()) {
                  final periods = patientPeriodsResult.getOrElse(() => []);
                  debugPrint(
                      'DoctorConsultationMenu - periods count: ${periods.length}');

                  // Inspect periods data in detail
                  if (periods.isEmpty) {
                    debugPrint('WARNING: periods list is EMPTY');
                  } else {
                    debugPrint('Periods data sample:');
                    for (int i = 0;
                        i < (periods.length > 3 ? 3 : periods.length);
                        i++) {
                      final period = periods[i];
                      debugPrint(
                          'Period[$i] - startDate: ${period.startDate}, endDate: ${period.endDate} ');
                    }
                  }
                }

                // Close loading dialog
                Navigator.pop(context);

                completedAppointmentsResult.fold(
                  (failure) {
                    debugPrint(
                        'DoctorConsultationMenu - completedAppointments failure: $failure');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $failure')),
                    );
                  },
                  (completedAppointments) {
                    patientPeriodsResult.fold(
                      (failure) {
                        debugPrint(
                            'DoctorConsultationMenu - patientPeriods failure: $failure');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Error loading periods: $failure')),
                        );

                        // Continue with empty periods list if there's an error
                        if (context.mounted) {
                          debugPrint(
                              'DoctorConsultationMenu - navigating with empty periods list');

                          // Check if patientDataFromDoctorUpcomingAppointmentsBloc exists
                          if (patientDataFromDoctorUpcomingAppointmentsBloc ==
                              null) {
                            debugPrint(
                                'ERROR: patientDataFromDoctorUpcomingAppointmentsBloc is NULL');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Patient data not available')),
                            );
                            return;
                          }

                          // Check which appointment is being used
                          final AppointmentModel selectedAppointment =
                              isFromChatRoomLists
                                  ? selectedPatientAppointmentModel!
                                  : appointmentDataFromDoctorUpcomingAppointmentsBloc!;

                          debugPrint(
                              'Using appointment: ${selectedAppointment.appointmentUid}');

                          // Prepare completed appointments list for navigation
                          final List<AppointmentModel> appointmentsList =
                              completedAppointments.values
                                  .expand((appointments) => appointments)
                                  .toList();

                          debugPrint(
                              'Completed appointments count: ${appointmentsList.length}');

                          doctorConsultationBloc.add(NavigateToPatientDataEvent(
                            patientData:
                                patientDataFromDoctorUpcomingAppointmentsBloc!,
                            appointment: selectedAppointment,
                            completedAppointments: appointmentsList,
                            patientPeriods: const [], // Empty list as fallback
                          ));

                          debugPrint(
                              'NavigateToPatientDataEvent dispatched with empty periods list');
                        }
                      },
                      (periods) {
                        if (context.mounted) {
                          debugPrint(
                              'DoctorConsultationMenu - navigating with ${periods.length} periods');

                          // Store periods in global variable for potential future use
                          patientPeriodsForPatientDataMenu = periods;

                          // Check if patientDataFromDoctorUpcomingAppointmentsBloc exists
                          if (patientDataFromDoctorUpcomingAppointmentsBloc ==
                              null) {
                            debugPrint(
                                'ERROR: patientDataFromDoctorUpcomingAppointmentsBloc is NULL');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Patient data not available')),
                            );
                            return;
                          }

                          // Check which appointment is being used
                          final AppointmentModel selectedAppointment =
                              isFromChatRoomLists
                                  ? selectedPatientAppointmentModel!
                                  : appointmentDataFromDoctorUpcomingAppointmentsBloc!;

                          debugPrint(
                              'Using appointment: ${selectedAppointment.appointmentUid}');

                          // Prepare completed appointments list for navigation
                          final List<AppointmentModel> appointmentsList =
                              completedAppointments.values
                                  .expand((appointments) => appointments)
                                  .toList();

                          debugPrint(
                              'Completed appointments count: ${appointmentsList.length}');

                          doctorConsultationBloc.add(NavigateToPatientDataEvent(
                            patientData:
                                patientDataFromDoctorUpcomingAppointmentsBloc!,
                            appointment: selectedAppointment,
                            completedAppointments: appointmentsList,
                            patientPeriods: periods, // Use the fetched periods
                          ));

                          debugPrint(
                              'NavigateToPatientDataEvent dispatched with ${periods.length} periods');

                          // Print the actual object structure to help debug
                          debugPrint(
                              'First period object: ${periods.isNotEmpty ? periods.first.toString() : "No periods"}');
                        }
                      },
                    );
                  },
                );
              } catch (e) {
                debugPrint(
                    'DoctorConsultationMenu - Exception during fetch: $e');
                // Print stack trace for better debugging
                debugPrint(StackTrace.current.toString());
                // Close loading dialog
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            } else {
              // Close loading dialog
              Navigator.pop(context);

              // Show error if patient UID is not available
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Patient information not available')),
              );
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
          onPressed: isAppointmentFinished || isChatWaiting || isF2FSession
              ? null
              : () {
                  debugPrint('End consultation');
                  doctorConsultationBloc.add(
                      CompleteDoctorConsultationButtonEvent(
                          appointmentId: appointmentId));
                },
          child: Container(
            decoration: BoxDecoration(
              color: isAppointmentFinished || isChatWaiting || isF2FSession
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
                    color:
                        isAppointmentFinished || isChatWaiting || isF2FSession
                            ? Colors.white.withOpacity(0.9)
                            : Colors.white,
                  ),
                  const Gap(15),
                  Text(
                    'End consultation',
                    style: ginaTheme.bodyMedium?.copyWith(
                      color:
                          isAppointmentFinished || isChatWaiting || isF2FSession
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
