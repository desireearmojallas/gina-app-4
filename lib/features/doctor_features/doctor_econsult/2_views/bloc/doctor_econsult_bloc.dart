import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/1_controllers/doctor_appointment_request_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/1_controllers/doctor_e_consult_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_upcoming_appointments/2_views/bloc/doctor_upcoming_appointments_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/0_model/chat_message_model.dart';

part 'doctor_econsult_event.dart';
part 'doctor_econsult_state.dart';

String? selectedPatientAppointment;
bool isFromChatRoomLists = false;

class DoctorEconsultBloc
    extends Bloc<DoctorEconsultEvent, DoctorEconsultState> {
  final DoctorEConsultController doctorEConsultController;
  final DoctorAppointmentRequestController doctorAppointmentRequestController;

  DoctorEconsultBloc({
    required this.doctorEConsultController,
    required this.doctorAppointmentRequestController,
  }) : super(DoctorEconsultInitial()) {
    on<GetRequestedEconsultsDisplayEvent>(getRequestedEconsultsDisplayEvent);
    on<GetPatientDataEvent>(getPatientDataEvent);
  }

  FutureOr<void> getRequestedEconsultsDisplayEvent(
      GetRequestedEconsultsDisplayEvent event,
      Emitter<DoctorEconsultState> emit) async {
    emit(DoctorEconsultLoadingState());

    final upcomingAppointment =
        await doctorEConsultController.getUpcomingDoctorAppointmentsList();

    final doctorChatRooms =
        await doctorEConsultController.getDoctorChatroomsAndMessages();

    upcomingAppointment.fold(
      (failure) {
        emit(DoctorEconsultErrorState(errorMessage: failure.toString()));
      },
      (appointment) {
        // selectedPatientAppointment = appointment.appointmentUid;
        // selectedPatientUid = appointment.patientUid ?? '';
        // selectedPatientName = appointment.patientName ?? '';

        if (doctorChatRooms.isRight()) {
          emit(DoctorEconsultLoadedState(
              upcomingAppointments: appointment,
              chatRooms: doctorChatRooms.getOrElse(() => [])));
        } else {
          emit(DoctorEconsultErrorState(
              errorMessage: 'Error getting chatrooms'));
        }
      },
    );
  }

  FutureOr<void> getPatientDataEvent(
      GetPatientDataEvent event, Emitter<DoctorEconsultState> emit) async {
    debugPrint(
        'getPatientDataEvent called with patientUid: ${event.patientUid}');

    final patientData = await doctorAppointmentRequestController.getPatientData(
        patientUid: event.patientUid);
    debugPrint('patientData result: $patientData');

    final appointmentData = await doctorAppointmentRequestController
        .getDoctorPatients(patientUid: event.patientUid);
    debugPrint('appointmentData result: $appointmentData');

    appointmentData.fold(
      (failure) {
        debugPrint('Error getting appointment data: $failure');
      },
      (appointmentData) {
        debugPrint('Appointment data received: $appointmentData');
        if (appointmentData.patientAppointments.isNotEmpty) {
          appointmentDataFromDoctorUpcomingAppointmentsBloc =
              appointmentData.patientAppointments.first;

          selectedPatientAppointment = appointmentData.patientAppointments
              .where((element) => element.modeOfAppointment == 0)
              .where((element) => element.appointmentStatus == 1)
              .first
              .appointmentUid;
          debugPrint(
              'DoctorEconsultBloc Selected patient appointment: $selectedPatientAppointment');
        } else {
          debugPrint('No patient appointments found.');
        }
      },
    );

    patientData.fold(
      (failure) {
        debugPrint('Error getting patient data: $failure');
      },
      (patientData) {
        debugPrint('Patient data received: $patientData');
        patientDataFromDoctorUpcomingAppointmentsBloc = patientData;
      },
    );
  }
}
