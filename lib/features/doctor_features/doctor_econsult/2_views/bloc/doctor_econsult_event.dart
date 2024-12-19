part of 'doctor_econsult_bloc.dart';

abstract class DoctorEconsultEvent extends Equatable {
  const DoctorEconsultEvent();

  @override
  List<Object> get props => [];
}

class DoctorEconsultInitialEvent extends DoctorEconsultEvent {}

class GetRequestedEconsultsDisplayEvent extends DoctorEconsultEvent {}

class GetPatientDataEvent extends DoctorEconsultEvent {
  final String patientUid;

  const GetPatientDataEvent({required this.patientUid});

  @override
  List<Object> get props => [patientUid];
}
