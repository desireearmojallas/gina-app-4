part of 'cancelled_request_state_bloc.dart';

abstract class CancelledRequestStateEvent extends Equatable {
  const CancelledRequestStateEvent();

  @override
  List<Object> get props => [];
}

class CancelledRequestStateInitialEvent extends CancelledRequestStateEvent {}

class NavigateToCancelledRequestDetailEvent extends CancelledRequestStateEvent {
  final AppointmentModel appointment;

  const NavigateToCancelledRequestDetailEvent({required this.appointment});

  @override
  List<Object> get props => [appointment];
}
