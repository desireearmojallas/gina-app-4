part of 'pending_request_state_bloc.dart';

sealed class PendingRequestStateEvent extends Equatable {
  const PendingRequestStateEvent();

  @override
  List<Object> get props => [];
}

class PendingRequestStateInitialEvent extends PendingRequestStateEvent {}

class NavigateToPendingRequestDetailEvent extends PendingRequestStateEvent {
  final AppointmentModel appointment;

  const NavigateToPendingRequestDetailEvent({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

class NavigateToDeclinedRequestDetailEvent extends PendingRequestStateEvent {
  final AppointmentModel appointment;

  const NavigateToDeclinedRequestDetailEvent({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

class ApproveAppointmentEvent extends PendingRequestStateEvent {
  final String appointmentId;

  const ApproveAppointmentEvent({required this.appointmentId});

  @override
  List<Object> get props => [appointmentId];
}

class DeclineAppointmentEvent extends PendingRequestStateEvent {
  final String appointmentId;

  const DeclineAppointmentEvent({required this.appointmentId});

  @override
  List<Object> get props => [appointmentId];
}
