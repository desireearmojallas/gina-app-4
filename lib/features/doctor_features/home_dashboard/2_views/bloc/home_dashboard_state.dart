part of 'home_dashboard_bloc.dart';

sealed class HomeDashboardState extends Equatable {
  const HomeDashboardState();

  @override
  List<Object> get props => [];
}

abstract class HomeDashboardActionState extends HomeDashboardState {}

class HomeDashboardInitial extends HomeDashboardState {
  final int pendingAppointments;
  final int confirmedAppointments;

  const HomeDashboardInitial({
    required this.pendingAppointments,
    required this.confirmedAppointments,
  });

  @override
  List<Object> get props => [
        pendingAppointments,
        confirmedAppointments,
      ];
}

class HomeDashboardNavigateToFindDoctorActionState extends HomeDashboardState {}
