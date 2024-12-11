part of 'appointment_details_bloc.dart';

sealed class AppointmentDetailsState extends Equatable {
  const AppointmentDetailsState();
  
  @override
  List<Object> get props => [];
}

final class AppointmentDetailsInitial extends AppointmentDetailsState {}
