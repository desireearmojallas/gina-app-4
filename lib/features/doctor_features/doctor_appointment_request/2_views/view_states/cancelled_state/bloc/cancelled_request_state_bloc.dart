import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/1_controllers/doctor_appointment_request_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/bloc/pending_request_state_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

part 'cancelled_request_state_event.dart';
part 'cancelled_request_state_state.dart';

class CancelledRequestStateBloc
    extends Bloc<CancelledRequestStateEvent, CancelledRequestStateState> {
  final DoctorAppointmentRequestController doctorAppointmentRequestController;
  CancelledRequestStateBloc({
    required this.doctorAppointmentRequestController,
  }) : super(CancelledRequestStateInitial()) {
    on<CancelledRequestStateInitialEvent>(fetchedCancelledAppointmentRequest);
    on<NavigateToCancelledRequestDetailEvent>(navigateToCancelledRequestDetail);
  }

  FutureOr<void> fetchedCancelledAppointmentRequest(
      CancelledRequestStateInitialEvent event,
      Emitter<CancelledRequestStateState> emit) async {
    emit(CancelledRequestLoadingState());

    final result = await doctorAppointmentRequestController
        .getCancelledDoctorAppointmentRequest();

    result.fold(
      (failure) {
        emit(GetCancelledRequestFailedState(errorMessage: failure.toString()));
      },
      (cancelledRequests) {
        emit(GetCancelledRequestSuccessState(
            cancelledRequests: cancelledRequests));
      },
    );
  }

  FutureOr<void> navigateToCancelledRequestDetail(
      NavigateToCancelledRequestDetailEvent event,
      Emitter<CancelledRequestStateState> emit) async {
    final patientData = await doctorAppointmentRequestController.getPatientData(
      patientUid: event.appointment.patientUid!,
    );

    patientData.fold(
      (failure) {
        emit(GetCancelledRequestFailedState(errorMessage: failure.toString()));
      },
      (patientData) {
        storedAppointment = event.appointment;
        storedPatientData = patientData;
        emit(NavigateToCancelledRequestDetailState(
          appointment: event.appointment,
          patientData: patientData,
        ));
      },
    );
  }
}
