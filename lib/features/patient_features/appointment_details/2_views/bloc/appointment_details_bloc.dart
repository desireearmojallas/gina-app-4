import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/1_controllers/appointment_controller.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:gina_app_4/features/patient_features/profile/1_controllers/profile_controller.dart';
import 'package:intl/intl.dart';

part 'appointment_details_event.dart';
part 'appointment_details_state.dart';

bool isRescheduleMode = false;
AppointmentModel? storedAppointment;

class AppointmentDetailsBloc
    extends Bloc<AppointmentDetailsEvent, AppointmentDetailsState> {
  final AppointmentController appointmentController;
  final ProfileController profileController;
  AppointmentDetailsBloc({
    required this.appointmentController,
    required this.profileController,
  }) : super(AppointmentDetailsInitial()) {
    on<NavigateToAppointmentDetailsStatusEvent>(
        navigateToAppointmentDetailsStatusEvent);
    on<CancelAppointmentEvent>(cancelAppointmentEvent);
    on<RescheduleAppointmentEvent>(rescheduleAppointmentEvent);
    on<NavigateToReviewRescheduledAppointmentEvent>(
        navigateToReviewRescheduledAppointmentEvent);
  }

  FutureOr<void> navigateToAppointmentDetailsStatusEvent(
      NavigateToAppointmentDetailsStatusEvent event,
      Emitter<AppointmentDetailsState> emit) async {
    final getProfileData = await profileController.getPatientProfile();

    getProfileData.fold(
      (failure) {},
      (patientData) {
        currentActivePatient = patientData;
      },
    );

    final result = await appointmentController.getRecentPatientAppointment(
        doctorUid: doctorDetails!.uid);

    result.fold(
      (failure) {
        emit(AppointmentDetailsError(errorMessage: failure.toString()));
      },
      (appointment) {
        storedAppointmentUid = appointment.appointmentUid ?? '';
        emit(AppointmentDetailsStatusState(appointment: appointment));
      },
    );
  }

  FutureOr<void> cancelAppointmentEvent(CancelAppointmentEvent event,
      Emitter<AppointmentDetailsState> emit) async {
    emit(CancelAppointmentLoading());

    final result = await appointmentController.cancelAppointment(
        appointmentUid: event.appointmentUid);

    result.fold(
      (failure) {
        emit(CancelAppointmentError(errorMessage: failure.toString()));
      },
      (appointment) {
        emit(CancelAppointmentState());
      },
    );
  }

  FutureOr<void> rescheduleAppointmentEvent(RescheduleAppointmentEvent event,
      Emitter<AppointmentDetailsState> emit) async {
    emit(RescheduleAppointmentLoading());

    String dateString = event.appointmentDate;
    DateTime parsedDate = DateFormat('EEEE, d of MMMM yyyy').parse(dateString);
    String reformattedDate = DateFormat('MMMM d, yyyy').format(parsedDate);

    final result = await appointmentController.rescheduleAppointment(
      appointmentUid: event.appointmentUid,
      appointmentDate: reformattedDate,
      appointmentTime: event.appointmentTime,
      modeOfAppointment: event.modeOfAppointment,
    );

    result.fold(
      (failure) {
        emit(RescheduleAppointmentError(errorMessage: failure.toString()));
      },
      (appointment) {
        emit(RescheduleAppointmentState());
      },
    );
  }

  FutureOr<void> navigateToReviewRescheduledAppointmentEvent(
      NavigateToReviewRescheduledAppointmentEvent event,
      Emitter<AppointmentDetailsState> emit) async {
    debugPrint('NavigateToReviewRescheduledAppointmentEvent triggered');
    emit(NavigateToReviewRescheduledLoadingState());

    final appointment = await appointmentController.getAppointmentDetails(
        appointmentUid: event.appointmentUid);

    appointment.fold(
      (failure) {
        emit(RescheduleAppointmentError(errorMessage: failure.toString()));
      },
      (appointment) {
        storedAppointment = appointment;
        debugPrint('Current patient: $currentActivePatient');
        debugPrint('Emitting NavigateToReviewRescheduledAppointmentState');
        emit(
          NavigateToReviewRescheduledAppointmentState(
            doctor: doctorDetails!,
            patient: currentActivePatient!,
            appointment: storedAppointment!,
          ),
        );
        debugPrint('NavigateToReviewRescheduledAppointmentState emitted');
      },
    );
    debugPrint('Doctor: $doctorDetails');
    debugPrint('Patient: $currentActivePatient');
    debugPrint('Appointment: $storedAppointment');
  }
}
