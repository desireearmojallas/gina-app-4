part of 'consultation_fee_details_bloc.dart';

abstract class ConsultationFeeDetailsEvent extends Equatable {
  const ConsultationFeeDetailsEvent();

  @override
  List<Object> get props => [];
}

class ConsultationFeeNoPricingEvent extends ConsultationFeeDetailsEvent {}

class ToggleConsultationFeePricingEvent extends ConsultationFeeDetailsEvent {}
