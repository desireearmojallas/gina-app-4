part of 'doctor_consultation_fee_bloc.dart';

sealed class DoctorConsultationFeeState extends Equatable {
  const DoctorConsultationFeeState();
  
  @override
  List<Object> get props => [];
}

final class DoctorConsultationFeeInitial extends DoctorConsultationFeeState {}
