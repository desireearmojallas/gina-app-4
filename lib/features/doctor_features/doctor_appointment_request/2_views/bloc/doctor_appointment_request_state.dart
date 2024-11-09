part of 'doctor_appointment_request_bloc.dart';

abstract class DoctorAppointmentRequestState extends Equatable {
  const DoctorAppointmentRequestState();

  @override
  List<Object> get props => [];
}

abstract class DoctorAppointmentRequestActionState
    extends DoctorAppointmentRequestState {}

class DoctorAppointmentRequestInitial extends DoctorAppointmentRequestState {}

class DoctorAppointmentRequestNavigateToFindDoctorActionState
    extends DoctorAppointmentRequestState {}
