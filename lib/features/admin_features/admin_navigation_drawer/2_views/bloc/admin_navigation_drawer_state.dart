part of 'admin_navigation_drawer_bloc.dart';

sealed class AdminNavigationDrawerState extends Equatable {
  const AdminNavigationDrawerState();
  
  @override
  List<Object> get props => [];
}

final class AdminNavigationDrawerInitial extends AdminNavigationDrawerState {}
