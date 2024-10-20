part of 'doctor_bottom_navigation_bloc.dart';

abstract class DoctorBottomNavigationState extends Equatable {
  final int currentIndex;
  final Widget selectedScreen;
  final List<int> navigationHistory;

  const DoctorBottomNavigationState({
    required this.currentIndex,
    required this.selectedScreen,
    required this.navigationHistory,
  });

  @override
  List<Object> get props => [currentIndex, navigationHistory];
}

final class DoctorBottomNavigationInitial extends DoctorBottomNavigationState {
  const DoctorBottomNavigationInitial({
    required super.currentIndex,
    required super.selectedScreen,
    required super.navigationHistory,
  });
}
