part of 'admin_dashboard_bloc.dart';

sealed class AdminDashboardState extends Equatable {
  const AdminDashboardState();
  
  @override
  List<Object> get props => [];
}

final class AdminDashboardInitial extends AdminDashboardState {}
