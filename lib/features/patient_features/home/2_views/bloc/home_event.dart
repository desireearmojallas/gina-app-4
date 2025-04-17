part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeInitialEvent extends HomeEvent {}

class HomeNavigateToFindDoctorEvent extends HomeEvent {}

class HomeNavigateToPeriodTrackerEvent extends HomeEvent {}

class HomeNavigateToForumEvent extends HomeEvent {}

class HomeGetPeriodTrackerDataAndConsultationHistoryEvent extends HomeEvent {}

class GetPatientNameEvent extends HomeEvent {}

class GetPatientCurrentLocationEvent extends HomeEvent {}

class FetchRecentlyApprovedAppointmentsEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class DisplayApprovedAppointmentPaymentDialogEvent extends HomeEvent {
  final AppointmentModel appointment;

  const DisplayApprovedAppointmentPaymentDialogEvent(
      {required this.appointment});

  @override
  List<Object> get props => [appointment];
}

class ResetHomeStateAfterDialogEvent extends HomeEvent {}
