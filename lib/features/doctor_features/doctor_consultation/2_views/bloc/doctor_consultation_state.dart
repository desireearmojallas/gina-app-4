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
    extends DoctorConsultationState {
  final UserModel patientDetails;
  final bool isSessionStarted;
  final bool isSessionEnded;

  const DoctorConsultationFaceToFaceAppointmentState({
    required this.patientDetails,
    this.isSessionStarted = false,
    this.isSessionEnded = false,
  });

  DoctorConsultationFaceToFaceAppointmentState copyWith({
    UserModel? patientDetails,
    bool? isSessionStarted,
    bool? isSessionEnded,
  }) {
    return DoctorConsultationFaceToFaceAppointmentState(
      patientDetails: patientDetails ?? this.patientDetails,
      isSessionStarted: isSessionStarted ?? this.isSessionStarted,
      isSessionEnded: isSessionEnded ?? this.isSessionEnded,
    );
  }

  @override
  List<Object> get props => [patientDetails, isSessionStarted, isSessionEnded];
}

class DoctorConsultationWaitingForAppointmentState
    extends DoctorConsultationState {
  final AppointmentModel appointment;

  const DoctorConsultationWaitingForAppointmentState(
      {required this.appointment});

  @override
  List<Object> get props => [appointment];
}

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

class DoctorConsultationF2FSessionStartedState
    extends DoctorConsultationState {}

class DoctorConsultationF2FSessionEndedState extends DoctorConsultationState {}

class DoctorConsultationF2FLoadingState extends DoctorConsultationActionState {}
