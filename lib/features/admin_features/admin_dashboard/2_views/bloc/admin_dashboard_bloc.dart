import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/1_controllers/admin_dashboard_controller.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/1_controllers/admin_doctor_verification_controller.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_verification_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

part 'admin_dashboard_event.dart';
part 'admin_dashboard_state.dart';

List<DoctorModel> doctorList = [];
List<UserModel> patientList = [];
bool isFromAdminDashboard = false;

class AdminDashboardBloc
    extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final AdminDashboardController adminDashboardController;
  final AdminDoctorVerificationController adminDoctorVerificationController;

  AdminDashboardBloc({
    required this.adminDashboardController,
    required this.adminDoctorVerificationController,
  }) : super(AdminDashboardInitial()) {
    on<AdminDashboardGetRequestedEvent>(adminDashboardGetRequestedEvent);
    on<PendingDoctorVerificationListEvent>(pendingDoctorVerificationListEvent);
    on<ApprovedDoctorVerificationListEvent>(
        approvedDoctorVerificationListEvent);
    on<DeclinedDoctorVerificationListEvent>(
        declinedDoctorVerificationListEvent);
    on<NavigateToDoctorDetailsPendingEvent>(
        navigateToDoctorDetailsPendingEvent);
    on<NavigateToDoctorDetailsApprovedEvent>(
        navigateToDoctorDetailsApprovedEvent);
    on<NavigateToDoctorDetailsDeclinedEvent>(
        navigateToDoctorDetailsDeclinedEvent);
    on<AdminDashboardApproveEvent>(adminDashboardApproveEvent);
    on<AdminDashboardDeclineEvent>(adminDashboardDeclineEvent);
    on<AdminDashboardNavigateToListOfAllAppointmentsEvent>(
        navigateToListOfAllAppointmentsEvent);
    on<AdminDashboardNavigateToListOfAllPatientsEvent>(
        navigateToListOfAllPatientsEvent);
  }

  FutureOr<void> adminDashboardGetRequestedEvent(
      AdminDashboardGetRequestedEvent event,
      Emitter<AdminDashboardState> emit) async {
    emit(AdminDashboardLoading());

    final doctors = await adminDashboardController.getAllDoctors();
    final patients = await adminDashboardController.getAllPatients();

    doctors.fold(
      (failure) {
        emit(AdminDashboardError(errorMessage: failure.toString()));
      },
      (doctors) {
        doctors.sort((a, b) => b.created!.compareTo(a.created!));
        doctorList = doctors;
        patients.fold(
          (failure) {
            emit(AdminDashboardError(errorMessage: failure.toString()));
          },
          (patients) {
            patientList = patients;

            emit(AdminDashboardLoaded(
              doctors: doctors,
              patients: patients,
            ));
            emit(PendingDoctorVerificationListState());
          },
        );
      },
    );
  }

  FutureOr<void> pendingDoctorVerificationListEvent(
      PendingDoctorVerificationListEvent event,
      Emitter<AdminDashboardState> emit) {
    emit(PendingDoctorVerificationListState());
  }

  FutureOr<void> approvedDoctorVerificationListEvent(
      ApprovedDoctorVerificationListEvent event,
      Emitter<AdminDashboardState> emit) {
    emit(ApprovedDoctorVerificationListState());
  }

  FutureOr<void> declinedDoctorVerificationListEvent(
      DeclinedDoctorVerificationListEvent event,
      Emitter<AdminDashboardState> emit) {
    emit(DeclinedDoctorVerificationListState());
  }

  FutureOr<void> navigateToDoctorDetailsPendingEvent(
      NavigateToDoctorDetailsPendingEvent event,
      Emitter<AdminDashboardState> emit) async {
    final doctorSubmittedDocuments = await adminDoctorVerificationController
        .getDoctorSubmittedMedicalLicense(
            doctorId: event.pendingDoctorDetails.uid);

    doctorSubmittedDocuments.fold((failure) {
      emit(AdminDashboardError(errorMessage: failure.toString()));
    }, (doctorSubmittedDocuments) {
      emit(NavigateToDoctorDetailsPendingState(
          pendingDoctorDetails: event.pendingDoctorDetails,
          doctorVerification: doctorSubmittedDocuments));
    });
  }

  FutureOr<void> navigateToDoctorDetailsApprovedEvent(
      NavigateToDoctorDetailsApprovedEvent event,
      Emitter<AdminDashboardState> emit) async {
    final doctorSubmittedDocuments = await adminDoctorVerificationController
        .getDoctorSubmittedMedicalLicense(
            doctorId: event.approvedDoctorDetails.uid);

    doctorSubmittedDocuments.fold((failure) {
      emit(AdminDashboardError(errorMessage: failure.toString()));
    }, (doctorSubmittedDocuments) {
      emit(NavigateToDoctorDetailsApprovedState(
          approvedDoctorDetails: event.approvedDoctorDetails,
          doctorVerification: doctorSubmittedDocuments));
    });
  }

  FutureOr<void> navigateToDoctorDetailsDeclinedEvent(
      NavigateToDoctorDetailsDeclinedEvent event,
      Emitter<AdminDashboardState> emit) async {
    final doctorSubmittedDocuments = await adminDoctorVerificationController
        .getDoctorSubmittedMedicalLicense(
            doctorId: event.declinedDoctorDetails.uid);

    doctorSubmittedDocuments.fold(
      (failure) {
        emit(AdminDashboardError(errorMessage: failure.toString()));
      },
      (doctorSubmittedDocuments) {
        emit(NavigateToDoctorDetailsDeclinedState(
            declinedDoctorDetails: event.declinedDoctorDetails,
            doctorVerification: doctorSubmittedDocuments));
      },
    );
  }

  FutureOr<void> adminDashboardApproveEvent(AdminDashboardApproveEvent event,
      Emitter<AdminDashboardState> emit) async {
    final result =
        await adminDoctorVerificationController.approveDoctorVerification(
      doctorId: event.doctorId,
      doctorVerificationId: event.doctorVerificationId,
    );

    result.fold((failure) {
      emit(AdminDashboardError(errorMessage: failure.toString()));
    }, (result) async {
      emit(AdminDashboardLoaded(
        doctors: doctorList,
        patients: patientList,
      ));

      emit(PendingDoctorVerificationListState());
      emit(AdminDashboardApproveSuccessState());
    });
  }

  FutureOr<void> adminDashboardDeclineEvent(AdminDashboardDeclineEvent event,
      Emitter<AdminDashboardState> emit) async {
    final result =
        await adminDoctorVerificationController.declineDoctorVerification(
            doctorId: event.doctorId,
            doctorVerificationId: event.doctorVerificationId,
            declineReason: event.declinedReason);

    result.fold((failure) {
      emit(AdminDashboardError(errorMessage: failure.toString()));
    }, (result) async {
      emit(AdminDashboardLoaded(
        doctors: doctorList,
        patients: patientList,
      ));
    });
  }

  FutureOr<void> navigateToListOfAllAppointmentsEvent(
      AdminDashboardNavigateToListOfAllAppointmentsEvent event,
      Emitter<AdminDashboardState> emit) async {
    final appointments = await adminDashboardController.getAllAppointments();

    appointments.fold((failure) {
      emit(AdminDashboardError(errorMessage: failure.toString()));
    }, (appointments) {
      emit(NavigateToAppointmentsBookedList(
        appointments: appointments,
      ));
    });
  }

  FutureOr<void> navigateToListOfAllPatientsEvent(
      AdminDashboardNavigateToListOfAllPatientsEvent event,
      Emitter<AdminDashboardState> emit) async {
    final patients = await adminDashboardController.getAllPatients();

    patients.fold((failure) {
      emit(AdminDashboardError(errorMessage: failure.toString()));
    }, (patients) {
      emit(NavigateToPatientsList(
        patients: patients,
      ));
    });
  }
}
