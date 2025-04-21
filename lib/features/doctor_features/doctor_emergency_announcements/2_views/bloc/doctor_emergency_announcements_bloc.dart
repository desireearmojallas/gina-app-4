import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
    on<SelectPatientsEvent>(selectPatientsEvent);
    on<NavigateToDoctorCreatedAnnouncementEvent>(
        navigateToDoctorCreatedAnnouncementEvent);
    on<CreateEmergencyAnnouncementEvent>(createEmergencyAnnouncementEvent);
    on<DeleteEmergencyAnnouncementEvent>(deleteEmergencyAnnouncementEvent);
    on<AddPatientToSelectionEvent>(addPatientToSelectionEvent);
    on<RemovePatientFromSelectionEvent>(removePatientFromSelectionEvent);
  }

  FutureOr<void> getDoctorEmergencyAnnouncementsEvent(
      GetDoctorEmergencyAnnouncementsEvent event,
      Emitter<DoctorEmergencyAnnouncementsState> emit) async {
    emit(DoctorEmergencyAnnouncementsLoading());

    final emergencyAnnouncementsResult =
        await doctorEmergencyAnnouncementsController
            .getEmergencyAnnouncements();

    emergencyAnnouncementsResult.fold(
      (failure) {
        emit(DoctorEmergencyAnnouncementsError(
            errorMessage: failure.toString()));
      },
      (emergencyAnnouncements) {
        if (emergencyAnnouncements.isEmpty) {
          emit(DoctorEmergencyAnnouncementsEmpty());
          return;
        }

        // Sort the announcements by createdAt in descending order
        emergencyAnnouncements
            .sort((a, b) => b.createdAt.compareTo(a.createdAt));

        // Group the announcements by date
        final groupedAnnouncements =
            <DateTime, List<EmergencyAnnouncementModel>>{};
        for (var announcement in emergencyAnnouncements) {
          final createdAtDateTime = announcement.createdAt.toDate();
          final date = DateTime(createdAtDateTime.year, createdAtDateTime.month,
              createdAtDateTime.day);
          if (groupedAnnouncements.containsKey(date)) {
            groupedAnnouncements[date]!.add(announcement);
          } else {
            groupedAnnouncements[date] = [announcement];
          }
        }

        emit(DoctorEmergencyAnnouncementsLoaded(
          emergencyAnnouncements: groupedAnnouncements,
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

  FutureOr<void> selectPatientsEvent(SelectPatientsEvent event,
      Emitter<DoctorEmergencyAnnouncementsState> emit) {
    debugPrint(
        '🚀 selectPatientsEvent called with ${event.selectedAppointments.length} appointments');

    // Print details of each selected appointment
    for (int i = 0; i < event.selectedAppointments.length; i++) {
      final appointment = event.selectedAppointments[i];
      debugPrint(
          '📋 Selected patient #${i + 1}: ${appointment.patientName} (ID: ${appointment.appointmentUid})');
    }

    debugPrint('📊 Current state before emission: ${state.runtimeType}');

    // Emit the new state
    emit(SelectedPatientsState(
        selectedAppointments: event.selectedAppointments));

    debugPrint(
        '✅ Emitted SelectedPatientsState with ${event.selectedAppointments.length} appointments');
    debugPrint(
        '🔄 Next navigation step should be to return to create announcement screen');
  }

  FutureOr<void> navigateToDoctorCreatedAnnouncementEvent(
      NavigateToDoctorCreatedAnnouncementEvent event,
      Emitter<DoctorEmergencyAnnouncementsState> emit) async {
    final appointment = await doctorEmergencyAnnouncementsController
        .getChosenAppointment(event.appointmentUid);

    chosenAppointment = appointment.fold(
      (failure) {
        emit(DoctorEmergencyAnnouncementsError(
            errorMessage: failure.toString()));
        return null;
      },
      (appointment) {
        return appointment;
      },
    );

    emit(NavigateToDoctorCreatedAnnouncementState(
      emergencyAnnouncement: event.emergencyAnnouncement,
    ));
  }

  FutureOr<void> createEmergencyAnnouncementEvent(
      CreateEmergencyAnnouncementEvent event,
      Emitter<DoctorEmergencyAnnouncementsState> emit) async {
    debugPrint('Emitting CreateAnnouncementLoadingState');

    // Get the current state BEFORE emitting the loading state
    final currentState = state;

    emit(CreateAnnouncementLoadingState());

    List<AppointmentModel> selectedAppointments = [];

    // Check the stored current state
    if (currentState is SelectedPatientsState) {
      selectedAppointments = currentState.selectedAppointments;
      debugPrint(
          'Found ${selectedAppointments.length} selected appointments in state');
    }
    // Use all appointments from the event (important fix!)
    else if (event.appointments.isNotEmpty) {
      debugPrint('Using ${event.appointments.length} appointments from event');
      selectedAppointments = event.appointments;
    } else if (event.appointment != null) {
      // Fallback for backwards compatibility
      debugPrint('Using single appointment from event');
      selectedAppointments = [event.appointment!];
    } else {
      debugPrint('No appointments found, emitting error');
      emit(const DoctorEmergencyAnnouncementsError(
          errorMessage: "Invalid appointment selected"));
      return;
    }

    if (selectedAppointments.isEmpty) {
      debugPrint('No appointments selected, emitting error');
      emit(const DoctorEmergencyAnnouncementsError(
          errorMessage: "No patients selected"));
      return;
    }

    // Extract patient UIDs and names
    List<String> patientUids =
        selectedAppointments.map((a) => a.patientUid!).toList();
    List<String> patientNames =
        selectedAppointments.map((a) => a.patientName!).toList();

    // Extract appointment UIDs
    List<String> appointmentUids =
        selectedAppointments.map((a) => a.appointmentUid!).toList();

    // Use the first appointment's UID as the appointmentUid (for backward compatibility)
    String appointmentUid = selectedAppointments.first.appointmentUid!;

    debugPrint('Creating emergency announcement with:');
    debugPrint('- Appointment UID: $appointmentUid');
    debugPrint('- Appointment UIDs: $appointmentUids');
    debugPrint('- Patient UIDs: $patientUids');
    debugPrint('- Patient Names: $patientNames');
    debugPrint('- Message: ${event.message}');

    // Create a single emergency announcement for all selected patients
    final createEmergencyAnnouncement =
        await doctorEmergencyAnnouncementsController
            .createEmergencyAnnouncement(
      appointmentUid: appointmentUid,
      appointmentUids: appointmentUids,
      patientUids: patientUids,
      emergencyMessage: event.message,
      patientNames: patientNames,
    );

    createEmergencyAnnouncement.fold(
      (failure) {
        debugPrint(
            'Failed to create emergency announcement: ${failure.toString()}');
        emit(DoctorEmergencyAnnouncementsError(
            errorMessage: failure.toString()));
      },
      (success) {
        debugPrint('Successfully created emergency announcement');
        emit(CreateEmergencyAnnouncementPostSuccessState());
      },
    );
  }

  Future<void> deleteEmergencyAnnouncementEvent(
      DeleteEmergencyAnnouncementEvent event,
      Emitter<DoctorEmergencyAnnouncementsState> emit) async {
    emit(DoctorEmergencyAnnouncementsLoading());

    try {
      final deleteEmergencyAnnouncement =
          await doctorEmergencyAnnouncementsController
              .deleteEmergencyAnnouncement(event.emergencyAnnouncement);

      await deleteEmergencyAnnouncement.fold(
        (failure) async {
          emit(DoctorEmergencyAnnouncementsError(
              errorMessage: failure.toString()));
        },
        (success) async {
          try {
            final emergencyAnnouncements =
                await doctorEmergencyAnnouncementsController
                    .getEmergencyAnnouncements();

            await emergencyAnnouncements.fold(
              (failure) async {
                emit(DoctorEmergencyAnnouncementsError(
                    errorMessage: failure.toString()));
              },
              (emergencyAnnouncements) async {
                if (emergencyAnnouncements.isEmpty) {
                  emit(DoctorEmergencyAnnouncementsEmpty());
                  return;
                }

                // Sort the announcements by createdAt in descending order
                emergencyAnnouncements
                    .sort((a, b) => b.createdAt.compareTo(a.createdAt));

                // Group the announcements by date
                final groupedAnnouncements =
                    <DateTime, List<EmergencyAnnouncementModel>>{};
                for (var announcement in emergencyAnnouncements) {
                  final createdAtDateTime = announcement.createdAt.toDate();
                  final date = DateTime(createdAtDateTime.year,
                      createdAtDateTime.month, createdAtDateTime.day);
                  if (groupedAnnouncements.containsKey(date)) {
                    groupedAnnouncements[date]!.add(announcement);
                  } else {
                    groupedAnnouncements[date] = [announcement];
                  }
                }

                emit(DoctorEmergencyAnnouncementsLoaded(
                  emergencyAnnouncements: groupedAnnouncements,
                ));
              },
            );
          } catch (e) {
            emit(DoctorEmergencyAnnouncementsError(errorMessage: e.toString()));
          }
        },
      );
    } catch (e) {
      emit(DoctorEmergencyAnnouncementsError(errorMessage: e.toString()));
    }
  }

  FutureOr<void> addPatientToSelectionEvent(AddPatientToSelectionEvent event,
      Emitter<DoctorEmergencyAnnouncementsState> emit) {
    debugPrint(
        'addPatientToSelectionEvent called for patient: ${event.appointment.patientName}');
    debugPrint('Current state type: ${state.runtimeType}');
    List<AppointmentModel> updatedSelection = [];

    // If we already have selected patients, add to that list
    if (state is SelectedPatientsState) {
      debugPrint('Current state is SelectedPatientsState');
      updatedSelection =
          List.from((state as SelectedPatientsState).selectedAppointments);
      debugPrint('Current selection count: ${updatedSelection.length}');
      debugPrint('Current selection:');
      for (var appointment in updatedSelection) {
        debugPrint(
            '- ${appointment.patientName} (ID: ${appointment.appointmentUid})');
      }

      // Check if this patient is already in the list
      bool alreadySelected = updatedSelection.any((appointment) =>
          appointment.appointmentUid == event.appointment.appointmentUid);

      // Only add if not already selected
      if (!alreadySelected) {
        debugPrint('Adding patient to selection');
        updatedSelection.add(event.appointment);
      } else {
        debugPrint('Patient already in selection, not adding again');
      }
    } else {
      // First selection or state is not SelectedPatientsState
      debugPrint('Creating new selection list');
      updatedSelection = [event.appointment];
    }

    debugPrint(
        'Emitting SelectedPatientsState with ${updatedSelection.length} patients');
    for (var appointment in updatedSelection) {
      debugPrint(
          '- ${appointment.patientName} (ID: ${appointment.appointmentUid})');
    }

    // Emit the new state and navigate to the create announcement screen
    emit(SelectedPatientsState(selectedAppointments: updatedSelection));
  }

  FutureOr<void> removePatientFromSelectionEvent(
      RemovePatientFromSelectionEvent event,
      Emitter<DoctorEmergencyAnnouncementsState> emit) {
    debugPrint(
        'removePatientFromSelectionEvent called for patient: ${event.appointment.patientName}');
    debugPrint('Current state type: ${state.runtimeType}');

    // Only proceed if we're in the SelectedPatientsState
    if (state is SelectedPatientsState) {
      debugPrint('Current state is SelectedPatientsState');
      List<AppointmentModel> updatedSelection =
          List.from((state as SelectedPatientsState).selectedAppointments);
      debugPrint(
          'Current selection count before removal: ${updatedSelection.length}');
      debugPrint('Current selection before removal:');
      for (var appointment in updatedSelection) {
        debugPrint(
            '- ${appointment.patientName} (ID: ${appointment.appointmentUid})');
      }

      // Remove the appointment with matching ID
      updatedSelection.removeWhere((appointment) =>
          appointment.appointmentUid == event.appointment.appointmentUid);

      debugPrint('Selection count after removal: ${updatedSelection.length}');
      debugPrint(
          'Emitting SelectedPatientsState with ${updatedSelection.length} patients');
      for (var appointment in updatedSelection) {
        debugPrint(
            '- ${appointment.patientName} (ID: ${appointment.appointmentUid})');
      }

      emit(SelectedPatientsState(selectedAppointments: updatedSelection));
    } else {
      debugPrint(
          'Current state is not SelectedPatientsState, cannot remove patient');
    }
  }
}
