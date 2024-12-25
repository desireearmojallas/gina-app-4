import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/1_controllers/doctor_profile_controller.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/1_controllers/doctor_home_dashboard_controllers.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

part 'home_dashboard_event.dart';
part 'home_dashboard_state.dart';

class HomeDashboardBloc extends Bloc<HomeDashboardEvent, HomeDashboardState> {
  final DoctorHomeDashboardController doctorHomeDashboardController;
  final DoctorProfileController doctorProfileController;
  HomeDashboardBloc({
    required this.doctorHomeDashboardController,
    required this.doctorProfileController,
  }) : super(HomeDashboardInitial(
          pendingAppointments: pendingAppointmentsCount ?? 0,
          confirmedAppointments: confirmedAppointmentsCount ?? 0,
          doctorName: doctorName ?? '',
          upcomingAppointment: upcomingAppointment ?? AppointmentModel(),
          pendingAppointmentLatest: pendingAppointment ?? AppointmentModel(),
          patientData: patientDataCont ??
              UserModel(
                name: '',
                email: '',
                uid: '',
                gender: '',
                dateOfBirth: '',
                profileImage: '',
                headerImage: '',
                accountType: '',
                address: '',
                chatrooms: const [],
                appointmentsBooked: const [],
              ),
          completedAppointmentList: completedAppointments,
        )) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<GetDoctorNameEvent>(getDoctorName);
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeDashboardState> emit) async {
    int? pendingAppointmentsCount;
    int? confirmedAppointmentsCount;
    AppointmentModel? latestUpcomingAppointment;
    AppointmentModel? latestPendingAppointment;
    UserModel? latestPatientData;
    Map<DateTime, List<AppointmentModel>> completedAppointmentsList = {};

    final getTheNumberOfConfirmedAppointments =
        await doctorHomeDashboardController.getConfirmedAppointments();

    final getTheNumberOfPendingAppointments =
        await doctorHomeDashboardController.getPendingAppointments();

    final currentDoctorName =
        await doctorProfileController.getCurrentDoctorName();

    final upcomingAppointment =
        await doctorHomeDashboardController.getUpcomingAppointment();

    final pendingAppointment =
        await doctorHomeDashboardController.getPendingAppointmentLatest();

    final completedAppointment =
        await doctorHomeDashboardController.getCompletedAppointments();

    getTheNumberOfPendingAppointments.fold((failure) {}, (pendingAppointments) {
      pendingAppointmentsCount = pendingAppointments;
    });

    getTheNumberOfConfirmedAppointments.fold((failure) {},
        (confirmedAppointments) {
      confirmedAppointmentsCount = confirmedAppointments;
    });

    upcomingAppointment.fold(
      (failure) {},
      (appointment) {
        latestUpcomingAppointment = appointment;
      },
    );

    completedAppointment.fold(
      (failure) {},
      (appointmentList) {
        completedAppointmentsList = appointmentList;
      },
    );

    if (pendingAppointment.isRight()) {
      final appointment =
          pendingAppointment.getOrElse(() => AppointmentModel());
      latestPendingAppointment = appointment;

      if (latestPendingAppointment.patientUid != null) {
        final getPatientData = await doctorHomeDashboardController
            .getPatientData(latestPendingAppointment.patientUid!);

        getPatientData.fold(
          (failure) {},
          (patientData) {
            latestPatientData = patientData;
          },
        );
      }
    }

    // Debug prints to check the values of patientData
    debugPrint('HomeDashboardBloc Patient Name: ${latestPatientData?.name}');
    debugPrint(
        'HomeDashboardBloc Patient Date of Birth: ${latestPatientData?.dateOfBirth}');
    debugPrint(
        'HomeDashboardBloc Patient Gender: ${latestPatientData?.gender}');
    debugPrint(
        'HomeDashboardBloc Patient Address: ${latestPatientData?.address}');
    debugPrint('HomeDashboardBloc Patient Email: ${latestPatientData?.email}');

    emit(HomeDashboardInitial(
      pendingAppointments: pendingAppointmentsCount ?? 0,
      confirmedAppointments: confirmedAppointmentsCount ?? 0,
      doctorName: currentDoctorName,
      upcomingAppointment: latestUpcomingAppointment ?? AppointmentModel(),
      pendingAppointmentLatest: latestPendingAppointment ?? AppointmentModel(),
      patientData: latestPatientData ??
          UserModel(
            name: '',
            email: '',
            uid: '',
            gender: '',
            dateOfBirth: '',
            profileImage: '',
            headerImage: '',
            accountType: '',
            address: '',
            chatrooms: const [],
            appointmentsBooked: const [],
          ),
      completedAppointmentList: completedAppointmentsList,
    ));
  }

  FutureOr<void> getDoctorName(
      GetDoctorNameEvent event, Emitter<HomeDashboardState> emit) async {
    final currentDoctorName =
        await doctorProfileController.getCurrentDoctorName();
    emit(GetDoctorNameState(
      doctorName: currentDoctorName,
    ));
  }
}
