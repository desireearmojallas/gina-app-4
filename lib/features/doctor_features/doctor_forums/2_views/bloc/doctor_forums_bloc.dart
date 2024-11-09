import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctor_forums_event.dart';
part 'doctor_forums_state.dart';

class DoctorForumsBloc extends Bloc<DoctorForumsEvent, DoctorForumsState> {
  DoctorForumsBloc() : super(DoctorForumsInitial()) {
    on<DoctorForumsEvent>((event, emit) {});
  }
}
