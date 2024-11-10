part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

abstract class HomeActionState extends Equatable {}

final class HomeInitial extends HomeState {}

// TODO: OTHER FUTURE METHODS

class HomeInitialSuccess extends HomeState {}

class HomeInitialError extends HomeState {}

class HomeInitialLoading extends HomeState {}

class GetPatientNameState extends HomeState {
  final String patientName;

  const GetPatientNameState({required this.patientName});

  @override
  List<Object> get props => [patientName];
}
