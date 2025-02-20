part of 'pending_request_state_bloc.dart';

abstract class PendingRequestStateState extends Equatable {
  const PendingRequestStateState();

  @override
  List<Object> get props => [];
}

abstract class PendingRequestActionState extends PendingRequestStateState {
  const PendingRequestActionState();
}

class PendingRequestStateInitial extends PendingRequestStateState {}

class PendingRequestLoadingState extends PendingRequestStateState {}

class GetPendingRequestSuccessState extends PendingRequestStateState {
  final Map<DateTime, List<AppointmentModel>> pendingRequests;

  const GetPendingRequestSuccessState({required this.pendingRequests});

  @override
  List<Object> get props => [pendingRequests];
}

class GetPendingRequestFailedState extends PendingRequestStateState {
  final String errorMessage;

  const GetPendingRequestFailedState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class NavigateToApprovedRequestDetailedState extends PendingRequestActionState {
  final AppointmentModel appointment;
  final UserModel patientData;
  final List<AppointmentModel> completedAppointments;

  const NavigateToApprovedRequestDetailedState({
    required this.appointment,
    required this.patientData,
    required this.completedAppointments,
  });

  @override
  List<Object> get props => [
        appointment,
        patientData,
        completedAppointments,
      ];
}

class NavigateToPendingRequestDetailedState extends PendingRequestActionState {
  final AppointmentModel appointment;
  final UserModel patientData;
  final List<AppointmentModel> completedAppointments;

  const NavigateToPendingRequestDetailedState({
    required this.appointment,
    required this.patientData,
    required this.completedAppointments,
  });

  @override
  List<Object> get props => [appointment, patientData, completedAppointments];
}

class NavigateToDeclinedRequestDetailedState extends PendingRequestActionState {
  final AppointmentModel appointment;

  const NavigateToDeclinedRequestDetailedState({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

class ApproveAppointmentSuccessState extends PendingRequestStateState {}

class ApproveAppointmentFailedState extends PendingRequestStateState {
  final String errorMessage;

  const ApproveAppointmentFailedState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ApproveAppointmentLoadingState extends PendingRequestStateState {}

class DeclineAppointmentFailedState extends PendingRequestStateState {
  final String errorMessage;

  const DeclineAppointmentFailedState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class DeclineAppointmentLoadingState extends PendingRequestStateState {}
