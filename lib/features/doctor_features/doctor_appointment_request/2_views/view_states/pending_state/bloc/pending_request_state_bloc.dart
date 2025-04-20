import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/1_controllers/doctor_appointment_request_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';

part 'pending_request_state_event.dart';
part 'pending_request_state_state.dart';

UserModel? storedPatientData;
AppointmentModel? storedAppointment;
bool isFromPendingRequest = false;

class PendingRequestStateBloc
    extends Bloc<PendingRequestStateEvent, PendingRequestStateState> {
  final DoctorAppointmentRequestController doctorAppointmentRequestController;
  PendingRequestStateBloc({required this.doctorAppointmentRequestController})
      : super(PendingRequestStateInitial()) {
    on<PendingRequestStateInitialEvent>(fetchedPendingAppointmentRequest);
    on<NavigateToPendingRequestDetailEvent>(navigateToPendingRequestDetail);
    on<ApproveAppointmentEvent>(approveAppointment);
    on<DeclineAppointmentEvent>(declineAppointment);
  }

  FutureOr<void> fetchedPendingAppointmentRequest(
      PendingRequestStateInitialEvent event,
      Emitter<PendingRequestStateState> emit) async {
    emit(PendingRequestLoadingState());

    final result = await doctorAppointmentRequestController
        .getPendingDoctorAppointmentRequest();

    result.fold(
      (failure) {
        debugPrint('Failed to fetch pending requests: $failure');
        emit(GetPendingRequestFailedState(errorMessage: failure.toString()));
      },
      (pendingRequests) {
        debugPrint('Fetched pending requests: $pendingRequests');
        emit(GetPendingRequestSuccessState(pendingRequests: pendingRequests));
      },
    );
  }

  FutureOr<void> navigateToPendingRequestDetail(
      NavigateToPendingRequestDetailEvent event,
      Emitter<PendingRequestStateState> emit) async {
    // Debugging: Print when the event is handled
    debugPrint(
        'NavigateToPendingRequestDetailEvent handled for appointment: ${event.appointment.appointmentUid}');

    final patientData = await doctorAppointmentRequestController.getPatientData(
        patientUid: event.appointment.patientUid!);

    final completedAppointmentsResult = await doctorAppointmentRequestController
        .getPatientCompletedAppointmentsWithCurrentDoctor(
      patientUid: event.appointment.patientUid!,
    );

    final patientPeriodsResult =
        await doctorAppointmentRequestController.getPatientPeriods(
      event.appointment.patientUid!,
    );

    patientData.fold(
      (failure) {
        debugPrint('Failed to fetch patient data: $failure');
        emit(GetPendingRequestFailedState(errorMessage: failure.toString()));
      },
      (patientData) {
        completedAppointmentsResult.fold(
          (failure) {
            debugPrint('Failed to fetch completed appointments: $failure');
            emit(
                GetPendingRequestFailedState(errorMessage: failure.toString()));
          },
          (completedAppointments) {
            debugPrint('Fetched patient data: $patientData');
            patientPeriodsResult.fold(
              (failure) {},
              (patientPeriods) {
                storedAppointment = event.appointment;
                storedPatientData = patientData;
                emit(
                  NavigateToPendingRequestDetailedState(
                    appointment: event.appointment,
                    patientData: patientData,
                    completedAppointments: completedAppointments,
                    patientPeriods: patientPeriods,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  FutureOr<void> approveAppointment(ApproveAppointmentEvent event,
      Emitter<PendingRequestStateState> emit) async {
    debugPrint('Stored Patient Data: $storedPatientData');
    debugPrint('Stored Appointment: $storedAppointment');
    emit(ApproveAppointmentLoadingState());

    if (storedPatientData == null || storedAppointment == null) {
      emit(const ApproveAppointmentFailedState(
          errorMessage: 'Stored appointment or patient data is null'));
      return;
    }

    final result =
        await doctorAppointmentRequestController.approvePendingPatientRequest(
      appointmentId: event.appointmentId,
    );

    final completedAppointmentsResult = await doctorAppointmentRequestController
        .getPatientCompletedAppointmentsWithCurrentDoctor(
      patientUid: storedAppointment!.patientUid!,
    );

    result.fold(
      (failure) =>
          emit(ApproveAppointmentFailedState(errorMessage: failure.toString())),
      (appointment) {
        completedAppointmentsResult.fold((failure) {
          debugPrint('Failed to fetch completed appointments: $failure');
          emit(GetPendingRequestFailedState(errorMessage: failure.toString()));
        }, (completedAppointments) {
          selectedPatientUid = storedPatientData!.uid;
          selectedPatientAppointment = storedAppointment!.appointmentUid;
          selectedPatientName = storedPatientData!.name;

          emit(NavigateToApprovedRequestDetailedState(
            appointment: storedAppointment!,
            patientData: storedPatientData!,
            completedAppointments: completedAppointments,
          ));
        });
      },
    );
  }

  FutureOr<void> declineAppointment(DeclineAppointmentEvent event,
      Emitter<PendingRequestStateState> emit) async {
    debugPrint('===== DECLINE APPOINTMENT EVENT =====');
    debugPrint('Appointment ID: ${event.appointmentId}');
    debugPrint('Timestamp: ${DateTime.now().toIso8601String()}');

    emit(DeclineAppointmentLoadingState());

    if (storedAppointment == null) {
      debugPrint('ERROR: Stored appointment is null');
      emit(const DeclineAppointmentFailedState(
          errorMessage: 'Stored appointment is null'));
      return;
    }

    // Update the stored appointment with the decline reason if provided
    if (event.declineReason != null) {
      storedAppointment = storedAppointment!.copyWith(
        declineReason: event.declineReason,
      );
    }

    debugPrint('Stored appointment details:');
    debugPrint('- Patient: ${storedAppointment!.patientName}');
    debugPrint('- Amount: ${storedAppointment!.amount}');
    debugPrint('- Status: ${storedAppointment!.appointmentStatus}');

    // Check payment status before declining
    try {
      final paymentQuery = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(event.appointmentId)
          .collection('payments')
          .get();

      if (paymentQuery.docs.isNotEmpty) {
        final paymentData = paymentQuery.docs.first.data();
        final paymentStatus = paymentData['status'] as String? ?? '';
        final refundStatus = paymentData['refundStatus'] as String?;

        debugPrint('Payment details before decline:');
        debugPrint('- Status: $paymentStatus');
        debugPrint('- Refund Status: $refundStatus');
        debugPrint('- Amount: ${paymentData['amount']}');
      } else {
        debugPrint('No payment document found in subcollection');

        // Check pending_payments
        final pendingPaymentDoc = await FirebaseFirestore.instance
            .collection('pending_payments')
            .doc(event.appointmentId)
            .get();

        if (pendingPaymentDoc.exists) {
          final paymentData = pendingPaymentDoc.data();
          debugPrint('Pending payment details:');
          debugPrint('- Status: ${paymentData?['status']}');
          debugPrint('- Refund Status: ${paymentData?['refundStatus']}');
          debugPrint('- Amount: ${paymentData?['amount']}');
        } else {
          debugPrint('No pending payment document found');
        }
      }
    } catch (e) {
      debugPrint('Error checking payment status: $e');
    }

    debugPrint('Calling declinePendingPatientRequest...');
    final result =
        await doctorAppointmentRequestController.declinePendingPatientRequest(
      appointmentId: event.appointmentId,
      declineReason: event.declineReason,
    );

    result.fold(
      (failure) {
        debugPrint('ERROR: Decline appointment failed: $failure');
        emit(DeclineAppointmentFailedState(errorMessage: failure.toString()));
      },
      (success) {
        debugPrint('Appointment declined successfully');
        debugPrint('Navigating to declined request details screen');
        emit(NavigateToDeclinedRequestDetailedState(
            appointment: storedAppointment!));
      },
    );

    debugPrint('===== DECLINE APPOINTMENT EVENT COMPLETED =====');
  }
}
