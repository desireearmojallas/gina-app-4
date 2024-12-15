part of 'consultation_bloc.dart';

abstract class ConsultationEvent extends Equatable {
  const ConsultationEvent();

  @override
  List<Object> get props => [];
}

class ConsultationGetRequestedAppointmentEvent extends ConsultationEvent {
  final String recipientUid;

  const ConsultationGetRequestedAppointmentEvent({
    required this.recipientUid,
  });

  @override
  List<Object> get props => [recipientUid];
}

class ConsultationGetOngoingAppointmentEvent extends ConsultationEvent {}

class SendFirstMessageEvent extends ConsultationEvent {
  final String message;
  final String recipient;

  const SendFirstMessageEvent({
    required this.message,
    required this.recipient,
  });

  @override
  List<Object> get props => [message, recipient];
}

class SendChatMessageEvent extends ConsultationEvent {
  final String message;
  final String recipient;

  const SendChatMessageEvent({
    required this.message,
    required this.recipient,
  });

  @override
  List<Object> get props => [message, recipient];
}
