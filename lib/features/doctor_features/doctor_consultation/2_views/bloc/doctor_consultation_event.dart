part of 'doctor_consultation_bloc.dart';

abstract class DoctorConsultationEvent extends Equatable {
  const DoctorConsultationEvent();

  @override
  List<Object> get props => [];
}

class DoctorConsultationGetRequestedAppointmentEvent
    extends DoctorConsultationEvent {
  final String recipientUid;

  const DoctorConsultationGetRequestedAppointmentEvent(
      {required this.recipientUid});

  @override
  List<Object> get props => [recipientUid];
}

class DoctorConsultationGetOngoingAppointmentEvent
    extends DoctorConsultationEvent {}

class DoctorConsultationSendFirstMessageEvent extends DoctorConsultationEvent {
  final String message;
  final String recipient;

  const DoctorConsultationSendFirstMessageEvent({
    required this.message,
    required this.recipient,
  });

  @override
  List<Object> get props => [message, recipient];
}

class DoctorConsultationSendChatMessageEvent extends DoctorConsultationEvent {
  final String message;
  final String recipient;

  const DoctorConsultationSendChatMessageEvent({
    required this.message,
    required this.recipient,
  });

  @override
  List<Object> get props => [message, recipient];
}

class CompleteDoctorConsultationButtonEvent extends DoctorConsultationEvent {
  final String appointmentId;

  const CompleteDoctorConsultationButtonEvent({required this.appointmentId});

  @override
  List<Object> get props => [appointmentId];
}

class NavigateToPatientDataEvent extends DoctorConsultationEvent {
  final UserModel patientData;
  final AppointmentModel appointment;
  final List<AppointmentModel> completedAppointments;
  final List<PeriodTrackerModel> patientPeriods;

  const NavigateToPatientDataEvent({
    required this.patientData,
    required this.appointment,
    required this.completedAppointments,
    required this.patientPeriods,
  });

  @override
  List<Object> get props => [
        patientData,
        appointment,
        completedAppointments,
        patientPeriods,
      ];
}

class DoctorConsultationCheckStatusEvent extends DoctorConsultationEvent {
  final String appointmentId;

  const DoctorConsultationCheckStatusEvent({required this.appointmentId});

  @override
  List<Object> get props => [appointmentId];
}

class BeginF2FSessionEvent extends DoctorConsultationEvent {
  final String appointmentId;

  const BeginF2FSessionEvent({required this.appointmentId});

  @override
  List<Object> get props => [appointmentId];
}

class ConcludeF2FSessionEvent extends DoctorConsultationEvent {
  final String appointmentId;

  const ConcludeF2FSessionEvent({required this.appointmentId});

  @override
  List<Object> get props => [appointmentId];
}
