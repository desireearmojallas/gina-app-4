part of 'declined_request_state_bloc.dart';

abstract class DeclinedRequestStateEvent extends Equatable {
  const DeclinedRequestStateEvent();

  @override
  List<Object> get props => [];
}

class DeclinedRequestStateInitialEvent extends DeclinedRequestStateEvent {}

class NavigateToDeclinedRequestDetailEvent extends DeclinedRequestStateEvent {
  final AppointmentModel appointment;

  const NavigateToDeclinedRequestDetailEvent({required this.appointment});

  @override
  List<Object> get props => [appointment];
}
