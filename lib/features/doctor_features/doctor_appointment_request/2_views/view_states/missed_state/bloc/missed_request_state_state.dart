part of 'missed_request_state_bloc.dart';

abstract class MissedRequestStateState extends Equatable {
  const MissedRequestStateState();

  @override
  List<Object> get props => [];
}

abstract class MissedRequestActionState extends MissedRequestStateState {
  const MissedRequestActionState();
}

class MissedRequestStateInitial extends MissedRequestStateState {}

class MissedRequestLoadingState extends MissedRequestStateState {}

class GetMissedRequestSuccessState extends MissedRequestStateState {
  final Map<DateTime, List<AppointmentModel>> missedRequests;

  const GetMissedRequestSuccessState({required this.missedRequests});

  @override
  List<Object> get props => [missedRequests];
}

class GetMissedRequestFailedState extends MissedRequestStateState {
  final String errorMessage;

  const GetMissedRequestFailedState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class NavigateToMissedRequestDetailState extends MissedRequestActionState {
  final AppointmentModel appointment;
  final UserModel patientData;

  const NavigateToMissedRequestDetailState({
    required this.appointment,
    required this.patientData,
  });

  @override
  List<Object> get props => [appointment, patientData];
}

class NavigateToPatientDataState extends MissedRequestActionState {
  final UserModel patientData;
  final AppointmentModel appointment;
  final List<PeriodTrackerModel> patientPeriods;
  final List<AppointmentModel> patientAppointments;

  const NavigateToPatientDataState({
    required this.patientData,
    required this.appointment,
    required this.patientPeriods,
    required this.patientAppointments,
  });

  @override
  List<Object> get props => [
        patientData,
        appointment,
        patientPeriods,
        patientAppointments,
      ];
}
