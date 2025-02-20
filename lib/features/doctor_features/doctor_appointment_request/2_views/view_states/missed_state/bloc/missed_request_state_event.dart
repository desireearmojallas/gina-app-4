part of 'missed_request_state_bloc.dart';

abstract class MissedRequestStateEvent extends Equatable {
  const MissedRequestStateEvent();

  @override
  List<Object> get props => [];
}

class MissedRequestStateInitialEvent extends MissedRequestStateEvent {}

class NavigateToMissedRequestDetailEvent extends MissedRequestStateEvent {
  final AppointmentModel appointment;

  const NavigateToMissedRequestDetailEvent({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

class NavigateToPatientDataEvent extends MissedRequestStateEvent {
  final UserModel patientData;
  final AppointmentModel appointment;

  const NavigateToPatientDataEvent(
      {required this.patientData, required this.appointment});

  @override
  List<Object> get props => [patientData, appointment];
}
