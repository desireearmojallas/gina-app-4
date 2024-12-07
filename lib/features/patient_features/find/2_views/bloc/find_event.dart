part of 'find_bloc.dart';

abstract class FindEvent extends Equatable {
  const FindEvent();

  @override
  List<Object> get props => [];
}

class FindInitialEvent extends FindEvent {}

class GetDoctorsNearMeEvent extends FindEvent {}

class FindNavigateToDoctorDetailsEvent extends FindEvent {}

class GetDoctorsInTheNearestCityEvent extends FindEvent {}

class GetAllDoctorsEvent extends FindEvent {}

class ToggleOtherCitiesVisibilityEvent extends FindEvent {}
