import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/1_controllers/admin_dashboard_controller.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/1_controllers/admin_doctor_verification_controller.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_verification_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

part 'admin_doctor_list_event.dart';
part 'admin_doctor_list_state.dart';

class AdminDoctorListBloc
    extends Bloc<AdminDoctorListEvent, AdminDoctorListState> {
  final AdminDoctorVerificationController adminDoctorVerificationController;
  final AdminDashboardController adminDashboardController;

  AdminDoctorListBloc({
    required this.adminDoctorVerificationController,
    required this.adminDashboardController,
  }) : super(AdminDoctorListInitial()) {
    on<AdminDoctorListGetRequestEvent>(onAdminDoctorListGetRequestEvent);
    on<AdminDoctorDetailsEvent>(onAdminDoctorDetailsEvent);
  }

  FutureOr<void> onAdminDoctorListGetRequestEvent(
      AdminDoctorListGetRequestEvent event,
      Emitter<AdminDoctorListState> emit) async {
    emit(AdminDoctorListLoadingState());

    final doctors = await adminDoctorVerificationController.getAllDoctors();

    doctors.fold(
      (failure) {
        emit(AdminDoctorListErrorState(message: failure.toString()));
      },
      (doctors) {
        final approvedDoctorList = doctors
            .where((doctor) =>
                doctor.doctorVerificationStatus ==
                DoctorVerificationStatus.approved.index)
            .toList();

        emit(AdminDoctorListLoadedState(
          approvedDoctorList: approvedDoctorList,
        ));
      },
    );
  }

  FutureOr<void> onAdminDoctorDetailsEvent(
      AdminDoctorDetailsEvent event, Emitter<AdminDoctorListState> emit) async {
    final doctorUid = event.doctorApproved.uid;
    final appointmentsOrFailure = await adminDashboardController
        .getCurrentDoctorAppointment(doctorUid: doctorUid);
    final doctorSubmittedDocumentsOrFailure =
        await adminDoctorVerificationController
            .getDoctorSubmittedMedicalLicense(
                doctorId: event.doctorApproved.uid);

    appointmentsOrFailure.fold(
      (failure) {
        emit(AdminDoctorListErrorState(message: failure.toString()));
      },
      (appointments) {
        doctorSubmittedDocumentsOrFailure.fold(
          (failure) {
            emit(AdminDoctorListErrorState(message: failure.toString()));
          },
          (doctorVerification) {
            emit(AdminDoctorListDoctorDetailsState(
              approvedDoctorDetails: event.doctorApproved,
              doctorVerification: doctorVerification,
              appointmentDetails: appointments,
            ));
          },
        );
      },
    );
  }
}
