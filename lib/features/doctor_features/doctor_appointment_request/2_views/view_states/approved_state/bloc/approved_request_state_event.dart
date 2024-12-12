part of 'approved_request_state_bloc.dart';

abstract class ApprovedRequestStateEvent extends Equatable {
  const ApprovedRequestStateEvent();

  @override
  List<Object> get props => [];
}

class ApprovedRequestStateInitialEvent extends ApprovedRequestStateEvent {}

class NavigateToApprovedRequestDetailEvent extends ApprovedRequestStateEvent {
  final AppointmentModel appointment;

  const NavigateToApprovedRequestDetailEvent({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

class NavigateToPatientDataEvent extends ApprovedRequestStateEvent {
  final UserModel patientData;
  final AppointmentModel appointment;

  const NavigateToPatientDataEvent(
      {required this.patientData, required this.appointment});

  @override
  List<Object> get props => [patientData, appointment];
}
