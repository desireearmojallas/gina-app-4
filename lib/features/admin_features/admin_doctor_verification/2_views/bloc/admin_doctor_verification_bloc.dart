import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/1_controllers/admin_doctor_verification_controller.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_verification_model.dart';

part 'admin_doctor_verification_event.dart';
part 'admin_doctor_verification_state.dart';

class AdminDoctorVerificationBloc
    extends Bloc<AdminDoctorVerificationEvent, AdminDoctorVerificationState> {
  final AdminDoctorVerificationController adminDoctorVerificationController;
  AdminDoctorVerificationBloc({
    required this.adminDoctorVerificationController,
  }) : super(AdminDoctorVerificationInitial()) {
    on<AdminDoctorVerificationGetRequestedEvent>(
        getRequestedDoctorVerificationListEvent);
    on<AdminVerificationPendingDoctorVerificationListEvent>(
        pendingDoctorVerificationListEvent);
    on<AdminVerificationApprovedDoctorVerificationListEvent>(
        approvedDoctorVerificationListEvent);
    on<AdminVerificationDeclinedDoctorVerificationListEvent>(
        declinedDoctorVerificationListEvent);
    on<NavigateToAdminDoctorDetailsPendingEvent>(
        navigateToAdminDoctorDetailsPendingEvent);
    on<NavigateToAdminDoctorDetailsApprovedEvent>(
        navigateToAdminDoctorDetailsApprovedEvent);
    on<NavigateToAdminDoctorDetailsDeclinedEvent>(
        navigateToAdminDoctorDetailsDeclinedEvent);
    on<AdminDoctorVerificationApproveEvent>(
        adminDoctorVerificationApproveEvent);
    on<AdminDoctorVerificationDeclineEvent>(
        adminDoctorVerificationDeclineEvent);
  }

  FutureOr<void> getRequestedDoctorVerificationListEvent(
      AdminDoctorVerificationGetRequestedEvent event,
      Emitter<AdminDoctorVerificationState> emit) async {
    emit(AdminDoctorVerificationLoading());

    final doctors = await adminDoctorVerificationController.getAllDoctors();

    doctors.fold((failure) {
      emit(AdminDoctorVerificationError(errorMessage: failure.toString()));
    }, (doctors) {
      // doctorList = doctors;
      emit(AdminDoctorVerificationLoaded(doctors: doctors));
      emit(AdminVerificationPendingDoctorVerificationListState());
    });
  }

  FutureOr<void> pendingDoctorVerificationListEvent(
      AdminVerificationPendingDoctorVerificationListEvent event,
      Emitter<AdminDoctorVerificationState> emit) {
    emit(AdminVerificationPendingDoctorVerificationListState());
  }

  FutureOr<void> approvedDoctorVerificationListEvent(
      AdminVerificationApprovedDoctorVerificationListEvent event,
      Emitter<AdminDoctorVerificationState> emit) {
    emit(AdminVerificationApprovedDoctorVerificationListState());
  }

  FutureOr<void> declinedDoctorVerificationListEvent(
      AdminVerificationDeclinedDoctorVerificationListEvent event,
      Emitter<AdminDoctorVerificationState> emit) {
    emit(AdminVerificationDeclinedDoctorVerificationListState());
  }

//! continue here
  FutureOr<void> navigateToAdminDoctorDetailsPendingEvent(
      NavigateToAdminDoctorDetailsPendingEvent event,
      Emitter<AdminDoctorVerificationState> emit) async {
    final doctorSubmittedDocuments = await adminDoctorVerificationController
        .getDoctorSubmittedMedicalLicense();
  }

  FutureOr<void> navigateToAdminDoctorDetailsApprovedEvent(
      NavigateToAdminDoctorDetailsApprovedEvent event,
      Emitter<AdminDoctorVerificationState> emit) {}

  FutureOr<void> navigateToAdminDoctorDetailsDeclinedEvent(
      NavigateToAdminDoctorDetailsDeclinedEvent event,
      Emitter<AdminDoctorVerificationState> emit) {}

  FutureOr<void> adminDoctorVerificationApproveEvent(
      AdminDoctorVerificationApproveEvent event,
      Emitter<AdminDoctorVerificationState> emit) {}

  FutureOr<void> adminDoctorVerificationDeclineEvent(
      AdminDoctorVerificationDeclineEvent event,
      Emitter<AdminDoctorVerificationState> emit) {}
}
