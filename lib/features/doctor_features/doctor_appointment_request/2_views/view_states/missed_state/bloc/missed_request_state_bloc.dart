import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/1_controllers/doctor_appointment_request_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/cancelled_state/bloc/cancelled_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/bloc/pending_request_state_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';

part 'missed_request_state_event.dart';
part 'missed_request_state_state.dart';

class MissedRequestStateBloc
    extends Bloc<MissedRequestStateEvent, MissedRequestStateState> {
  final DoctorAppointmentRequestController doctorAppointmentRequestController;
  MissedRequestStateBloc({
    required this.doctorAppointmentRequestController,
  }) : super(MissedRequestStateInitial()) {
    on<MissedRequestStateInitialEvent>(fetchedMissedAppointmentRequests);
    on<NavigateToMissedRequestDetailEvent>(navigateToMissedRequestDetail);
  }

  FutureOr<void> fetchedMissedAppointmentRequests(
      MissedRequestStateInitialEvent event,
      Emitter<MissedRequestStateState> emit) async {
    emit(MissedRequestLoadingState());

    final result = await doctorAppointmentRequestController
        .getMissedDoctorAppointmentRequest();

    result.fold(
      (failure) {
        emit(GetMissedRequestFailedState(errorMessage: failure.toString()));
      },
      (missedRequests) {
        emit(GetMissedRequestSuccessState(missedRequests: missedRequests));
      },
    );
  }

  FutureOr<void> navigateToMissedRequestDetail(
      NavigateToMissedRequestDetailEvent event,
      Emitter<MissedRequestStateState> emit) async {
    final patientData = await doctorAppointmentRequestController.getPatientData(
        patientUid: event.appointment.patientUid!);

    patientData.fold(
      (failure) {
        emit(GetMissedRequestFailedState(errorMessage: failure.toString()));
      },
      (patientData) {
        storedAppointment = event.appointment;
        storedPatientData = patientData;
        emit(NavigateToMissedRequestDetailState(
          appointment: event.appointment,
          patientData: patientData,
        ));
      },
    );
  }
}
