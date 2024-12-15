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
    extends Bloc<DoctorEConsultEvent, DoctorEConsultState> {
  final DoctorEConsultController doctorEConsultController;
  final DoctorAppointmentRequestController doctorAppointmentRequestController;
  DoctorEconsultBloc({
    required this.doctorEConsultController,
    required this.doctorAppointmentRequestController,
  }) : super(DoctorEConsultInitial()) {
    on<GetRequestedEConsultsDiplayEvent>(onGetRequestedEConsultsDisplayEvent);
    on<GetPatientDataEvent>(getPatientDataEvent);
  }

  FutureOr<void> onGetRequestedEConsultsDisplayEvent(
    GetRequestedEConsultsDiplayEvent event,
    Emitter<DoctorEConsultState> emit,
  ) async {
    debugPrint('onGetRequestedEConsultsDisplayEvent triggered');
    emit(DoctorEConsultLoadingState());
    debugPrint('DoctorEConsultLoadingState emitted');

    final upcomingAppointment =
        await doctorEConsultController.getUpcomingDoctorAppointmentsList();
    debugPrint('upcomingAppointment result: $upcomingAppointment');

    final doctorChatRooms =
        await doctorEConsultController.getDoctorChatroomsAndMessages();
    debugPrint('doctorChatRooms result: $doctorChatRooms');

    upcomingAppointment.fold(
      (failure) {
        debugPrint('Error getting upcoming appointments: $failure');
        emit(DoctorEConsultErrorState(message: failure.toString()));
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
            emit(DoctorEConsultErrorState(message: 'Error getting chatrooms'));
          },
          (chatRooms) {
            debugPrint('Chat rooms received: $chatRooms');
            emit(DoctorEConsultLoadedState(
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
      GetPatientDataEvent event, Emitter<DoctorEConsultState> emit) async {
    final patientData = await doctorAppointmentRequestController.getPatientData(
        patientUid: event.patientUid);

    final appointmentData = await doctorAppointmentRequestController
        .getDoctorPatients(patientUid: event.patientUid);

    appointmentData.fold((failure) {}, (appointmentData) {
      appointmentDataFromDoctorUpcomingAppointmentsBloc =
          appointmentData.patientAppointments.first;

      selectedPatientAppointment = appointmentData.patientAppointments
          .where((element) => element.modeOfAppointment == 0)
          .where((element) => element.appointmentStatus == 1)
          .first
          .appointmentUid;
    });

    patientData.fold(
      (failure) {},
      (patientData) {
        patientDataFromDoctorUpcomingAppointmentsBloc = patientData;
      },
    );
  }
}
