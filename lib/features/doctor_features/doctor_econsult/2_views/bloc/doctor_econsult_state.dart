part of 'doctor_econsult_bloc.dart';

abstract class DoctorEConsultState extends Equatable {
  const DoctorEConsultState();

  @override
  List<Object> get props => [];
}

abstract class DoctorEConsultActionState extends DoctorEConsultState {}

class DoctorEConsultInitial extends DoctorEConsultState {}

class DoctorEConsultLoadingState extends DoctorEConsultActionState {}

class DoctorEConsultLoadedState extends DoctorEConsultActionState {
  final List<AppointmentModel> upcomingAppointments;
  final List<ChatMessageModel> chatRooms;

  DoctorEConsultLoadedState(
      {required this.upcomingAppointments, required this.chatRooms});

  @override
  List<Object> get props => [upcomingAppointments, chatRooms];
}

class DoctorEConsultErrorState extends DoctorEConsultActionState {
  final String message;

  DoctorEConsultErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
