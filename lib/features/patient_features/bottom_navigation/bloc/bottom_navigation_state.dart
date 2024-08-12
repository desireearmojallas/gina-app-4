part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationState extends Equatable {
  final int currentIndex;
  final Widget selectedScreen;

  const BottomNavigationState({
    required this.currentIndex,
    required this.selectedScreen,
  });

  @override
  List<Object> get props => [currentIndex];
}

final class BottomNavigationInitial extends BottomNavigationState {
  const BottomNavigationInitial(
      {required super.currentIndex, required super.selectedScreen});

  @override
  List<Object> get props => [currentIndex];
}
