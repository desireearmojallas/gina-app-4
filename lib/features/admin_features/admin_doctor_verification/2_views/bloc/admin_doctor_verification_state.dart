part of 'admin_doctor_verification_bloc.dart';

sealed class AdminDoctorVerificationState extends Equatable {
  const AdminDoctorVerificationState();
  
  @override
  List<Object> get props => [];
}

final class AdminDoctorVerificationInitial extends AdminDoctorVerificationState {}
