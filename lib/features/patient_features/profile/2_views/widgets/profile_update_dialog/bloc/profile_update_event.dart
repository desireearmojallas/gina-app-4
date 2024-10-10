part of 'profile_update_bloc.dart';

abstract class ProfileUpdateEvent extends Equatable {
  const ProfileUpdateEvent();

  @override
  List<Object> get props => [];
}

class EditProfileSaveButtonEvent extends ProfileUpdateEvent {
  final String name;
  final String dateOfBirth;
  final String address;

  const EditProfileSaveButtonEvent({
    required this.name,
    required this.dateOfBirth,
    required this.address,
  });

  @override
  List<Object> get props => [name, dateOfBirth, address];
}
