part of 'floating_doctor_menu_bar_bloc.dart';

abstract class FloatingDoctorMenuBarEvent extends Equatable {
  const FloatingDoctorMenuBarEvent();

  @override
  List<Object> get props => [];
}

class GetDoctorNameEvent extends FloatingDoctorMenuBarEvent {}
