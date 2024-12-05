part of 'doctor_schedule_management_bloc.dart';

abstract class DoctorScheduleManagementEvent extends Equatable {
  const DoctorScheduleManagementEvent();

  @override
  List<Object> get props => [];
}

class DoctorScheduleManagementInitialEvent
    extends DoctorScheduleManagementEvent {}
