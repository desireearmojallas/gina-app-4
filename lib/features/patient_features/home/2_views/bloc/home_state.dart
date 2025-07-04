part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

abstract class HomeActionState extends HomeState {}

class HomeInitial extends HomeState {
  final List<AppointmentModel> completedAppointments;

  const HomeInitial({required this.completedAppointments});

  @override
  List<Object> get props => [completedAppointments];
}

class HomeGetPeriodTrackerDataState extends HomeState {}

class HomeNavigateToFindDoctorActionState extends HomeActionState {}

class HomeNavigateToForumActionState extends HomeActionState {}

class HomeGetPeriodTrackerDataAndConsultationHistoryLoadingState
    extends HomeState {}

class HomeGetPeriodTrackerDataAndConsultationHistorySuccess extends HomeState {
  final List<DateTime> periodTrackerModel;
  final List<AppointmentModel> consultationHistory;

  const HomeGetPeriodTrackerDataAndConsultationHistorySuccess({
    required this.periodTrackerModel,
    required this.consultationHistory,
  });

  @override
  List<Object> get props => [periodTrackerModel, consultationHistory];
}

class HomeGetPeriodTrackerDataAndConsultationHistoryDataError
    extends HomeState {
  final String errorMessage;

  const HomeGetPeriodTrackerDataAndConsultationHistoryDataError(
      {required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class HomeInitialSuccess extends HomeState {}

class HomeInitialError extends HomeState {
  final String errorMessage;

  const HomeInitialError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class HomeInitialLoading extends HomeState {}

class GetPatientNameState extends HomeState {
  final String patientName;

  const GetPatientNameState({required this.patientName});

  @override
  List<Object> get props => [patientName];
}

class DisplayApprovedAppointmentPaymentDialogState extends HomeActionState {
  final AppointmentModel appointment;

  DisplayApprovedAppointmentPaymentDialogState({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

class ConsultationHistoryErrorState extends HomeState {
  final String errorMessage;

  const ConsultationHistoryErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
