import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/1_controllers/doctor_profile_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_schedule_management/0_models/doctor_schedule_management.dart';
import 'package:gina_app_4/features/doctor_features/doctor_schedule_management/1_controllers/doctor_schedule_controller.dart';

part 'doctor_schedule_management_event.dart';
part 'doctor_schedule_management_state.dart';

DoctorModel? currentActiveDoctor;

class DoctorScheduleManagementBloc
    extends Bloc<DoctorScheduleManagementEvent, DoctorScheduleManagementState> {
  final DoctorProfileController doctorProfileController;
  final DoctorScheduleController doctorScheduleController;
  DoctorScheduleManagementBloc({
    required this.doctorProfileController,
    required this.doctorScheduleController,
  }) : super(DoctorScheduleManagementInitial()) {
    on<DoctorScheduleManagementInitialEvent>(scheduleFetchRequestedEvent);
    on<ToggleScheduleEditModeEvent>(toggleScheduleEditModeEvent);
    on<ToggleTimeSlotEvent>(toggleTimeSlotEvent);
  }

  FutureOr<void> scheduleFetchRequestedEvent(
      DoctorScheduleManagementInitialEvent event,
      Emitter<DoctorScheduleManagementState> emit) async {
    emit(GetScheduleLoadingState());

    // Clean up expired disabled slots
    await doctorScheduleController.cleanupExpiredDisabledSlots();

    final doctorDetails = await doctorProfileController.getDoctorProfile();
    doctorDetails.fold(
      (failure) {
        emit(GetScheduledFailedState(message: failure.toString()));
      },
      (doctor) {
        currentActiveDoctor = doctor;
      },
    );

    final result = await doctorScheduleController.getDoctorSchedule();

    result.fold(
      (failure) {
        emit(GetScheduledFailedState(message: failure.toString()));
      },
      (schedule) {
        emit(GetScheduleSuccessState(schedule: schedule));
      },
    );
  }

  FutureOr<void> toggleScheduleEditModeEvent(ToggleScheduleEditModeEvent event,
      Emitter<DoctorScheduleManagementState> emit) {
    if (event.isEditing) {
      // Entering edit mode
      if (state is GetScheduleSuccessState) {
        emit(EditScheduleState(
            isEditing: true,
            schedule: (state as GetScheduleSuccessState).schedule));
      }
    } else {
      // Exiting edit mode, return to success state
      if (state is EditScheduleState) {
        emit(GetScheduleSuccessState(
            schedule: (state as EditScheduleState).schedule));
      }
    }
  }

  FutureOr<void> toggleTimeSlotEvent(ToggleTimeSlotEvent event,
      Emitter<DoctorScheduleManagementState> emit) async {
    if (state is EditScheduleState) {
      final currentState = state as EditScheduleState;
      final currentSchedule = currentState.schedule;

      debugPrint(
          'Before toggle: ${currentState.schedule.disabledTimeSlots?.length} disabled slots');

      final result = await doctorScheduleController.toggleTimeSlot(
        day: event.day,
        startTime: event.startTime,
        endTime: event.endTime,
        disable: event.disable,
        currentSchedule: currentSchedule,
      );

      result.fold(
        (failure) {
          // Handle failure if needed
          debugPrint('Failed to toggle time slot: ${failure.toString()}');
        },
        (updatedSchedule) {
          // Update the state with the new schedule
          debugPrint(
              'After toggle: ${updatedSchedule.disabledTimeSlots?.length} disabled slots');
          emit(EditScheduleState(
            isEditing: true,
            schedule: updatedSchedule,
          ));
        },
      );
    }
  }
}
