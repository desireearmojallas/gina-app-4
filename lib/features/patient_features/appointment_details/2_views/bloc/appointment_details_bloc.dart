import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/reschedule_appointment_success.dart';
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
    on<FetchLatestAppointmentDetailsEvent>(fetchLatestAppointmentDetailsEvent);
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

    try {
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
    } catch (e) {
      if (e.toString().contains('failed-precondition')) {
        emit(const AppointmentDetailsError(
            errorMessage:
                'The query requires an index. Please create the required index in the Firebase console.'));
      } else {
        emit(AppointmentDetailsError(errorMessage: e.toString()));
      }
    }
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
    emit(AppointmentDetailsLoading());

    final result = await appointmentController.rescheduleAppointment(
      appointmentUid: event.appointmentUid,
      appointmentDate: event.appointmentDate,
      appointmentTime: event.appointmentTime,
      reasonForAppointment: event.reasonForAppointment,
    );

    result.fold(
      (failure) {
        emit(AppointmentDetailsError(errorMessage: failure.toString()));
      },
      (success) {
        if (storedAppointment != null) {
          emit(AppointmentDetailsStatusState(
            appointment: storedAppointment!.copyWith(
              appointmentDate: event.appointmentDate,
              appointmentTime: event.appointmentTime,
              appointmentStatus: 0, // Reset to pending
              reasonForAppointment: event.reasonForAppointment,
            ),
          ));
        } else {
          emit(
            const AppointmentDetailsError(
              errorMessage: "Appointment data not found",
            ),
          );
        }
      },
    );
  }

  FutureOr<void> navigateToReviewRescheduledAppointmentEvent(
      NavigateToReviewRescheduledAppointmentEvent event,
      Emitter<AppointmentDetailsState> emit) async {
    debugPrint('NavigateToReviewRescheduledAppointmentEvent triggered');
    // emit(NavigateToReviewRescheduledLoadingState());

    final appointment = await appointmentController.getAppointmentDetails(
        appointmentUid: event.appointmentUid);

    await appointment.fold(
      (failure) async {
        debugPrint('Failed to fetch appointment details: $failure');
        emit(RescheduleAppointmentError(errorMessage: failure.toString()));
      },
      (appointment) async {
        storedAppointment = appointment;
        debugPrint('Fetched appointment: $appointment');
        debugPrint('Current patient: $currentActivePatient');
        debugPrint('Doctor: $doctorDetails');

        if (doctorDetails != null && currentActivePatient != null) {
          debugPrint('Emitting NavigateToReviewRescheduledAppointmentState');
          emit(
            NavigateToReviewRescheduledAppointmentState(
              doctor: doctorDetails!,
              patient: currentActivePatient!,
              appointment: appointment,
            ),
          );
          debugPrint('NavigateToReviewRescheduledAppointmentState emitted');
        } else {
          debugPrint('Doctor or Patient data is missing, cannot navigate');
          emit(RescheduleAppointmentError(
              errorMessage: "Doctor or Patient data is missing"));
        }
      },
    );
  }

  FutureOr<void> fetchLatestAppointmentDetailsEvent(
      FetchLatestAppointmentDetailsEvent event,
      Emitter<AppointmentDetailsState> emit) async {
    try {
      final appointmentDetails = await appointmentController
          .getAppointmentDetails(appointmentUid: event.appointmentUid);

      await appointmentDetails.fold(
        (failure) async {
          debugPrint('Failed to fetch latest appointment details: $failure');
          emit(AppointmentDetailsError(errorMessage: failure.toString()));
        },
        (appointment) async {
          debugPrint('Fetched latest appointment details: $appointment');
          emit(LatestAppointmentDetailsFetchedState(appointment: appointment));
        },
      );
    } catch (e) {
      debugPrint(
          'Exception occurred in fetchLatestAppointmentDetailsEvent: $e');
      emit(AppointmentDetailsError(errorMessage: e.toString()));
    }
  }

  bool isAppointmentInPast(
    AppointmentModel appointment,
  ) {
    final DateFormat dateFormat = DateFormat('MMMM d, yyyy');
    final DateFormat timeFormat = DateFormat('hh:mm a');
    final DateTime now = DateTime.now();

    // Parse appointment date
    final DateTime appointmentDate =
        dateFormat.parse(appointment.appointmentDate!);

    // Parse appointment start time
    final String startTimeString =
        appointment.appointmentTime?.split(' - ')[0] ?? '';
    final DateTime startTime = timeFormat.parse(startTimeString);

    // Combine date and time
    final DateTime appointmentDateTime = DateTime(
      appointmentDate.year,
      appointmentDate.month,
      appointmentDate.day,
      startTime.hour,
      startTime.minute,
    );

    // Allow rescheduling up to 30 minutes before the start time
    final DateTime rescheduleDeadline =
        appointmentDateTime.subtract(const Duration(minutes: 30));

    // Compare with current date and time
    return now.isAfter(rescheduleDeadline);
  }

  bool canReschedule(
    AppointmentDetailsBloc appointmentDetailsBloc,
    appointment,
  ) {
    return appointment.appointmentStatus == AppointmentStatus.confirmed.index &&
        appointmentDetailsBloc.isAppointmentInPast(appointment);
  }
}
