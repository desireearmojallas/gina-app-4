part of 'doctor_consultation_bloc.dart';

abstract class DoctorConsultationState extends Equatable {
  const DoctorConsultationState();

  @override
  List<Object> get props => [];
}

abstract class DoctorConsultationActionState extends DoctorConsultationState {}

class DoctorConsultationInitial extends DoctorConsultationState {}

class DoctorConsultationLoadingState extends DoctorConsultationState {}

class DoctorConsultationLoadedAppointmentState extends DoctorConsultationState {
  final String chatRoomId;
  final String recipientUid;

  const DoctorConsultationLoadedAppointmentState({
    required this.chatRoomId,
    required this.recipientUid,
  });

  @override
  List<Object> get props => [chatRoomId, recipientUid];
}

class DoctorConsultationNoAppointmentState extends DoctorConsultationState {}

class DoctorConsultationFaceToFaceAppointmentState
    extends DoctorConsultationState {}

class DoctorConsultationWaitingForAppointmentState
    extends DoctorConsultationState {}

class DoctorConsultationFailedAppointmentState extends DoctorConsultationState {
  final String message;

  const DoctorConsultationFailedAppointmentState({required this.message});

  @override
  List<Object> get props => [message];
}

class DoctorConsultationCompletedAppointmentState
    extends DoctorConsultationActionState {}

class DoctorConsultationErrorAppointmentState extends DoctorConsultationState {
  final String message;

  const DoctorConsultationErrorAppointmentState({required this.message});

  @override
  List<Object> get props => [message];
}

class NavigateToPatientDataState extends DoctorConsultationState {
  final UserModel patientData;
  final AppointmentModel appointment;
  final List<PeriodTrackerModel> patientPeriods;
  final List<AppointmentModel> patientAppointments;

  const NavigateToPatientDataState({
    required this.patientData,
    required this.appointment,
    required this.patientPeriods,
    required this.patientAppointments,
  });

  @override
  List<Object> get props => [
        patientData,
        appointment,
        patientPeriods,
        patientAppointments,
      ];
}
