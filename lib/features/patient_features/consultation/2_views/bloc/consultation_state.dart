part of 'consultation_bloc.dart';

sealed class ConsultationState extends Equatable {
  const ConsultationState();
  
  @override
  List<Object> get props => [];
}

final class ConsultationInitial extends ConsultationState {}
