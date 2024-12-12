import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/1_controllers/doctor_appointment_request_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/bloc/pending_request_state_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

part 'declined_request_state_event.dart';
part 'declined_request_state_state.dart';

class DeclinedRequestStateBloc
    extends Bloc<DeclinedRequestStateEvent, DeclinedRequestStateState> {
  final DoctorAppointmentRequestController doctorAppointmentRequestController;
  DeclinedRequestStateBloc({
    required this.doctorAppointmentRequestController,
  }) : super(DeclinedRequestStateInitial()) {
    on<DeclinedRequestStateInitialEvent>(fetchedDeclinedAppointmentRequests);
    on<NavigateToDeclinedRequestDetailEvent>(navigateToDeclinedRequestDetail);
  }

  FutureOr<void> fetchedDeclinedAppointmentRequests(
      DeclinedRequestStateInitialEvent event,
      Emitter<DeclinedRequestStateState> emit) async {
    emit(DeclinedRequestLoadingState());

    final result = await doctorAppointmentRequestController
        .getDeclinedDoctorAppointmentRequest();

    result.fold(
      (failure) {
        emit(GetDeclinedRequestFailedState(errorMessage: failure.toString()));
      },
      (declinedRequests) {
        emit(
            GetDeclinedRequestSuccessState(declinedRequests: declinedRequests));
      },
    );
  }

  FutureOr<void> navigateToDeclinedRequestDetail(
      NavigateToDeclinedRequestDetailEvent event,
      Emitter<DeclinedRequestStateState> emit) async {
    final patientData = await doctorAppointmentRequestController.getPatientData(
      patientUid: event.appointment.patientUid!,
    );

    patientData.fold(
      (failure) {
        emit(GetDeclinedRequestFailedState(errorMessage: failure.toString()));
      },
      (patientData) {
        storedAppointment = event.appointment;
        storedPatientData = patientData;
        emit(NavigateToDeclinedRequestDetailState(
          appointment: event.appointment,
          patientData: patientData,
        ));
      },
    );
  }
}
