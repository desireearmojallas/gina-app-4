part of 'doctor_consultation_bloc.dart';

sealed class DoctorConsultationState extends Equatable {
  const DoctorConsultationState();
  
  @override
  List<Object> get props => [];
}

final class DoctorConsultationInitial extends DoctorConsultationState {}
