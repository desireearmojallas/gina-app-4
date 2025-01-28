import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/1_controllers/doctor_appointment_request_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/bloc/pending_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_upcoming_appointments/2_views/bloc/doctor_upcoming_appointments_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';

part 'completed_request_state_event.dart';
part 'completed_request_state_state.dart';

class CompletedRequestStateBloc
    extends Bloc<CompletedRequestStateEvent, CompletedRequestStateState> {
  final DoctorAppointmentRequestController doctorAppointmentRequestController;
  CompletedRequestStateBloc({
    required this.doctorAppointmentRequestController,
  }) : super(CompletedRequestStateInitial()) {
    on<CompletedRequestStateInitialEvent>(fetchedCompletedAppointmentRequests);
    on<NavigateToCompletedRequestDetailEvent>(navigateToCompletedRequestDetail);
    on<NavigateToPatientDataEvent>(navigateToPatientData);
  }

  FutureOr<void> fetchedCompletedAppointmentRequests(
      CompletedRequestStateInitialEvent event,
      Emitter<CompletedRequestStateState> emit) async {
    emit(CompletedRequestLoadingState());

    final result = await doctorAppointmentRequestController
        .getCompletedDoctorAppointmentRequest();

    result.fold(
      (failure) {
        emit(GetCompletedRequestFailedState(errorMessage: failure.toString()));
      },
      (completedRequests) {
        emit(GetCompletedRequestSuccessState(
            completedRequests: completedRequests));
      },
    );
  }

  FutureOr<void> navigateToCompletedRequestDetail(
      NavigateToCompletedRequestDetailEvent event,
      Emitter<CompletedRequestStateState> emit) async {
    final patientData = await doctorAppointmentRequestController.getPatientData(
        patientUid: event.appointment.patientUid!);

    patientData.fold(
      (failure) {
        emit(GetCompletedRequestFailedState(errorMessage: failure.toString()));
      },
      (patientData) {
        storedAppointment = event.appointment;
        storedPatientData = patientData;
        emit(NavigateToCompletedRequestDetailState(
          appointment: event.appointment,
          patientData: patientData,
        ));
      },
    );
  }

  FutureOr<void> navigateToPatientData(NavigateToPatientDataEvent event,
      Emitter<CompletedRequestStateState> emit) async {
    final getPatientData = await doctorAppointmentRequestController
        .getDoctorPatients(patientUid: event.appointment.patientUid!);

    getPatientData.fold(
      (failure) {
        emit(GetCompletedRequestFailedState(errorMessage: failure.toString()));
      },
      (patientData) {
        patientDataFromDoctorUpcomingAppointmentsBloc = event.patientData;
        appointmentDataFromDoctorUpcomingAppointmentsBloc = event.appointment;
        emit(
          NavigateToPatientDataState(
            patientData: event.patientData,
            appointment: event.appointment,
            patientPeriods: patientData.patientPeriods,
            patientAppointments: patientData.patientAppointments,
          ),
        );
      },
    );
  }
}
