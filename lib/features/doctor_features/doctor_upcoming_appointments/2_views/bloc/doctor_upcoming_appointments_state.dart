part of 'doctor_upcoming_appointments_bloc.dart';

sealed class DoctorUpcomingAppointmentsState extends Equatable {
  const DoctorUpcomingAppointmentsState();
  
  @override
  List<Object> get props => [];
}

final class DoctorUpcomingAppointmentsInitial extends DoctorUpcomingAppointmentsState {}
