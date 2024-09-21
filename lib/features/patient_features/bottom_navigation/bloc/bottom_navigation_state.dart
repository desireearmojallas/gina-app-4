part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationState extends Equatable {
  final int currentIndex;
  final Widget selectedScreen;
  final List<int> navigationHistory;

  const BottomNavigationState({
    required this.currentIndex,
    required this.selectedScreen,
    required this.navigationHistory,
  });

  @override
  List<Object> get props => [currentIndex, navigationHistory];
}

final class BottomNavigationInitial extends BottomNavigationState {
  const BottomNavigationInitial({
    required super.currentIndex,
    required super.selectedScreen,
    required super.navigationHistory,
  });
}
