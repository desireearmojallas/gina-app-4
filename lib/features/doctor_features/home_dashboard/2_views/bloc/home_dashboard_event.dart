part of 'home_dashboard_bloc.dart';

sealed class HomeDashboardEvent extends Equatable {
  const HomeDashboardEvent();

  @override
  List<Object> get props => [];
}

class HomeInitialEvent extends HomeDashboardEvent {
  final AppointmentModel? selectedAppointment;

  const HomeInitialEvent({this.selectedAppointment});

  @override
  List<Object> get props => [selectedAppointment!];
}

class GetDoctorNameEvent extends HomeDashboardEvent {}

class CheckForExceededAppointmentsEvent extends HomeDashboardEvent {}

class ResetExceededAppointmentDialogEvent extends HomeDashboardEvent {}
