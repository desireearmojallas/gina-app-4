part of 'declined_request_state_bloc.dart';

abstract class DeclinedRequestStateState extends Equatable {
  const DeclinedRequestStateState();

  @override
  List<Object> get props => [];
}

abstract class DeclinedRequestActionState extends DeclinedRequestStateState {
  const DeclinedRequestActionState();
}

class DeclinedRequestStateInitial extends DeclinedRequestStateState {}

class DeclinedRequestLoadingState extends DeclinedRequestStateState {}

class GetDeclinedRequestSuccessState extends DeclinedRequestStateState {
  final Map<DateTime, List<AppointmentModel>> declinedRequests;

  const GetDeclinedRequestSuccessState({required this.declinedRequests});

  @override
  List<Object> get props => [declinedRequests];
}

class GetDeclinedRequestFailedState extends DeclinedRequestStateState {
  final String errorMessage;

  const GetDeclinedRequestFailedState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class NavigateToDeclinedRequestDetailState extends DeclinedRequestActionState {
  final AppointmentModel appointment;
  final UserModel patientData;

  const NavigateToDeclinedRequestDetailState({
    required this.appointment,
    required this.patientData,
  });

  @override
  List<Object> get props => [appointment, patientData];
}
