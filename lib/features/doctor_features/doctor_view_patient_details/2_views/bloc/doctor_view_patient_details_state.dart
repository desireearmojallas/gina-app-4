part of 'doctor_view_patient_details_bloc.dart';

abstract class DoctorViewPatientDetailsState extends Equatable {
  const DoctorViewPatientDetailsState();

  @override
  List<Object> get props => [];
}

abstract class DoctorViewPatientDetailsActionState
    extends DoctorViewPatientDetailsState {}

class DoctorViewPatientDetailsInitial extends DoctorViewPatientDetailsState {}

class DoctorViewPatientDetailsLoading extends DoctorViewPatientDetailsState {}

class DoctorViewPatientDetailsLoaded extends DoctorViewPatientDetailsState {}
