part of 'consultation_bloc.dart';

abstract class ConsultationState extends Equatable {
  const ConsultationState();

  @override
  List<Object> get props => [];
}

abstract class ConsultationActionState extends ConsultationState {}

class ConsultationInitial extends ConsultationState {}

class ConsultationLoadingState extends ConsultationState {}

class ConsultationLoadedAppointmentState extends ConsultationState {
  final String chatRoomId;
  final String recipientUid;

  const ConsultationLoadedAppointmentState({
    required this.chatRoomId,
    required this.recipientUid,
  });

  @override
  List<Object> get props => [chatRoomId, recipientUid];
}

class ConsultationNoAppointmentState extends ConsultationState {}

class ConsultationFaceToFaceAppointmentState extends ConsultationState {
  final AppointmentModel appointment;

  const ConsultationFaceToFaceAppointmentState({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

class ConsultationWaitingForAppointmentState extends ConsultationState {
  final AppointmentModel appointment;

  const ConsultationWaitingForAppointmentState({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

class ConsultationFailedAppointmentState extends ConsultationState {
  final String errorMessage;

  const ConsultationFailedAppointmentState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
