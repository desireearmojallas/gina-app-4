part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();

  @override
  List<Object> get props => [];
}

class TabChangedEvent extends BottomNavigationEvent {
  final int tab;

  const TabChangedEvent({required this.tab});

  @override
  List<Object> get props => [tab];
}

class BackPressedEvent extends BottomNavigationEvent {}
