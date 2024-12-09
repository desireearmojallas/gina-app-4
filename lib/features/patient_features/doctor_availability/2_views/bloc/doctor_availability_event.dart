part of 'doctor_availability_bloc.dart';

abstract class DoctorAvailabilityEvent extends Equatable {
  const DoctorAvailabilityEvent();

  @override
  List<Object> get props => [];
}

class GetDoctorAvailabilityEvent extends DoctorAvailabilityEvent {
  final String doctorId;

  const GetDoctorAvailabilityEvent({required this.doctorId});

  @override
  List<Object> get props => [doctorId];
}
