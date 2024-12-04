part of 'create_doctor_schedule_bloc.dart';

abstract class CreateDoctorScheduleEvent extends Equatable {
  const CreateDoctorScheduleEvent();

  @override
  List<Object> get props => [];
}

class CreateDoctorScheduleInitialEvent extends CreateDoctorScheduleEvent {}

class SaveScheduleEvent extends CreateDoctorScheduleEvent {
  final List<int> selectedDays;
  final List<String> startTimes;
  final List<String> endTimes;
  final List<int> appointmentMode;

  const SaveScheduleEvent({
    required this.selectedDays,
    required this.startTimes,
    required this.endTimes,
    required this.appointmentMode,
  });

  @override
  List<Object> get props =>
      [selectedDays, startTimes, endTimes, appointmentMode];
}
