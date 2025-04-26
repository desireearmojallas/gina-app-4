part of 'doctor_schedule_management_bloc.dart';

abstract class DoctorScheduleManagementEvent extends Equatable {
  const DoctorScheduleManagementEvent();

  @override
  List<Object> get props => [];
}

class DoctorScheduleManagementInitialEvent
    extends DoctorScheduleManagementEvent {}

class ToggleScheduleEditModeEvent extends DoctorScheduleManagementEvent {
  final bool isEditing;

  const ToggleScheduleEditModeEvent({required this.isEditing});

  @override
  List<Object> get props => [isEditing];
}

class ToggleTimeSlotEvent extends DoctorScheduleManagementEvent {
  final int day;
  final String startTime;
  final String endTime;
  final bool disable;

  const ToggleTimeSlotEvent({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.disable,
  });

  @override
  List<Object> get props => [day, startTime, endTime, disable];
}
