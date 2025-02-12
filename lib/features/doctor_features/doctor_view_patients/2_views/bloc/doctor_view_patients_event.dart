part of 'doctor_view_patients_bloc.dart';

sealed class DoctorViewPatientsEvent extends Equatable {
  const DoctorViewPatientsEvent();

  @override
  List<Object> get props => [];
}

class DoctorViewPatientsInitialEvent extends DoctorViewPatientsEvent {}

class FindNavigateToPatientDetailsEvent extends DoctorViewPatientsEvent {
  final UserModel patient;

  const FindNavigateToPatientDetailsEvent({
    required this.patient,
  });

  @override
  List<Object> get props => [
        patient,
      ];
}
