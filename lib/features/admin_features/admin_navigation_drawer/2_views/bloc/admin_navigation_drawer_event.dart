part of 'admin_navigation_drawer_bloc.dart';

abstract class AdminNavigationDrawerEvent extends Equatable {
  const AdminNavigationDrawerEvent();

  @override
  List<Object> get props => [];
}

class TabChangedEvent extends AdminNavigationDrawerEvent {
  final int tab;

  const TabChangedEvent({required this.tab});

  @override
  List<Object> get props => [tab];
}
