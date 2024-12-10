import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/patient_features/doctor_availability/0_model/doctor_availability_model.dart';
import 'package:gina_app_4/features/patient_features/doctor_availability/1_controller/doctor_availability_controller.dart';

part 'doctor_availability_event.dart';
part 'doctor_availability_state.dart';

DoctorAvailabilityModel? storeDoctorAvailabilityModel;
final List<String> dayNames = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday'
];

final List<String> modeOfAppointment = [
  'Face-to-Face',
  'Online Consultation',
];

class DoctorAvailabilityBloc
    extends Bloc<DoctorAvailabilityEvent, DoctorAvailabilityState> {
  final DoctorAvailabilityController doctorAvailabilityController;
  DoctorAvailabilityBloc({
    required this.doctorAvailabilityController,
  }) : super(DoctorAvailabilityInitial()) {
    on<GetDoctorAvailabilityEvent>(getDoctorAvailabilityEvent);
  }

  FutureOr<void> getDoctorAvailabilityEvent(GetDoctorAvailabilityEvent event,
      Emitter<DoctorAvailabilityState> emit) async {
    emit(DoctorAvailabilityLoading());

    debugPrint('Get doctor availability event is triggered');

    final result = await doctorAvailabilityController.getDoctorAvailability(
        doctorId: event.doctorId);

    result.fold(
      (failure) {
        emit(DoctorAvailabilityError(errorMessage: failure.toString()));
      },
      (doctorAvailabilityModel) {
        storeDoctorAvailabilityModel = doctorAvailabilityModel;
        emit(DoctorAvailabilityLoaded(doctorAvailabilityModel));
      },
    );
  }

  String getDoctorAvailability(
      DoctorAvailabilityModel doctorAvailabilityModel) {
    if (doctorAvailabilityModel.days.isEmpty) {
      return 'Doctor is not available';
    }

    final String firstDay = dayNames[doctorAvailabilityModel.days.first];
    final String lastDay = dayNames[doctorAvailabilityModel.days.last];

    return '$firstDay to $lastDay';
  }

  List<String> getModeOfAppointment(
      DoctorAvailabilityModel doctorAvailabilityModel) {
    final List<String> modeOfAppointmentList = [];

    for (final mode in doctorAvailabilityModel.modeOfAppointment) {
      ModeOfAppointmentId modeOfAppointmentId =
          ModeOfAppointmentId.values[mode];

      switch (modeOfAppointmentId) {
        case ModeOfAppointmentId.onlineConsultation:
          modeOfAppointmentList.add('Online Consultation');

          break;
        case ModeOfAppointmentId.faceToFaceConsultation:
          modeOfAppointmentList.add('Face-to-Face');
        default:
          modeOfAppointmentList.add('Unknown');
      }
    }

    return modeOfAppointmentList;
  }
}
