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
  final String chatroomId;
  final String recipientUid;

  const ConsultationLoadedAppointmentState({
    required this.chatroomId,
    required this.recipientUid,
  });

  @override
  List<Object> get props => [chatroomId, recipientUid];
}

class ConsultationNoAppointmentState extends ConsultationState {}

class ConsultationWaitingAppointmentState extends ConsultationState {}

class ConsultationFailedAppointmentState extends ConsultationState {
  final String errorMessage;

  const ConsultationFailedAppointmentState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
