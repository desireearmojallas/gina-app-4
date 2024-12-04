part of 'create_doctor_schedule_bloc.dart';

abstract class CreateDoctorScheduleState extends Equatable {
  const CreateDoctorScheduleState();

  @override
  List<Object> get props => [];
}

abstract class CreateDoctorScheduleActionEvent
    extends CreateDoctorScheduleState {}

class CreateDoctorScheduleInitial extends CreateDoctorScheduleState {}

class CreateDoctorScheduleLoadingState extends CreateDoctorScheduleState {}

class CreateDoctorScheduleSuccessState extends CreateDoctorScheduleState {}

class CreateDoctorScheduleFailureState extends CreateDoctorScheduleState {
  final String errorMessage;

  const CreateDoctorScheduleFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
