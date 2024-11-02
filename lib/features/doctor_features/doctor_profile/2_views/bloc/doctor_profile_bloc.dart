import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctor_profile_event.dart';
part 'doctor_profile_state.dart';

class DoctorProfileBloc extends Bloc<DoctorProfileEvent, DoctorProfileState> {
  DoctorProfileBloc() : super(DoctorProfileInitial()) {
    on<DoctorProfileEvent>((event, emit) {});
  }
}
