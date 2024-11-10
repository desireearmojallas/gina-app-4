part of 'home_dashboard_bloc.dart';

sealed class HomeDashboardEvent extends Equatable {
  const HomeDashboardEvent();

  @override
  List<Object> get props => [];
}

class HomeInitialEvent extends HomeDashboardEvent {}

class GetDoctorNameEvent extends HomeDashboardEvent {}