part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

abstract class ProfileActionState extends ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel patientData;

  const ProfileLoaded({required this.patientData});

  @override
  List<Object> get props => [patientData];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProfileLoading extends ProfileState {}

class NavigateToEditProfileState extends ProfileState {
  final UserModel patientData;

  const NavigateToEditProfileState({required this.patientData});

  @override
  List<Object> get props => [patientData];
}

class ProfileUpdated extends ProfileState {}

class OpenMenuBarState extends ProfileState {}

class ProfileNavigateToCycleHistoryState extends ProfileActionState {}

class ProfileNavigateToMyForumsPostState extends ProfileActionState {}
