import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctor_appointment_request_event.dart';
part 'doctor_appointment_request_state.dart';

class DoctorAppointmentRequestBloc
    extends Bloc<DoctorAppointmentRequestEvent, DoctorAppointmentRequestState> {
  DoctorAppointmentRequestBloc() : super(DoctorAppointmentRequestInitial()) {
    on<DoctorAppointmentRequestInitialEvent>(requestInitialEvent);
    on<TabChangedEvent>(tabChangedEvent);
  }

  FutureOr<void> requestInitialEvent(DoctorAppointmentRequestInitialEvent event,
      Emitter<DoctorAppointmentRequestState> emit) {
    emit(DoctorAppointmentRequestInitial());
  }

  FutureOr<void> tabChangedEvent(
      TabChangedEvent event, Emitter<DoctorAppointmentRequestState> emit) {
    emit(TabChangedState(event.tab));
  }
}
