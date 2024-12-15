part of 'doctor_upcoming_appointments_bloc.dart';

abstract class DoctorUpcomingAppointmentsEvent extends Equatable {
  const DoctorUpcomingAppointmentsEvent();

  @override
  List<Object> get props => [];
}

class GetDoctorUpcomingAppointmentsEvent
    extends DoctorUpcomingAppointmentsEvent {}

class UpcomingAppointmentsFilterEvent extends DoctorUpcomingAppointmentsEvent {
  final bool isSelected;

  const UpcomingAppointmentsFilterEvent({required this.isSelected});

  @override
  List<Object> get props => [isSelected];
}

class PastAppointmentsFilterEvent extends DoctorUpcomingAppointmentsEvent {
  final bool isSelected;

  const PastAppointmentsFilterEvent({required this.isSelected});

  @override
  List<Object> get props => [isSelected];
}

class NavigateToApprovedRequestDetailEvent
    extends DoctorUpcomingAppointmentsEvent {
  final AppointmentModel appointment;

  const NavigateToApprovedRequestDetailEvent({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

class NavigateToCompletedRequestDetailEvent
    extends DoctorUpcomingAppointmentsEvent {
  final AppointmentModel appointment;

  const NavigateToCompletedRequestDetailEvent({required this.appointment});

  @override
  List<Object> get props => [appointment];
}
