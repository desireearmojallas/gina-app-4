part of 'doctor_appointment_request_bloc.dart';

sealed class DoctorAppointmentRequestEvent extends Equatable {
  const DoctorAppointmentRequestEvent();

  @override
  List<Object> get props => [];
}

class DoctorAppointmentRequestInitialEvent
    extends DoctorAppointmentRequestEvent {}

class TabChangedEvent extends DoctorAppointmentRequestEvent {
  final int tab;

  const TabChangedEvent({required this.tab});

  @override
  List<Object> get props => [tab];
}
