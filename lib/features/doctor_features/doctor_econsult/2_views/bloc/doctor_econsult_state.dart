part of 'doctor_econsult_bloc.dart';

sealed class DoctorEconsultState extends Equatable {
  const DoctorEconsultState();
  
  @override
  List<Object> get props => [];
}

final class DoctorEconsultInitial extends DoctorEconsultState {}
