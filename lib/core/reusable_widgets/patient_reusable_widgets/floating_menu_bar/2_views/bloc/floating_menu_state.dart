part of 'floating_menu_bloc.dart';

abstract class FloatingMenuState extends Equatable {
  const FloatingMenuState();

  @override
  List<Object> get props => [];
}

class FloatingMenuInitial extends FloatingMenuState {}

class GetPatientName extends FloatingMenuState {
  final String patientName;

  const GetPatientName({required this.patientName});

  @override
  List<Object> get props => [patientName];
}
