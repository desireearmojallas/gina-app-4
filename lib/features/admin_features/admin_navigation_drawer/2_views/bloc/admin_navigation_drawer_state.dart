part of 'admin_navigation_drawer_bloc.dart';

abstract class AdminNavigationDrawerState extends Equatable {
  final int currentIndex;
  final Widget selectedScreen;
  const AdminNavigationDrawerState({
    required this.currentIndex,
    required this.selectedScreen,
  });

  @override
  List<Object> get props => [
        currentIndex,
      ];
}

final class AdminNavigationDrawerInitial extends AdminNavigationDrawerState {
  const AdminNavigationDrawerInitial({
    required super.currentIndex,
    required super.selectedScreen,
  });

  @override
  List<Object> get props => [
        currentIndex,
      ];
}
