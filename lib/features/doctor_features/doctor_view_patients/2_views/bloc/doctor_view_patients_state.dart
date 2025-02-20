part of 'doctor_view_patients_bloc.dart';

abstract class DoctorViewPatientsState extends Equatable {
  const DoctorViewPatientsState();

  @override
  List<Object> get props => [];
}

abstract class DoctorViewPatientsActionState extends DoctorViewPatientsState {}

class DoctorViewPatientsStateInitial extends DoctorViewPatientsState {}

class GetDoctorViewPatientsLoadingState extends DoctorViewPatientsState {}

class FindNavigateToPatientDetailsState extends DoctorViewPatientsActionState {
  final UserModel patient;
  final List<AppointmentModel> patientAppointments;
  final List<PeriodTrackerModel> patientPeriods;

  FindNavigateToPatientDetailsState({
    required this.patient,
    required this.patientAppointments,
    required this.patientPeriods,
  });

  @override
  List<Object> get props => [patient, patientAppointments, patientPeriods];
}

class GetPatientListSuccessState extends DoctorViewPatientsState {
  final List<UserModel> patientsAppointmentPeriod;
  final List<AppointmentModel> patientAppointmentList;

  const GetPatientListSuccessState(
      {required this.patientsAppointmentPeriod,
      required this.patientAppointmentList});

  @override
  List<Object> get props => [patientsAppointmentPeriod, patientAppointmentList];
}

class GetPatientListFailedState extends DoctorViewPatientsState {
  final String message;

  const GetPatientListFailedState({required this.message});

  @override
  List<Object> get props => [message];
}
