part of 'profile_update_bloc.dart';

abstract class ProfileUpdateState extends Equatable {
  const ProfileUpdateState();

  @override
  List<Object> get props => [];
}

class ProfileUpdateInitial extends ProfileUpdateState {}

class ProfileUpdateError extends ProfileUpdateState {
  final String message;

  const ProfileUpdateError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProfileUpdating extends ProfileUpdateState {}

class ProfileUpdateSuccess extends ProfileUpdateState {}
