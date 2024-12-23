import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/1_controllers/doctor_appointment_request_controller.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

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

    patientData.fold(
      (failure) {
        debugPrint('Failed to fetch patient data: $failure');
        emit(GetPendingRequestFailedState(errorMessage: failure.toString()));
      },
      (patientData) {
        debugPrint('Fetched patient data: $patientData');
        storedAppointment = event.appointment;
        storedPatientData = patientData;
        emit(
          NavigateToPendingRequestDetailedState(
            appointment: event.appointment,
            patientData: patientData,
          ),
        );
      },
    );
  }

  FutureOr<void> approveAppointment(ApproveAppointmentEvent event,
      Emitter<PendingRequestStateState> emit) async {
    emit(ApproveAppointmentLoadingState());

    final result =
        await doctorAppointmentRequestController.approvePendingPatientRequest(
      appointmentId: event.appointmentId,
    );

    //TODO: Uncomment this after implementing the doctor consultation bloc
    //! Uncomment this after implementing the doctor consultation bloc
    // selectedPatientUid = storedPatientData!.uid;
    // selectedPatientAppointment = storedAppointment!.appointmentUid;
    // selectedPatientName = storedPatientData!.name;

    result.fold(
      (failure) =>
          emit(ApproveAppointmentFailedState(errorMessage: failure.toString())),
      (appointment) {
        // Ensure storedAppointment and storedPatientData are not null
        if (storedAppointment != null && storedPatientData != null) {
          emit(NavigateToApprovedRequestDetailedState(
              appointment: storedAppointment!,
              patientData: storedPatientData!));
        } else {
          emit(const ApproveAppointmentFailedState(
              errorMessage: 'Stored appointment or patient data is null'));
        }
      },
    );
  }

  FutureOr<void> declineAppointment(DeclineAppointmentEvent event,
      Emitter<PendingRequestStateState> emit) async {
    emit(DeclineAppointmentLoadingState());

    final result = await doctorAppointmentRequestController
        .declinePendingPatientRequest(appointmentId: event.appointmentId);

    result.fold(
      (failure) {
        emit(DeclineAppointmentFailedState(errorMessage: failure.toString()));
      },
      (success) {
        // Ensure storedAppointment is not null
        if (storedAppointment != null) {
          emit(NavigateToDeclinedRequestDetailedState(
              appointment: storedAppointment!));
        } else {
          emit(const DeclineAppointmentFailedState(
              errorMessage: 'Stored appointment is null'));
        }
      },
    );
  }
}
