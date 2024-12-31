part of 'doctor_upcoming_appointments_bloc.dart';

abstract class DoctorUpcomingAppointmentsState extends Equatable {
  const DoctorUpcomingAppointmentsState();

  @override
  List<Object> get props => [];
}

abstract class DoctorUpcomingAppointmentsActionState
    extends DoctorUpcomingAppointmentsState {}

class DoctorUpcomingAppointmentsInitial
    extends DoctorUpcomingAppointmentsState {}

class DoctorUpcomingAppointmentsLoading
    extends DoctorUpcomingAppointmentsState {}

class DoctorUpcomingAppointmentsLoaded extends DoctorUpcomingAppointmentsState {
  final Map<DateTime, List<AppointmentModel>> appointments;

  const DoctorUpcomingAppointmentsLoaded({required this.appointments});

  @override
  List<Object> get props => [appointments];
}

class DoctorUpcomingAppointmentsError extends DoctorUpcomingAppointmentsState {
  final String message;

  const DoctorUpcomingAppointmentsError({required this.message});

  @override
  List<Object> get props => [message];
}

class UpcomingEventsState extends DoctorUpcomingAppointmentsState {
  // final Map<DateTime, List<AppointmentModel>> upcomingAppointments;

  // const UpcomingEventsState({required this.upcomingAppointments});

  // @override
  // List<Object> get props => [upcomingAppointments];
}

class PastEventsState extends DoctorUpcomingAppointmentsState {
  // final Map<DateTime, List<AppointmentModel>> pastAppointments;

  // const PastEventsState({required this.pastAppointments});

  // @override
  // List<Object> get props => [pastAppointments];
}

class DoctorPastAppointmentsLoaded extends DoctorUpcomingAppointmentsState {
  final Map<DateTime, List<AppointmentModel>> appointments;

  const DoctorPastAppointmentsLoaded({required this.appointments});

  @override
  List<Object> get props => [appointments];
}

class DoctorPastAppointmentsError extends DoctorUpcomingAppointmentsState {
  final String message;

  const DoctorPastAppointmentsError({required this.message});

  @override
  List<Object> get props => [message];
}

class DoctorPastAppointmentsLoading extends DoctorUpcomingAppointmentsState {}

class NavigateToApprovedRequestDetailState
    extends DoctorUpcomingAppointmentsActionState {
  final AppointmentModel appointment;
  final UserModel patientData;

  NavigateToApprovedRequestDetailState(
      {required this.appointment, required this.patientData});

  @override
  List<Object> get props => [appointment, patientData];
}

class NavigateToCompletedRequestDetailState
    extends DoctorUpcomingAppointmentsActionState {
  final AppointmentModel appointment;
  final UserModel patientData;

  NavigateToCompletedRequestDetailState(
      {required this.appointment, required this.patientData});

  @override
  List<Object> get props => [appointment, patientData];
}
