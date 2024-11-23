import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_doctor_schedule_event.dart';
part 'create_doctor_schedule_state.dart';

class CreateDoctorScheduleBloc
    extends Bloc<CreateDoctorScheduleEvent, CreateDoctorScheduleState> {
  CreateDoctorScheduleBloc() : super(CreateDoctorScheduleInitial()) {
    on<CreateDoctorScheduleEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
