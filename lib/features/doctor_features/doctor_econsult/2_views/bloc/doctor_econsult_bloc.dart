import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/1_controllers/doctor_appointment_request_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
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

    final upcomingAppointments =
        await doctorEConsultController.getUpcomingDoctorAppointmentsList();

    final doctorChatRooms =
        await doctorEConsultController.getDoctorChatroomsAndMessages();

    upcomingAppointments.fold(
      (failure) {
        emit(DoctorEconsultErrorState(
          errorMessage: failure.toString(),
        ));
      },
      (appointments) {
        debugPrint('Appointments received: $appointments');
        if (appointments.isNotEmpty) {
          selectedPatientAppointment = appointments.first.appointmentUid;
          selectedPatientUid = appointments.first.patientUid ?? '';
          selectedPatientName = appointments.first.patientName ?? '';
          debugPrint(
              'Selected patient appointment: $selectedPatientAppointment');
          debugPrint('Selected patient UID: $selectedPatientUid');
          debugPrint('Selected patient name: $selectedPatientName');
        }

        doctorChatRooms.fold(
          (failure) {
            debugPrint('Error getting chatrooms: $failure');
            emit(DoctorEconsultErrorState(
                errorMessage: 'Error getting chatrooms'));
          },
          (chatRooms) {
            debugPrint('Chat rooms received: $chatRooms');
            emit(DoctorEconsultLoadedState(
              upcomingAppointments: appointments,
              chatRooms: doctorChatRooms.getOrElse(() => []),
            ));
            debugPrint('DoctorEConsultLoadedState emitted');
          },
        );
      },
    );
  }

  FutureOr<void> getPatientDataEvent(
      GetPatientDataEvent event, Emitter<DoctorEconsultState> emit) async {
    final patientData = await doctorAppointmentRequestController.getPatientData(
        patientUid: event.patientUid);

    final appointmentData = await doctorAppointmentRequestController
        .getDoctorPatients(patientUid: event.patientUid);

    appointmentData.fold(
      (failure) {},
      (appointmentData) {
        appointmentDataFromDoctorUpcomingAppointmentsBloc =
            appointmentData.patientAppointments.first;

        selectedPatientAppointment = appointmentData.patientAppointments
            .where((element) => element.modeOfAppointment == 0)
            .where((element) => element.appointmentStatus == 1)
            .first
            .appointmentUid;
      },
    );

    patientData.fold((failure) {}, (patientData) {
      patientDataFromDoctorUpcomingAppointmentsBloc = patientData;
    });
  }
}
