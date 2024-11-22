import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctor_view_patients_event.dart';
part 'doctor_view_patients_state.dart';

class DoctorViewPatientsBloc
    extends Bloc<DoctorViewPatientsEvent, DoctorViewPatientsState> {
  DoctorViewPatientsBloc() : super(DoctorViewPatientsInitial()) {
    on<DoctorViewPatientsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
