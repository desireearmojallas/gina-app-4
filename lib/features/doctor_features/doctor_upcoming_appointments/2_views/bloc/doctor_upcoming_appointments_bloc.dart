import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_upcoming_appointments/2_views/1_controllers/doctor_upcoming_appointments_controller.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

part 'doctor_upcoming_appointments_event.dart';
part 'doctor_upcoming_appointments_state.dart';

UserModel? patientDataFromDoctorUpcomingAppointmentsBloc;
AppointmentModel? appointmentDataFromDoctorUpcomingAppointmentsBloc;

class DoctorUpcomingAppointmentsBloc extends Bloc<
    DoctorUpcomingAppointmentsEvent, DoctorUpcomingAppointmentsState> {
  final DoctorUpcomingAppointmentControllers
      doctorUpcomingAppointmentControllers;
  DoctorUpcomingAppointmentsBloc({
    required this.doctorUpcomingAppointmentControllers,
  }) : super(DoctorUpcomingAppointmentsInitial()) {
    on<GetDoctorUpcomingAppointmentsEvent>(getDoctorUpcomingAppointmentsEvent);
    on<UpcomingAppointmentsFilterEvent>(upcomingAppointmentsFilterEvent);
    on<PastAppointmentsFilterEvent>(pastAppointmentsFilterEvent);
    on<NavigateToApprovedRequestDetailEvent>(
        navigateToApprovedRequestDetailEvent);
    on<NavigateToCompletedRequestDetailEvent>(
        navigateToCompletedRequestDetailEvent);
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  FutureOr<void> getDoctorUpcomingAppointmentsEvent(
      GetDoctorUpcomingAppointmentsEvent event,
      Emitter<DoctorUpcomingAppointmentsState> emit) {}

  FutureOr<void> upcomingAppointmentsFilterEvent(
      UpcomingAppointmentsFilterEvent event,
      Emitter<DoctorUpcomingAppointmentsState> emit) async {
    emit(UpcomingEventsState());
    emit(DoctorUpcomingAppointmentsLoading());

    final upcomingAppointments = await doctorUpcomingAppointmentControllers
        .getConfirmedDoctorAppointmentRequest();

    upcomingAppointments.fold(
        (error) =>
            emit(DoctorUpcomingAppointmentsError(message: error.toString())),
        (appointments) {
      emit(DoctorUpcomingAppointmentsLoaded(appointments: appointments));
    });
  }

  FutureOr<void> pastAppointmentsFilterEvent(PastAppointmentsFilterEvent event,
      Emitter<DoctorUpcomingAppointmentsState> emit) async {
    emit(PastEventsState());
    emit(DoctorPastAppointmentsLoading());

    final pastAppointments = await doctorUpcomingAppointmentControllers
        .getCompletedDoctorAppointmentRequest();

    pastAppointments.fold(
        (error) =>
            emit(DoctorUpcomingAppointmentsError(message: error.toString())),
        (appointments) {
      emit(DoctorPastAppointmentsLoaded(appointments: appointments));
    });
  }

  FutureOr<void> navigateToApprovedRequestDetailEvent(
      NavigateToApprovedRequestDetailEvent event,
      Emitter<DoctorUpcomingAppointmentsState> emit) async {
    final patientData = await doctorUpcomingAppointmentControllers
        .getPatientData(patientUid: event.appointment.patientUid!);
    isFromChatRoomLists = false;

    selectedPatientUid = event.appointment.patientUid!;
    selectedPatientName = event.appointment.patientName!;
    selectedPatientAppointment = event.appointment.appointmentUid!;

    patientData.fold((failure) {
      emit(DoctorUpcomingAppointmentsError(message: failure.toString()));
    }, (patientData) {
      patientDataFromDoctorUpcomingAppointmentsBloc = patientData;
      appointmentDataFromDoctorUpcomingAppointmentsBloc = event.appointment;
      emit(NavigateToApprovedRequestDetailState(
          appointment: event.appointment, patientData: patientData));
    });
  }

  FutureOr<void> navigateToCompletedRequestDetailEvent(
      NavigateToCompletedRequestDetailEvent event,
      Emitter<DoctorUpcomingAppointmentsState> emit) async {
    final patientData = await doctorUpcomingAppointmentControllers
        .getPatientData(patientUid: event.appointment.patientUid!);

    selectedPatientUid = event.appointment.patientUid!;
    selectedPatientName = event.appointment.patientName!;
    selectedPatientAppointment = event.appointment.appointmentUid!;

    patientData.fold((failure) {
      emit(DoctorUpcomingAppointmentsError(message: failure.toString()));
    }, (patientData) {
      patientDataFromDoctorUpcomingAppointmentsBloc = patientData;
      appointmentDataFromDoctorUpcomingAppointmentsBloc = event.appointment;
      emit(NavigateToCompletedRequestDetailState(
          appointment: event.appointment, patientData: patientData));
    });
  }
}
