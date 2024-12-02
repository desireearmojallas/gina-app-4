part of 'doctor_profile_update_bloc.dart';

abstract class DoctorProfileUpdateState extends Equatable {
  const DoctorProfileUpdateState();

  @override
  List<Object> get props => [];
}

class DoctorProfileUpdateInitial extends DoctorProfileUpdateState {}

class DoctorProfileUpdateError extends DoctorProfileUpdateState {
  final String message;

  const DoctorProfileUpdateError({required this.message});

  @override
  List<Object> get props => [message];
}

class DoctorProfileUpdating extends DoctorProfileUpdateState {}

class DoctorProfileUpdateSuccess extends DoctorProfileUpdateState {}
