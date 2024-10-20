part of 'doctor_bottom_navigation_bloc.dart';

abstract class DoctorBottomNavigationEvent extends Equatable {
  const DoctorBottomNavigationEvent();

  @override
  List<Object> get props => [];
}

class TabChangedEvent extends DoctorBottomNavigationEvent {
  final int tab;

  const TabChangedEvent({required this.tab});

  @override
  List<Object> get props => [tab];
}

class BackPressedEvent extends DoctorBottomNavigationEvent {}
