part of 'consultation_fee_details_bloc.dart';

abstract class ConsultationFeeDetailsState extends Equatable {
  const ConsultationFeeDetailsState();

  @override
  List<Object> get props => [];
}

abstract class ConsultationFeeDetailsActionState
    extends ConsultationFeeDetailsState {}

class ConsultationFeeDetailsInitial extends ConsultationFeeDetailsState {
  final bool isPricingShown;

  const ConsultationFeeDetailsInitial({required this.isPricingShown});

  @override
  List<Object> get props => [isPricingShown];
}

class ConsultationFeeNoPricingState extends ConsultationFeeDetailsState {}
