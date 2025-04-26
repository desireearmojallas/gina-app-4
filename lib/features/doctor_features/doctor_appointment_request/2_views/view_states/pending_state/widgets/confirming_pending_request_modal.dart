// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/approved_state/screens/view_states/approved_request_details_screen_state.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/declined_state/screens/view_states/declined_request_details_screen_state.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/bloc/pending_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/bloc/home_dashboard_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:icons_plus/icons_plus.dart';

Future<dynamic> showConfirmingPendingRequestDialog(
  BuildContext context, {
  required String appointmentId,
  required AppointmentModel appointment,
  required UserModel patientData,
  bool? isFromHomePendingRequest = false,
  required List<AppointmentModel> completedAppointments,
  required List<PeriodTrackerModel> patientPeriods,
}) {
  // Capture the blocs immediately to avoid context issues later
  final pendingRequestStateBloc = context.read<PendingRequestStateBloc>();
  final homeDashboardBloc = context.read<HomeDashboardBloc>();

  debugPrint(
      'Opening confirming pending request dialog for appointment: $appointmentId');
  debugPrint('Appointment details:');
  debugPrint('Patient Name: ${appointment.patientName}');
  debugPrint('Amount: ${appointment.amount}');
  debugPrint('Status: ${appointment.appointmentStatus}');

  // Check payments subcollection
  FirebaseFirestore.instance
      .collection('appointments')
      .doc(appointmentId)
      .collection('payments')
      .get()
      .then((paymentSnapshot) {
    if (paymentSnapshot.docs.isNotEmpty) {
      final paymentData = paymentSnapshot.docs.first.data();
      debugPrint('Payment data from subcollection:');
      debugPrint('Invoice ID: ${paymentData['invoiceId']}');
      debugPrint('Status: ${paymentData['status']}');
      debugPrint('Amount: ${paymentData['amount']}');
      debugPrint('Refund Status: ${paymentData['refundStatus']}');
    } else {
      debugPrint('No payment documents found in subcollection');
    }
  });

  // Check pending_payments collection
  FirebaseFirestore.instance
      .collection('pending_payments')
      .doc(appointmentId)
      .get()
      .then((pendingPaymentSnapshot) {
    if (pendingPaymentSnapshot.exists) {
      final pendingPaymentData = pendingPaymentSnapshot.data();
      debugPrint('Pending payment data:');
      debugPrint('Invoice ID: ${pendingPaymentData?['invoiceId']}');
      debugPrint('Status: ${pendingPaymentData?['status']}');
      debugPrint('Amount: ${pendingPaymentData?['amount']}');
    } else {
      debugPrint('No pending payment document found');
    }
  });

  // Also fetch the periods immediately before showing the dialog
  final directPatientUid = appointment.patientUid;
  // We'll use this to get fresh periods data

  // Debug prints to check the values of patientData
  debugPrint('Parent Patient Name: ${patientData.name}');
  debugPrint('Parent Patient UID: $directPatientUid');
  debugPrint('Periods count being passed: ${patientPeriods.length}');

  return showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
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
              style: Theme.of(dialogContext).textTheme.titleLarge?.copyWith(
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
                    style:
                        Theme.of(dialogContext).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: GinaAppTheme.lightOutline,
                            ),
                  ),
                  const Gap(10),
                  Text(
                    '• Declining will inform the patient that their request has been cancelled.',
                    style:
                        Theme.of(dialogContext).textTheme.labelMedium?.copyWith(
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
              width: MediaQuery.of(dialogContext).size.width * 0.7,
              child: OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                onPressed: () async {
                  debugPrint('Doctor approved the appointment request');
                  // Store these values for later use
                  storedAppointment = appointment;
                  storedPatientData = patientData;

                  // First close the dialog to avoid context issues
                  Navigator.of(dialogContext).pop();

                  // Add the approval event
                  pendingRequestStateBloc.add(
                      ApproveAppointmentEvent(appointmentId: appointmentId));

                  // Fetch fresh completed appointments - after the dialog is closed
                  final completedAppointmentsResult = await homeDashboardBloc
                      .doctorHomeDashboardController
                      .getCompletedAppointments();

                  // Fetch fresh periods data
                  List<PeriodTrackerModel> freshPatientPeriods = patientPeriods;
                  if (directPatientUid != null) {
                    final periodsResult = await homeDashboardBloc
                        .doctorHomeDashboardController
                        .getPatientPeriods(directPatientUid);

                    periodsResult.fold((failure) {
                      debugPrint('Failed to fetch fresh periods: $failure');
                    }, (periods) {
                      debugPrint('Fresh periods fetched: ${periods.length}');
                      freshPatientPeriods = periods;
                      // Update global variable
                      patientPeriodsForPatientDataMenu = periods;
                    });
                  }

                  completedAppointmentsResult.fold(
                    (failure) {
                      debugPrint(
                          'Failed to fetch completed appointments: $failure');
                    },
                    (completedAppointments) {
                      // Handle navigation with the fresh data
                      if (isFromHomePendingRequest == true) {
                        debugPrint('Navigating from home screen');
                        // If we came from home screen, use pushReplacement and refresh home after
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ApprovedRequestDetailsScreenState(
                            appointment: appointment,
                            patientData: patientData,
                            appointmentStatus: 1,
                            completedAppointments: completedAppointments.values
                                .expand((appointments) => appointments)
                                .toList(),
                            patientPeriods: freshPatientPeriods,
                          );
                        })).then((_) {
                          // Only add the event if the context is still valid
                          if (context.mounted) {
                            homeDashboardBloc.add(const HomeInitialEvent());
                          }
                        });
                      } else {
                        debugPrint('Navigating from regular flow');
                        // Regular flow - just push the new screen
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return ApprovedRequestDetailsScreenState(
                            appointment: appointment,
                            patientData: patientData,
                            appointmentStatus: 1,
                            completedAppointments: completedAppointments.values
                                .expand((appointments) => appointments)
                                .toList(),
                            patientPeriods: freshPatientPeriods,
                          );
                        }));
                      }
                    },
                  );
                },
                child: Text(
                  'Approve',
                  style:
                      Theme.of(dialogContext).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                ),
              ),
            ),
            const Gap(15),
            SizedBox(
              height: 45,
              width: MediaQuery.of(dialogContext).size.width * 0.7,
              child: OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                onPressed: () async {
                  debugPrint('Doctor is declining the appointment request');

                  // First close the confirmation dialog
                  Navigator.of(dialogContext).pop();

                  // Show dialog to get decline reason
                  final declineReason = await _showDeclineReasonDialog(context);

                  // If reason dialog was cancelled or closed without submitting
                  if (declineReason == null) {
                    debugPrint('Decline cancelled - no reason provided');
                    return;
                  }

                  debugPrint('Decline reason: $declineReason');
                  storedAppointment = appointment;
                  storedPatientData = patientData;

                  // Update the appointment model with the decline reason
                  final updatedAppointment = appointment.copyWith(
                    declineReason: declineReason,
                  );

                  // Then handle the decline action with the reason
                  pendingRequestStateBloc.add(
                    DeclineAppointmentEvent(
                      appointmentId: appointmentId,
                      declineReason: declineReason,
                    ),
                  );

                  if (isFromHomePendingRequest == true) {
                    debugPrint('Navigating to declined screen from home');
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return DeclinedRequestDetailsScreenState(
                          appointment: updatedAppointment,
                          patient: patientData,
                          appointmentStatus: 4,
                        );
                      },
                    )).then((value) {
                      // Only add the event if the context is still valid
                      if (context.mounted) {
                        homeDashboardBloc.add(const HomeInitialEvent());
                      }
                    });
                  } else {
                    debugPrint(
                        'Navigating to declined screen from regular flow');
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return DeclinedRequestDetailsScreenState(
                          appointment: updatedAppointment,
                          patient: patientData,
                          appointmentStatus: 4,
                        );
                      },
                    ));
                  }
                },
                child: Text(
                  'Decline',
                  style:
                      Theme.of(dialogContext).textTheme.titleMedium?.copyWith(
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

Future<String?> _showDeclineReasonDialog(BuildContext context) {
  final TextEditingController reasonController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  return showDialog<String>(
    context: context,
    barrierDismissible: false, // User must provide a reason or cancel
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: GinaAppTheme.appbarColorLight,
      shadowColor: Colors.black.withOpacity(0.5),
      surfaceTintColor: GinaAppTheme.appbarColorLight,
      title: Text(
        'Reason for Declining',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please provide a reason for declining this appointment request.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: GinaAppTheme.lightOutline,
                    ),
              ),
              const Gap(15),
              TextFormField(
                controller: reasonController,
                maxLines: 3,
                minLines: 3,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Enter reason for declining...',
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: GinaAppTheme.lightOutline.withOpacity(0.5),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a reason for declining';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: GinaAppTheme.lightError,
                ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: GinaAppTheme.lightTertiaryContainer,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              Navigator.of(dialogContext).pop(reasonController.text);
            }
          },
          child: Text(
            'Submit',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    ),
  );
}
