part of 'find_bloc.dart';

abstract class FindState extends Equatable {
  final double searchRadius;

  const FindState({this.searchRadius = 25.0}); // Default 10km radius

  @override
  List<Object> get props => [searchRadius];
}

abstract class FindActionState extends FindState {}

class FindInitial extends FindState {
  const FindInitial({super.searchRadius}); // No default here
}

class FindLoading extends FindState {
  const FindLoading({super.searchRadius}); // No default here
}

class FindLoaded extends FindState {}

class FindNavigateToDoctorDetailsState extends FindActionState {
  final DoctorModel doctor;

  FindNavigateToDoctorDetailsState({required this.doctor});

  @override
  List<Object> get props => [doctor];
}

class GetDoctorNearMeSuccessState extends FindState {
  final List<DoctorModel> doctorLists;

  const GetDoctorNearMeSuccessState(
      {required this.doctorLists, super.searchRadius = 10.0});

  @override
  List<Object> get props => [doctorLists, searchRadius];
}

class GetDoctorNearMeFailedState extends FindState {
  final String errorMessage;

  const GetDoctorNearMeFailedState({
    required this.errorMessage,
    super.searchRadius, // Add this parameter
  });

  @override
  List<Object> get props =>
      [errorMessage, searchRadius]; // Include searchRadius in props
}

class GetDoctorNearMeLoadingState extends FindState {
  const GetDoctorNearMeLoadingState({super.searchRadius});
}

class GetDoctorsInTheNearestCityLoadingState extends FindState {
  const GetDoctorsInTheNearestCityLoadingState({super.searchRadius});
}

class GetDoctorsInTheNearestCitySuccessState extends FindState {
  final Map<String, List<DoctorModel>> citiesWithDoctors;

  const GetDoctorsInTheNearestCitySuccessState({
    required this.citiesWithDoctors,
    super.searchRadius,
  });

  @override
  List<Object> get props => [citiesWithDoctors, searchRadius];
}

class GetDoctorsInTheNearestCityFailedState extends FindState {
  final String errorMessage;

  const GetDoctorsInTheNearestCityFailedState(
      {required this.errorMessage, super.searchRadius});

  @override
  List<Object> get props => [errorMessage, searchRadius];
}

class GetAllDoctorsFailedState extends FindState {
  final String errorMessage;

  const GetAllDoctorsFailedState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class GetAllDoctorsLoadingState extends FindState {
  const GetAllDoctorsLoadingState({super.searchRadius});
}

class OtherCitiesHiddenState extends FindState {
  const OtherCitiesHiddenState({super.searchRadius});

  @override
  List<Object> get props => [searchRadius];
}

class OtherCitiesVisibleState extends FindState {
  const OtherCitiesVisibleState({super.searchRadius});

  @override
  List<Object> get props => [searchRadius];
}

class ToggleOtherCitiesVisibilityFailedState extends FindState {
  final String errorMessage;

  const ToggleOtherCitiesVisibilityFailedState(
      {required this.errorMessage, super.searchRadius});

  @override
  List<Object> get props => [errorMessage, searchRadius];
}
