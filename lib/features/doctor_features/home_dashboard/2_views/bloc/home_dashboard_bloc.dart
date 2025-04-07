import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/1_controllers/doctor_appointment_request_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/1_controllers/doctor_profile_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patients/2_views/bloc/doctor_view_patients_bloc.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/1_controllers/doctor_home_dashboard_controllers.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';

part 'home_dashboard_event.dart';
part 'home_dashboard_state.dart';

Map<DateTime, List<AppointmentModel>>? completedAppointmentsListForEconsult;
UserModel? patientDataForUpcomingAppointment;
UserModel? patientDataForPendingAppointment;
UserModel? patientDataForPastAppointment;
String? patientIdForPastAppointmentDetails;

class HomeDashboardBloc extends Bloc<HomeDashboardEvent, HomeDashboardState> {
  final DoctorHomeDashboardController doctorHomeDashboardController;
  final DoctorAppointmentRequestController doctorAppointmentRequestController;
  final DoctorProfileController doctorProfileController;
  HomeDashboardBloc({
    required this.doctorHomeDashboardController,
    required this.doctorProfileController,
    required this.doctorAppointmentRequestController,
  }) : super(HomeDashboardInitial(
          pendingAppointments: 0,
          confirmedAppointments: 0,
          doctorName: '',
          upcomingAppointment: AppointmentModel(),
          pendingAppointmentLatest: AppointmentModel(),
          selectedAppointment: AppointmentModel(),
          patientData: UserModel(
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
          completedAppointmentList: const {},
          completedAppointmentsForPatientData: const [],
          patientPeriods: const [],
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
    Map<DateTime, List<AppointmentModel>> completedAppointmentsList = {};
    UserModel? selectedPatientData;
    List<AppointmentModel> completedAppointmentsForPatientData = [];
    List<PeriodTrackerModel> patientPeriods = [];

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
        completedAppointmentsListForEconsult = appointmentList;
      },
    );

    if (pendingAppointment.isRight()) {
      final appointment =
          pendingAppointment.getOrElse(() => AppointmentModel());
      latestPendingAppointment = appointment;
    }

    // Fetch patient data based on the patientUid of the latestUpcomingAppointment
    if (latestUpcomingAppointment?.patientUid != null) {
      final getPatientData = await doctorHomeDashboardController
          .getPatientData(latestUpcomingAppointment!.patientUid!);

      getPatientData.fold(
        (failure) {},
        (patientData) {
          patientDataForUpcomingAppointment = patientData;
        },
      );
    }

    // Fetch patient data based on the patientUid of the latestPendingAppointment
    if (latestPendingAppointment?.patientUid != null) {
      final getPatientData = await doctorHomeDashboardController
          .getPatientData(latestPendingAppointment!.patientUid!);

      getPatientData.fold(
        (failure) {},
        (patientData) {
          patientDataForPendingAppointment = patientData;
        },
      );
    }

    // Fetch patient data based on the patientIdForPastAppointmentDetails
    if (patientIdForPastAppointmentDetails != null) {
      debugPrint(
          'Fetching patient data for past appointment: $patientIdForPastAppointmentDetails');
      final getPatientData = await doctorHomeDashboardController
          .getPatientData(patientIdForPastAppointmentDetails!);

      getPatientData.fold(
        (failure) {
          debugPrint('Failed to fetch patient data: $failure');
        },
        (patientData) {
          patientDataForPastAppointment = patientData;
          debugPrint(
              'patientDataForPastAppointment from home dashboard bloc: $patientDataForPastAppointment');
          debugPrint('Fetched patient data: ${patientData.name}');
        },
      );
    }

    // Determine which patient data to pass based on the selected appointment
    if (event.selectedAppointment == latestUpcomingAppointment) {
      selectedPatientData = patientDataForUpcomingAppointment;
    } else if (event.selectedAppointment == latestPendingAppointment) {
      selectedPatientData = patientDataForPendingAppointment;
    } else if (event.selectedAppointment?.patientUid ==
        patientIdForPastAppointmentDetails) {
      selectedPatientData = patientDataForPastAppointment;
    }

    // Fetch completed appointments for the selected patient
    if (selectedPatientData != null) {
      final completedAppointmentsResult =
          await doctorAppointmentRequestController
              .getPatientCompletedAppointmentsWithCurrentDoctor(
        patientUid: selectedPatientData.uid,
      );

      completedAppointmentsResult.fold(
        (failure) {
          debugPrint('Failed to fetch completed appointments: $failure');
        },
        (appointments) {
          completedAppointmentsForPatientData = appointments;
        },
      );

      // Fetch patient periods for the selected patient
      final patientPeriodsResult = await doctorHomeDashboardController
          .getPatientPeriods(selectedPatientData.uid);

      patientPeriodsResult.fold(
        (failure) {
          debugPrint('Failed to fetch patient periods: $failure');
        },
        (periods) {
          patientPeriods = periods;
          debugPrint('Home Dashboard Bloc - Fetched patient periods: $periods');
        },
      );
    }

    emit(HomeDashboardInitial(
      pendingAppointments: pendingAppointmentsCount ?? 0,
      confirmedAppointments: confirmedAppointmentsCount ?? 0,
      doctorName: currentDoctorName,
      upcomingAppointment: latestUpcomingAppointment ?? AppointmentModel(),
      pendingAppointmentLatest: latestPendingAppointment ?? AppointmentModel(),
      patientData: selectedPatientData ??
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
      selectedAppointment: event.selectedAppointment,
      completedAppointmentsForPatientData: completedAppointmentsForPatientData,
      patientPeriods: patientPeriods,
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
