part of 'doctor_econsult_bloc.dart';

abstract class DoctorEConsultEvent extends Equatable {
  const DoctorEConsultEvent();

  @override
  List<Object> get props => [];
}

class DoctorEConsultInitialEvent extends DoctorEConsultEvent {}

class GetRequestedEConsultsDiplayEvent extends DoctorEConsultEvent {}

class GetPatientDataEvent extends DoctorEConsultEvent {
  final String patientUid;

  const GetPatientDataEvent({required this.patientUid});

  @override
  List<Object> get props => [patientUid];
}
