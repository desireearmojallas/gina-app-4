part of 'completed_request_state_bloc.dart';

abstract class CompletedRequestStateEvent extends Equatable {
  const CompletedRequestStateEvent();

  @override
  List<Object> get props => [];
}

class CompletedRequestStateInitialEvent extends CompletedRequestStateEvent {}

class NavigateToCompletedRequestDetailEvent extends CompletedRequestStateEvent {
  final AppointmentModel appointment;

  const NavigateToCompletedRequestDetailEvent({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

class NavigateToPatientDataEvent extends CompletedRequestStateEvent {
  final UserModel patientData;
  final AppointmentModel appointment;

  const NavigateToPatientDataEvent(
      {required this.patientData, required this.appointment});

  @override
  List<Object> get props => [patientData, appointment];
}
