part of 'floating_doctor_menu_bar_bloc.dart';

abstract class FloatingDoctorMenuBarState extends Equatable {
  const FloatingDoctorMenuBarState();

  @override
  List<Object> get props => [];
}

class FloatingDoctorMenuBarInitial extends FloatingDoctorMenuBarState {}

class GetDoctorName extends FloatingDoctorMenuBarState {
  final String doctorName;

  const GetDoctorName({required this.doctorName});

  @override
  List<Object> get props => [doctorName];
}
