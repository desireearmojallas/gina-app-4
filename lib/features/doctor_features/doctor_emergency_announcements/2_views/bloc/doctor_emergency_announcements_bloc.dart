import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/0_model/emergency_announcements_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/1_controller/doctor_emergency_announcements_controller.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

part 'doctor_emergency_announcements_event.dart';
part 'doctor_emergency_announcements_state.dart';

class DoctorEmergencyAnnouncementsBloc extends Bloc<
    DoctorEmergencyAnnouncementsEvent, DoctorEmergencyAnnouncementsState> {
  final DoctorEmergencyAnnouncementsController
      doctorEmergencyAnnouncementsController;
  DoctorEmergencyAnnouncementsBloc({
    required this.doctorEmergencyAnnouncementsController,
  }) : super(DoctorEmergencyAnnouncementsInitial()) {
    on<GetDoctorEmergencyAnnouncementsEvent>(
        getDoctorEmergencyAnnouncementsEvent);
    on<NavigateToDoctorEmergencyCreateAnnouncementEvent>(
        navigateToDoctorEmergencyCreateAnnouncementEvent);
    on<NavigateToPatientList>(navigateToPatientList);
    on<SelectPatientEvent>(selectPatientEvent);
    on<NavigateToDoctorCreatedAnnouncementEvent>(
        navigateToDoctorCreatedAnnouncementEvent);
    on<CreateEmergencyAnnouncementEvent>(createEmergencyAnnouncementEvent);
    on<DeleteEmergencyAnnouncementEvent>(deleteEmergencyAnnouncementEvent);
  }

  FutureOr<void> getDoctorEmergencyAnnouncementsEvent(
      GetDoctorEmergencyAnnouncementsEvent event,
      Emitter<DoctorEmergencyAnnouncementsState> emit) async {
    emit(DoctorEmergencyAnnouncementsLoading());

    final emergencyAnnouncements = await doctorEmergencyAnnouncementsController
        .getEmergencyAnnouncements();

    emergencyAnnouncements.fold(
      (failure) {
        emit(DoctorEmergencyAnnouncementsError(
            errorMessage: failure.toString()));
      },
      (emergencyAnnouncements) {
        // Sort the announcements by createdAt in descending order
        emergencyAnnouncements
            .sort((a, b) => b.createdAt.compareTo(a.createdAt));

        emit(DoctorEmergencyAnnouncementsLoaded(
          emergencyAnnouncements: emergencyAnnouncements,
        ));
      },
    );
  }

  FutureOr<void> navigateToDoctorEmergencyCreateAnnouncementEvent(
      NavigateToDoctorEmergencyCreateAnnouncementEvent event,
      Emitter<DoctorEmergencyAnnouncementsState> emit) {
    emit(CreateAnnouncementState());
  }

  FutureOr<void> navigateToPatientList(NavigateToPatientList event,
      Emitter<DoctorEmergencyAnnouncementsState> emit) async {
    emit(DoctorEmergencyAnnouncementsLoading());

    final patientList = await doctorEmergencyAnnouncementsController
        .getConfirmedDoctorAppointmentRequest();

    patientList.fold(
      (failure) {
        emit(DoctorEmergencyAnnouncementsError(
            errorMessage: failure.toString()));
      },
      (approvedPatientList) {
        emit(DoctorEmergencyGetApprovedPatientList(
          approvedPatientList: approvedPatientList,
        ));
      },
    );
  }

  FutureOr<void> selectPatientEvent(SelectPatientEvent event,
      Emitter<DoctorEmergencyAnnouncementsState> emit) async {
    emit(SelectedAPatientState(appointment: event.appointment));
  }

  FutureOr<void> navigateToDoctorCreatedAnnouncementEvent(
      NavigateToDoctorCreatedAnnouncementEvent event,
      Emitter<DoctorEmergencyAnnouncementsState> emit) {
    emit(NavigateToDoctorCreatedAnnouncementState(
      emergencyAnnouncement: event.emergencyAnnouncement,
    ));
  }

  FutureOr<void> createEmergencyAnnouncementEvent(
      CreateEmergencyAnnouncementEvent event,
      Emitter<DoctorEmergencyAnnouncementsState> emit) async {
    final createEmergencyAnnouncement =
        await doctorEmergencyAnnouncementsController
            .createEmergencyAnnouncement(
      appointmentUid: event.appointment.appointmentUid!,
      patientUid: event.appointment.appointmentUid!,
      emergencyMessage: event.message,
      patientName: event.appointment.patientName!,
    );

    createEmergencyAnnouncement.fold(
      (failure) {
        emit(DoctorEmergencyAnnouncementsError(
            errorMessage: failure.toString()));
      },
      (success) {
        emit(CreateEmergencyAnnouncementPostSuccessState());
      },
    );
  }

  Future<void> deleteEmergencyAnnouncementEvent(
      DeleteEmergencyAnnouncementEvent event,
      Emitter<DoctorEmergencyAnnouncementsState> emit) async {
    emit(DoctorEmergencyAnnouncementsLoading());

    final deleteEmergencyAnnouncement =
        await doctorEmergencyAnnouncementsController
            .deleteEmergencyAnnouncement(event.emergencyAnnouncement);

    deleteEmergencyAnnouncement.fold(
      (failure) {
        emit(DoctorEmergencyAnnouncementsError(
            errorMessage: failure.toString()));
      },
      (success) async {
        final emergencyAnnouncements =
            await doctorEmergencyAnnouncementsController
                .getEmergencyAnnouncements();
        emergencyAnnouncements.fold(
          (failure) {
            emit(DoctorEmergencyAnnouncementsError(
                errorMessage: failure.toString()));
          },
          (emergencyAnnouncements) {
            if (!emit.isDone) {
              emit(DoctorEmergencyAnnouncementsLoaded(
                emergencyAnnouncements: emergencyAnnouncements,
              ));
            }
          },
        );
      },
    );
  }
}
