part of 'appointment_bloc.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object> get props => [];
}

abstract class AppointmentActionState extends AppointmentState {}

class AppointmentInitial extends AppointmentState {}
