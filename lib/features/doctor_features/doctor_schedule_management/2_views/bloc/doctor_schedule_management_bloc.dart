import 'dart:async';

import 'package:equatable/equatable.dart';
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
  }

  FutureOr<void> scheduleFetchRequestedEvent(
      DoctorScheduleManagementInitialEvent event,
      Emitter<DoctorScheduleManagementState> emit) async {
    emit(GetScheduleLoadingState());

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
}
