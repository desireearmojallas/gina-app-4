import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'doctor_availability_event.dart';
part 'doctor_availability_state.dart';

class DoctorAvailabilityBloc extends Bloc<DoctorAvailabilityEvent, DoctorAvailabilityState> {
  DoctorAvailabilityBloc() : super(DoctorAvailabilityInitial()) {
    on<DoctorAvailabilityEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
