import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctor_details_event.dart';
part 'doctor_details_state.dart';

class DoctorDetailsBloc extends Bloc<DoctorDetailsEvent, DoctorDetailsState> {
  DoctorDetailsBloc() : super(DoctorDetailsInitial()) {
    on<DoctorDetailsFetchRequestedEvent>(doctorDetailsFetchRequestedEvent);
    on<DoctorDetailsNavigateToConsultationEvent>(
        doctorDetailsNavigateToConsultationEvent);
  }

  FutureOr<void> doctorDetailsFetchRequestedEvent(
      DoctorDetailsFetchRequestedEvent event,
      Emitter<DoctorDetailsState> emit) {
    emit(DoctorDetailsLoaded());
  }

  FutureOr<void> doctorDetailsNavigateToConsultationEvent(
      DoctorDetailsNavigateToConsultationEvent event,
      Emitter<DoctorDetailsState> emit) {
    emit(DoctorDetailsNavigateToConsultationState());
  }
}
