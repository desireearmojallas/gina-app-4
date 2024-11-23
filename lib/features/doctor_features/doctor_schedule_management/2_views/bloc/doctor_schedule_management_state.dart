part of 'doctor_schedule_management_bloc.dart';

sealed class DoctorScheduleManagementState extends Equatable {
  const DoctorScheduleManagementState();
  
  @override
  List<Object> get props => [];
}

final class DoctorScheduleManagementInitial extends DoctorScheduleManagementState {}
