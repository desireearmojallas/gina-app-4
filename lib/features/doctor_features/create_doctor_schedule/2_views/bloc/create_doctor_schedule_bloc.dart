import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/doctor_features/create_doctor_schedule/1_controllers/create_doctor_schedule_controller.dart';

part 'create_doctor_schedule_event.dart';
part 'create_doctor_schedule_state.dart';

bool isFromCreateDoctorSchedule = false;

class CreateDoctorScheduleBloc
    extends Bloc<CreateDoctorScheduleEvent, CreateDoctorScheduleState> {
  final CreateDoctorScheduleController scheduleController;
  CreateDoctorScheduleBloc({
    required this.scheduleController,
  }) : super(CreateDoctorScheduleInitial()) {
    on<CreateDoctorScheduleInitialEvent>(createDoctorScheduleInitialEvent);
    on<SaveScheduleEvent>(createDoctorScheduleEvent);
  }

  FutureOr<void> createDoctorScheduleInitialEvent(
      CreateDoctorScheduleInitialEvent event,
      Emitter<CreateDoctorScheduleState> emit) {
    emit(CreateDoctorScheduleInitial());
  }

  FutureOr<void> createDoctorScheduleEvent(
      SaveScheduleEvent event, Emitter<CreateDoctorScheduleState> emit) async {
    emit(CreateDoctorScheduleLoadingState());

    try {
      await scheduleController.createDoctorSchedule(
        days: event.selectedDays,
        startTimes: event.startTimes,
        endTimes: event.endTimes,
        modeOfAppointment: event.appointmentMode,
      );
      emit(CreateDoctorScheduleSuccessState());
    } catch (e) {
      emit(CreateDoctorScheduleFailureState(e.toString()));
    }
  }
}
