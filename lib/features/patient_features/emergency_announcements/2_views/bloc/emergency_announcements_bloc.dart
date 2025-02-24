import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/0_model/emergency_announcements_model.dart';
import 'package:gina_app_4/features/patient_features/emergency_announcements/1_controllers/emergency_announcement_controllers.dart';

part 'emergency_announcements_event.dart';
part 'emergency_announcements_state.dart';

String? doctorMedicalSpecialty;

class EmergencyAnnouncementsBloc
    extends Bloc<EmergencyAnnouncementsEvent, EmergencyAnnouncementsState> {
  final EmergencyAnnouncementsController emergencyController;
  EmergencyAnnouncementsBloc({
    required this.emergencyController,
  }) : super(EmergencyAnnouncementsInitial()) {
    on<GetEmergencyAnnouncements>(getEmergencyAnnouncements);
  }

  FutureOr<void> getEmergencyAnnouncements(GetEmergencyAnnouncements event,
      Emitter<EmergencyAnnouncementsState> emit) async {
    emit(EmergencyAnnouncementsLoading());

    final emergencyAnnouncements =
        await emergencyController.getNearestEmergencyAnnouncement();

    emergencyAnnouncements.fold(
      (error) => emit(EmergencyAnnouncementsError(error.toString())),
      (emergencyAnnouncement) {
        debugPrint('Fetched emergency announcement: $emergencyAnnouncement');
        emit(EmergencyAnnouncementsLoaded(
          emergencyAnnouncement: emergencyAnnouncement,
          doctorMedicalSpecialty: doctorMedicalSpecialty ?? '',
        ));
      },
    );
  }
}
