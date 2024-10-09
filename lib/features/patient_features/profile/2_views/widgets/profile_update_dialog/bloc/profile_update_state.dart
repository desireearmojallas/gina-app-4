part of 'profile_update_bloc.dart';

sealed class ProfileUpdateState extends Equatable {
  const ProfileUpdateState();
  
  @override
  List<Object> get props => [];
}

final class ProfileUpdateInitial extends ProfileUpdateState {}
