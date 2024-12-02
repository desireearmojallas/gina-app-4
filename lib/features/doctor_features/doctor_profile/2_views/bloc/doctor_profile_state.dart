part of 'doctor_profile_bloc.dart';

abstract class DoctorProfileState extends Equatable {
  const DoctorProfileState();

  @override
  List<Object> get props => [];
}

abstract class DoctorProfileActionState extends DoctorProfileState {}

class DoctorProfileInitial extends DoctorProfileState {}

class DoctorProfileLoaded extends DoctorProfileState {
  final DoctorModel doctorData;

  const DoctorProfileLoaded({required this.doctorData});

  @override
  List<Object> get props => [doctorData];
}

class DoctorProfileError extends DoctorProfileState {
  final String message;

  const DoctorProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

class DoctorProfileLoading extends DoctorProfileState {}

class NavigateToEditDoctorProfileState extends DoctorProfileState {
  final DoctorModel doctorData;

  const NavigateToEditDoctorProfileState({required this.doctorData});

  @override
  List<Object> get props => [doctorData];
}

class DoctorProfileUpdated extends DoctorProfileState {}

class DoctorProfileUpdateSuccessLoaded extends DoctorProfileState {}

class OpenMenuBarState extends DoctorProfileState {}

class DoctorProfileNavigateToMyForumsPostState
    extends DoctorProfileActionState {}
