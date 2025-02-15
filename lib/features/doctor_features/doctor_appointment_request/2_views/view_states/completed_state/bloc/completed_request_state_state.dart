part of 'completed_request_state_bloc.dart';

abstract class CompletedRequestStateState extends Equatable {
  const CompletedRequestStateState();

  @override
  List<Object> get props => [];
}

abstract class CompletedRequestActionState extends CompletedRequestStateState {
  const CompletedRequestActionState();
}

class CompletedRequestStateInitial extends CompletedRequestStateState {}

class CompletedRequestLoadingState extends CompletedRequestStateState {}

class GetCompletedRequestSuccessState extends CompletedRequestStateState {
  final Map<DateTime, List<AppointmentModel>> completedRequests;

  const GetCompletedRequestSuccessState({required this.completedRequests});

  @override
  List<Object> get props => [completedRequests];
}

class GetCompletedRequestFailedState extends CompletedRequestStateState {
  final String errorMessage;

  const GetCompletedRequestFailedState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class NavigateToCompletedRequestDetailState
    extends CompletedRequestActionState {
  final AppointmentModel appointment;
  final UserModel patientData;
  final List<AppointmentModel> completedAppointments;

  const NavigateToCompletedRequestDetailState({
    required this.appointment,
    required this.patientData,
    required this.completedAppointments,
  });

  @override
  List<Object> get props => [appointment, patientData, completedAppointments];
}

class NavigateToPatientDataState extends CompletedRequestActionState {
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
