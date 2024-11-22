part of 'doctor_view_patient_details_bloc.dart';

sealed class DoctorViewPatientDetailsState extends Equatable {
  const DoctorViewPatientDetailsState();
  
  @override
  List<Object> get props => [];
}

final class DoctorViewPatientDetailsInitial extends DoctorViewPatientDetailsState {}
