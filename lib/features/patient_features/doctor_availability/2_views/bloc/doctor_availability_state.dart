part of 'doctor_availability_bloc.dart';

abstract class DoctorAvailabilityState extends Equatable {
  const DoctorAvailabilityState();

  @override
  List<Object> get props => [];
}

abstract class DoctorAvailabilityActionState extends DoctorAvailabilityState {}

class DoctorAvailabilityInitial extends DoctorAvailabilityState {}

class DoctorAvailabilityLoading extends DoctorAvailabilityState {}

class DoctorAvailabilityLoaded extends DoctorAvailabilityState {
  final DoctorAvailabilityModel doctorAvailabilityModel;

  const DoctorAvailabilityLoaded(this.doctorAvailabilityModel);

  @override
  List<Object> get props => [doctorAvailabilityModel];
}

class DoctorAvailabilityError extends DoctorAvailabilityState {
  final String errorMessage;

  const DoctorAvailabilityError({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}
