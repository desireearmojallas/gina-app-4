part of 'doctor_profile_bloc.dart';

abstract class DoctorProfileEvent extends Equatable {
  const DoctorProfileEvent();

  @override
  List<Object> get props => [];
}

class DoctorProfileInitialEvent extends DoctorProfileEvent {}

class GetDoctorProfileEvent extends DoctorProfileEvent {}

class NavigateToEditDoctorProfileEvent extends DoctorProfileEvent {}

class DoctorProfileNavigateToMyForumsPostEvent extends DoctorProfileEvent {}
