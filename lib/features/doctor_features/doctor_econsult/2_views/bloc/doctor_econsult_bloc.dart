import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/1_controllers/doctor_appointment_request_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/completed_state/bloc/completed_request_state_bloc.dart';
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
    on<GetAppointmentDetailsEvent>(getAppointmentDetailsEvent);
  }

  FutureOr<void> getRequestedEconsultsDisplayEvent(
    GetRequestedEconsultsDisplayEvent event,
    Emitter<DoctorEconsultState> emit,
  ) async {
    debugPrint('onGetRequestedEConsultsDisplayEvent triggered');
    emit(DoctorEconsultLoadingState());
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
        emit(DoctorEconsultErrorState(errorMessage: failure.toString()));
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
        patientDetailsForDoctorFaceToFaceScreenConsultationHistory =
            patientData;
        debugPrint('Patient data received: $patientData');
        patientDataFromDoctorUpcomingAppointmentsBloc = patientData;
      },
    );
  }

  FutureOr<void> getAppointmentDetailsEvent(GetAppointmentDetailsEvent event,
      Emitter<DoctorEconsultState> emit) async {
    debugPrint(
        'getAppointmentDetailsEvent called with appointmentId: ${event.appointmentUid}');
    emit(DoctorEconsultLoadingState());

    try {
      DocumentSnapshot<Map<String, dynamic>> appointmentSnapshot =
          await FirebaseFirestore.instance
              .collection('appointments')
              .doc(event.appointmentUid)
              .get();

      if (appointmentSnapshot.exists) {
        final appointment =
            AppointmentModel.fromJson(appointmentSnapshot.data()!);

        selectedPatientAppointmentModel = appointment;

        emit(AppointmentDetailsLoadedState(appointment: appointment));
      } else {
        emit(DoctorEconsultErrorState(errorMessage: 'Appointment not found'));
      }
    } catch (e) {
      debugPrint('Error fetching appointment details: $e');
      emit(DoctorEconsultErrorState(errorMessage: e.toString()));
    }
  }

  Stream<AppointmentModel?> fetchAppointmentDetails(String appointmentId) {
    return FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointmentId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return AppointmentModel.fromJson(doc.data()!);
      }
      return null;
    });
  }
}
