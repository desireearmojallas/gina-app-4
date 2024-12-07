part of 'find_bloc.dart';

abstract class FindState extends Equatable {
  const FindState();

  @override
  List<Object> get props => [];
}

abstract class FindActionState extends FindState {}

class FindInitial extends FindState {}

class FindLoading extends FindState {}

class FindLoaded extends FindState {}

class FindNavigateToDoctorDetailsState extends FindActionState {}

class GetDoctorNearMeSuccessState extends FindState {}

class GetDoctorNearMeFailedState extends FindState {}

class GetDoctorsInTheNearestCityLoadingState extends FindState {}

class GetDoctorsInTheNearestCitySuccessState extends FindState {}

class GetDoctorsInTheNearestCityFailedState extends FindState {}

class GetAllDoctorsFailedState extends FindState {}

class GetAllDoctorsLoadingState extends FindState {}

class OtherCitiesHiddenState extends FindState {}

class OtherCitiesVisibleState extends FindState {}
