part of 'doctor_appointment_request_screen_loaded_bloc.dart';

sealed class DoctorAppointmentRequestScreenLoadedEvent extends Equatable {
  const DoctorAppointmentRequestScreenLoadedEvent();

  @override
  List<Object> get props => [];
}

class TabChangedEvent extends DoctorAppointmentRequestScreenLoadedEvent {
  final int tab;

  const TabChangedEvent({required this.tab});

  @override
  List<Object> get props => [tab];
}
