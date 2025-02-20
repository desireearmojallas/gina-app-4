part of 'doctor_econsult_bloc.dart';

abstract class DoctorEconsultState extends Equatable {
  const DoctorEconsultState();

  @override
  List<Object> get props => [];
}

abstract class DoctorEconsultActionState extends DoctorEconsultState {}

class DoctorEconsultInitial extends DoctorEconsultState {}

class DoctorEconsultLoadingState extends DoctorEconsultActionState {}

class DoctorEconsultLoadedState extends DoctorEconsultActionState {
  final List<AppointmentModel> upcomingAppointments;
  final List<ChatMessageModel> chatRooms;

  DoctorEconsultLoadedState({
    required this.upcomingAppointments,
    required this.chatRooms,
  });

  @override
  List<Object> get props => [upcomingAppointments, chatRooms];
}

class DoctorEconsultErrorState extends DoctorEconsultActionState {
  final String errorMessage;

  DoctorEconsultErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class AppointmentDetailsLoadedState extends DoctorEconsultState {
  final AppointmentModel appointment;

  const AppointmentDetailsLoadedState({required this.appointment});

  @override
  List<Object> get props => [appointment];
}
