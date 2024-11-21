import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'doctor_view_patients_event.dart';
part 'doctor_view_patients_state.dart';

class DoctorViewPatientsBloc extends Bloc<DoctorViewPatientsEvent, DoctorViewPatientsState> {
  DoctorViewPatientsBloc() : super(DoctorViewPatientsInitial()) {
    on<DoctorViewPatientsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
