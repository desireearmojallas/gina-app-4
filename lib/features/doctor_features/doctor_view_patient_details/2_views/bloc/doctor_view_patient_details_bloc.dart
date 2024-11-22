import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'doctor_view_patient_details_event.dart';
part 'doctor_view_patient_details_state.dart';

class DoctorViewPatientDetailsBloc extends Bloc<DoctorViewPatientDetailsEvent, DoctorViewPatientDetailsState> {
  DoctorViewPatientDetailsBloc() : super(DoctorViewPatientDetailsInitial()) {
    on<DoctorViewPatientDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
