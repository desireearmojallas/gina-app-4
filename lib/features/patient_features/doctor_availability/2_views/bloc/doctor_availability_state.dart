part of 'doctor_availability_bloc.dart';

sealed class DoctorAvailabilityState extends Equatable {
  const DoctorAvailabilityState();
  
  @override
  List<Object> get props => [];
}

final class DoctorAvailabilityInitial extends DoctorAvailabilityState {}
