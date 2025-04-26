part of 'find_bloc.dart';

abstract class FindEvent extends Equatable {
  const FindEvent();

  @override
  List<Object> get props => [];
}

class FindInitialEvent extends FindEvent {}

class GetDoctorsNearMeEvent extends FindEvent {}

class FindNavigateToDoctorDetailsEvent extends FindEvent {
  final DoctorModel doctor;

  const FindNavigateToDoctorDetailsEvent({required this.doctor});

  @override
  List<Object> get props => [doctor];
}

class GetDoctorsInTheNearestCityEvent extends FindEvent {}

class GetAllDoctorsEvent extends FindEvent {}

class ToggleOtherCitiesVisibilityEvent extends FindEvent {}

class SetSearchRadiusEvent extends FindEvent {
  final double radius;

  const SetSearchRadiusEvent({required this.radius});

  @override
  List<Object> get props => [radius];
}
