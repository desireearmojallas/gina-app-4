part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileInitialEvent extends ProfileEvent {}

class GetProfileEvent extends ProfileEvent {}

class NavigateToEditProfileEvent extends ProfileEvent {}

class ProfileNavigateToCycleHistoryEvent extends ProfileEvent {}

class ProfileNavigateToMyForumsPostEvent extends ProfileEvent {}
