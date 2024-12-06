part of 'doctor_consultation_fee_bloc.dart';

abstract class DoctorConsultationFeeState extends Equatable {
  const DoctorConsultationFeeState();

  @override
  List<Object> get props => [];
}

class DoctorConsultationFeeInitial extends DoctorConsultationFeeState {}

class DoctorConsultationFeeLoadingState extends DoctorConsultationFeeState {}

class DoctorConsultationFeeLoadedState extends DoctorConsultationFeeState {
  final DoctorModel doctor;

  const DoctorConsultationFeeLoadedState({required this.doctor});

  @override
  List<Object> get props => [doctor];
}

class DoctorConsultationFeeErrorState extends DoctorConsultationFeeState {
  final String errorMessage;

  const DoctorConsultationFeeErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class NavigateToEditDoctorConsultationFeeState
    extends DoctorConsultationFeeState {
  final DoctorModel doctorData;

  const NavigateToEditDoctorConsultationFeeState({required this.doctorData});

  @override
  List<Object> get props => [doctorData];
}
