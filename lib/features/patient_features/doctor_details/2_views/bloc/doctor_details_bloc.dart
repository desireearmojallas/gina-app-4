import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/1_controllers/appointment_controller.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';

part 'doctor_details_event.dart';
part 'doctor_details_state.dart';

class DoctorDetailsBloc extends Bloc<DoctorDetailsEvent, DoctorDetailsState> {
  final AppointmentController appointmentController;
  DoctorDetailsBloc({
    required this.appointmentController,
  }) : super(DoctorDetailsInitial()) {
    on<DoctorDetailsFetchRequestedEvent>(doctorDetailsFetchRequestedEvent);
    on<DoctorDetailsNavigateToConsultationEvent>(
        doctorDetailsNavigateToConsultationEvent);
    on<NavigateToDoctorOfficeAddressMapViewEvent>(
        navigateToDoctorOfficeAddressMapView);
  }

  FutureOr<void> doctorDetailsFetchRequestedEvent(
      DoctorDetailsFetchRequestedEvent event,
      Emitter<DoctorDetailsState> emit) async {
    final result = await appointmentController.getRecentPatientAppointment(
      doctorUid: doctorDetails!.uid,
    );

    result.fold(
      (failure) {},
      (appointment) {
        appointmentForNearbyDocLatestAppointment = appointment;
      },
    );
    emit(DoctorDetailsLoaded());
  }

  FutureOr<void> doctorDetailsNavigateToConsultationEvent(
      DoctorDetailsNavigateToConsultationEvent event,
      Emitter<DoctorDetailsState> emit) {
    emit(DoctorDetailsNavigateToConsultationState());
  }

  FutureOr<void> navigateToDoctorOfficeAddressMapView(
      NavigateToDoctorOfficeAddressMapViewEvent event,
      Emitter<DoctorDetailsState> emit) {
    emit(DoctorOfficeAddressMapViewState());
  }
}
