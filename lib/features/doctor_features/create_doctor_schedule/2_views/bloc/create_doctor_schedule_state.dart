part of 'create_doctor_schedule_bloc.dart';

sealed class CreateDoctorScheduleState extends Equatable {
  const CreateDoctorScheduleState();
  
  @override
  List<Object> get props => [];
}

final class CreateDoctorScheduleInitial extends CreateDoctorScheduleState {}
