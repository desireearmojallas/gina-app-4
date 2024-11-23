import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctor_schedule_management_event.dart';
part 'doctor_schedule_management_state.dart';

class DoctorScheduleManagementBloc
    extends Bloc<DoctorScheduleManagementEvent, DoctorScheduleManagementState> {
  DoctorScheduleManagementBloc() : super(DoctorScheduleManagementInitial()) {
    on<DoctorScheduleManagementEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
