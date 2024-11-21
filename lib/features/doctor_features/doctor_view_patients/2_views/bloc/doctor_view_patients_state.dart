part of 'doctor_view_patients_bloc.dart';

sealed class DoctorViewPatientsState extends Equatable {
  const DoctorViewPatientsState();
  
  @override
  List<Object> get props => [];
}

final class DoctorViewPatientsInitial extends DoctorViewPatientsState {}
