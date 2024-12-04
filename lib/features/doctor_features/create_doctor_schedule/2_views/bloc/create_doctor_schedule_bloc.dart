import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_doctor_schedule_event.dart';
part 'create_doctor_schedule_state.dart';

class CreateDoctorScheduleBloc
    extends Bloc<CreateDoctorScheduleEvent, CreateDoctorScheduleState> {
  CreateDoctorScheduleBloc() : super(CreateDoctorScheduleInitial()) {
    on<CreateDoctorScheduleInitialEvent>(createDoctorScheduleInitialEvent);
    on<SaveScheduleEvent>(createDoctorScheduleEvent);
  }

  //! to be continued...

  FutureOr<void> createDoctorScheduleInitialEvent(
      CreateDoctorScheduleInitialEvent event,
      Emitter<CreateDoctorScheduleState> emit) {}

  FutureOr<void> createDoctorScheduleEvent(
      SaveScheduleEvent event, Emitter<CreateDoctorScheduleState> emit) {}
}
