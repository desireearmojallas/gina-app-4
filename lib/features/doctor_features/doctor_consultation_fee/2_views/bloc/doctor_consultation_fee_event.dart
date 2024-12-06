part of 'doctor_consultation_fee_bloc.dart';

abstract class DoctorConsultationFeeEvent extends Equatable {
  const DoctorConsultationFeeEvent();

  @override
  List<Object> get props => [];
}

class DoctorConsultationFeeInitialEvent extends DoctorConsultationFeeEvent {}

class GetDoctorConsultationFeeEvent extends DoctorConsultationFeeEvent {}

class NavigateToEditDoctorConsultationFeeEvent
    extends DoctorConsultationFeeEvent {}

class ToggleDoctorConsultationFeeEvent extends DoctorConsultationFeeEvent {}

class SaveEditDoctorConsultationFeeEvent extends DoctorConsultationFeeEvent {
  final double f2fInitialConsultationFee;
  final double f2fFollowUpConsultationFee;
  final double olInitialConsultationFee;
  final double olFollowUpConsultationFee;

  const SaveEditDoctorConsultationFeeEvent({
    required this.f2fInitialConsultationFee,
    required this.f2fFollowUpConsultationFee,
    required this.olInitialConsultationFee,
    required this.olFollowUpConsultationFee,
  });

  @override
  List<Object> get props => [
        f2fInitialConsultationFee,
        f2fFollowUpConsultationFee,
        olInitialConsultationFee,
        olFollowUpConsultationFee,
      ];
}
