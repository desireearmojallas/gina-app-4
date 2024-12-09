part of 'consultation_fee_details_bloc.dart';

sealed class ConsultationFeeDetailsState extends Equatable {
  const ConsultationFeeDetailsState();
  
  @override
  List<Object> get props => [];
}

final class ConsultationFeeDetailsInitial extends ConsultationFeeDetailsState {}
