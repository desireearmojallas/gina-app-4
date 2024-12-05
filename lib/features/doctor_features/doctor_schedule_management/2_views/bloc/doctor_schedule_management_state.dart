part of 'doctor_schedule_management_bloc.dart';

abstract class DoctorScheduleManagementState extends Equatable {
  const DoctorScheduleManagementState();

  @override
  List<Object> get props => [];
}

abstract class DoctorScheduleManagementActionState
    extends DoctorScheduleManagementState {}

class DoctorScheduleManagementInitial extends DoctorScheduleManagementState {}

class GetScheduleLoadingState extends DoctorScheduleManagementState {}

class GetScheduleSuccessState extends DoctorScheduleManagementState {
  final ScheduleModel schedule;

  const GetScheduleSuccessState({required this.schedule});

  @override
  List<Object> get props => [schedule];
}

class GetScheduledFailedState extends DoctorScheduleManagementState {
  final String message;

  const GetScheduledFailedState({required this.message});

  @override
  List<Object> get props => [message];
}
