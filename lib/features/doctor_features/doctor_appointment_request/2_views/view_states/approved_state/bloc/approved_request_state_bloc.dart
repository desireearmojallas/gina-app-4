import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/1_controllers/doctor_appointment_request_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_upcoming_appointments/2_views/bloc/doctor_upcoming_appointments_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';

part 'approved_request_state_event.dart';
part 'approved_request_state_state.dart';

class ApprovedRequestStateBloc
    extends Bloc<ApprovedRequestStateEvent, ApprovedRequestStateState> {
  final DoctorAppointmentRequestController doctorAppointmentRequestController;
  ApprovedRequestStateBloc({
    required this.doctorAppointmentRequestController,
  }) : super(ApprovedRequestStateInitial()) {
    on<ApprovedRequestStateInitialEvent>(fetchedApprovedAppointmentRequests);
    on<NavigateToApprovedRequestDetailEvent>(navigateToApprovedRequestDetail);
    on<NavigateToPatientDataEvent>(navigateToPatientData);
  }

  FutureOr<void> fetchedApprovedAppointmentRequests(
      ApprovedRequestStateInitialEvent event,
      Emitter<ApprovedRequestStateState> emit) async {
    emit(ApprovedRequestLoadingState());

    final result = await doctorAppointmentRequestController
        .getConfirmedDoctorAppointmentRequest();

    result.fold(
      (failure) {
        emit(GetApprovedRequestFailedState(errorMessage: failure.toString()));
      },
      (approvedRequests) {
        emit(
            GetApprovedRequestSuccessState(approvedRequests: approvedRequests));
      },
    );
  }

  FutureOr<void> navigateToApprovedRequestDetail(
      NavigateToApprovedRequestDetailEvent event,
      Emitter<ApprovedRequestStateState> emit) async {
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

    selectedPatientUid = event.appointment.patientUid!;
    selectedPatientName = event.appointment.patientName!;
    selectedPatientAppointment = event.appointment.appointmentUid!;

    patientData.fold(
      (failure) {
        emit(GetApprovedRequestFailedState(errorMessage: failure.toString()));
      },
      (patientData) {
        completedAppointmentsResult.fold(
          (failure) {
            emit(GetApprovedRequestFailedState(
                errorMessage: failure.toString()));
          },
          (completedAppointments) {
            patientPeriodsResult.fold(
              (failure) {
                emit(GetApprovedRequestFailedState(
                    errorMessage: failure.toString()));
              },
              (patientPeriods) {
                patientDataFromDoctorUpcomingAppointmentsBloc = patientData;
                appointmentDataFromDoctorUpcomingAppointmentsBloc =
                    event.appointment;
                emit(NavigateToApprovedRequestDetailState(
                  appointment: event.appointment,
                  patientData: patientData,
                  completedAppointments: completedAppointments,
                  patientPeriods: patientPeriods,
                ));
              },
            );
          },
        );
      },
    );
  }

  FutureOr<void> navigateToPatientData(NavigateToPatientDataEvent event,
      Emitter<ApprovedRequestStateState> emit) async {
    final getPatientData = await doctorAppointmentRequestController
        .getDoctorPatients(patientUid: event.appointment.patientUid!);

    getPatientData.fold(
      (failure) {
        emit(GetApprovedRequestFailedState(errorMessage: failure.toString()));
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
