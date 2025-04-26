import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/0_model/emergency_announcements_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/1_controllers/appointment_controller.dart';
import 'package:gina_app_4/features/patient_features/emergency_announcements/1_controllers/emergency_announcement_controllers.dart';

part 'emergency_announcements_event.dart';
part 'emergency_announcements_state.dart';

String? doctorMedicalSpecialty;

class EmergencyAnnouncementsBloc
    extends Bloc<EmergencyAnnouncementsEvent, EmergencyAnnouncementsState> {
  final EmergencyAnnouncementsController emergencyController;
  final AppointmentController appointmentController;
  StreamSubscription? _emergencySubscription;
  EmergencyAnnouncementsBloc({
    required this.emergencyController,
    required this.appointmentController,
  }) : super(EmergencyAnnouncementsInitial()) {
    on<GetEmergencyAnnouncements>(getEmergencyAnnouncements);
    on<EmergencyNotificationReceivedEvent>(onEmergencyNotificationReceived);
    on<MarkAnnouncementAsClickedEvent>(onMarkAnnouncementAsClicked);

    listenForEmergencies();
  }

  void listenForEmergencies() {
    _emergencySubscription?.cancel();

    _emergencySubscription = emergencyController
        .listenForEmergencyAnnouncements()
        .listen((announcement) {
      add(EmergencyNotificationReceivedEvent(announcement));
    });
  }

  @override
  Future<void> close() {
    _emergencySubscription?.cancel();
    return super.close();
  }

  FutureOr<void> getEmergencyAnnouncements(GetEmergencyAnnouncements event,
      Emitter<EmergencyAnnouncementsState> emit) async {
    emit(EmergencyAnnouncementsLoading());

    final emergencyAnnouncements =
        await emergencyController.getEmergencyAnnouncements();

    emergencyAnnouncements.fold(
      (error) => emit(EmergencyAnnouncementsError(error.toString())),
      (emergencyAnnouncements) {
        debugPrint('Fetched emergency announcement: $emergencyAnnouncements');
        emit(EmergencyAnnouncementsLoaded(
          emergencyAnnouncements: emergencyAnnouncements,
          doctorMedicalSpecialty: doctorMedicalSpecialty ?? '',
        ));
      },
    );
  }

  Future<bool> isCompletedAppointment(String appointmentUid) async {
    final result = await appointmentController.getAppointmentDetails(
        appointmentUid: appointmentUid);

    return result.fold(
      (failure) => false,
      (appointment) =>
          appointment.appointmentStatus == AppointmentStatus.completed.index ||
          appointment.appointmentStatus == 2,
    );
  }

  FutureOr<void> onEmergencyNotificationReceived(
      EmergencyNotificationReceivedEvent event,
      Emitter<EmergencyAnnouncementsState> emit) {
    emit(EmergencyNotificationReceivedState(event.announcement));
  }

  FutureOr<void> onMarkAnnouncementAsClicked(
    MarkAnnouncementAsClickedEvent event,
    Emitter<EmergencyAnnouncementsState> emit,
  ) async {
    debugPrint('📣 BLOC: onMarkAnnouncementAsClicked called');
    debugPrint('📣 BLOC: emergencyId = ${event.emergencyId}');
    debugPrint('📣 BLOC: patientUid = ${event.patientUid}');

    try {
      debugPrint('📣 BLOC: Calling controller.markAnnouncementAsClicked...');
      await emergencyController.markAnnouncementAsClicked(
        emergencyId: event.emergencyId,
        patientUid: event.patientUid,
      );
      debugPrint('📣 BLOC: Controller method completed successfully');

      // Optionally emit a success state or refresh announcements
      // emit(AnnouncementMarkedAsClickedState(event.emergencyId, event.patientUid));

      // Refresh the announcements list to show updated status
      add(GetEmergencyAnnouncements());
    } catch (e) {
      debugPrint('❌ BLOC ERROR: Error marking announcement as clicked: $e');

      // Optionally emit an error state
      // emit(EmergencyAnnouncementsError('Failed to mark announcement as clicked: $e'));
    }
  }
}
