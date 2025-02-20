import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctor_view_patient_details_event.dart';
part 'doctor_view_patient_details_state.dart';

class DoctorViewPatientDetailsBloc
    extends Bloc<DoctorViewPatientDetailsEvent, DoctorViewPatientDetailsState> {
  DoctorViewPatientDetailsBloc() : super(DoctorViewPatientDetailsInitial()) {
    on<DoctorViewPatientDetailsFetchRequestedEvent>(
        doctorViewPatientDetailsFetchRequestedEvent);
  }

  FutureOr<void> doctorViewPatientDetailsFetchRequestedEvent(
      DoctorViewPatientDetailsFetchRequestedEvent event,
      Emitter<DoctorViewPatientDetailsState> emit) {
    emit(DoctorViewPatientDetailsInitial());
  }
}
