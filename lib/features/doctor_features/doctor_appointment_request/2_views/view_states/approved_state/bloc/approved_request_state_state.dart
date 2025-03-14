part of 'approved_request_state_bloc.dart';

abstract class ApprovedRequestStateState extends Equatable {
  const ApprovedRequestStateState();

  @override
  List<Object> get props => [];
}

abstract class ApprovedRequestActionState extends ApprovedRequestStateState {
  const ApprovedRequestActionState();
}

class ApprovedRequestStateInitial extends ApprovedRequestStateState {}

class ApprovedRequestLoadingState extends ApprovedRequestStateState {}

class GetApprovedRequestSuccessState extends ApprovedRequestStateState {
  final Map<DateTime, List<AppointmentModel>> approvedRequests;

  const GetApprovedRequestSuccessState({required this.approvedRequests});

  @override
  List<Object> get props => [approvedRequests];
}

class GetApprovedRequestFailedState extends ApprovedRequestStateState {
  final String errorMessage;

  const GetApprovedRequestFailedState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class NavigateToApprovedRequestDetailState extends ApprovedRequestActionState {
  final AppointmentModel appointment;
  final UserModel patientData;
  final List<AppointmentModel> completedAppointments;
  final List<PeriodTrackerModel> patientPeriods;

  const NavigateToApprovedRequestDetailState({
    required this.appointment,
    required this.patientData,
    required this.completedAppointments,
    required this.patientPeriods,
  });

  @override
  List<Object> get props => [
        appointment,
        patientData,
        completedAppointments,
        patientPeriods,
      ];
}

class NavigateToPatientDataState extends ApprovedRequestActionState {
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
