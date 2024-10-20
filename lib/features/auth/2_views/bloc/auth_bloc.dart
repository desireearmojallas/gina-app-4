import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/1_controllers/doctor_auth_controller.dart';
import 'package:gina_app_4/features/auth/1_controllers/patient_auth_controller.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_registration_steps/doctor_registration_step_1.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_registration_steps/doctor_registration_step_2.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_registration_steps/doctor_registration_step_3.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_registration_steps/doctor_registration_step_4.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

part 'auth_event.dart';
part 'auth_state.dart';

String? registeredDoctorUid;
File? medicalImageId;
File? medicalImageIdTitle;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationController patientAuthenticationController;
  final DoctorAuthenticationController doctorAuthenticationController;

  AuthBloc({
    required this.patientAuthenticationController,
    required this.doctorAuthenticationController,
  }) : super(AuthInitialState()) {
    on<AuthInitialEvent>(authInitialEvent);
    on<AuthLoginPatientEvent>(authLoginPatientEvent);
    on<AuthLoginDoctorEvent>(authLoginDoctorEvent);
    on<AuthEmitSignUpStateEvent>(authEmitSignUpStateEvent);
    on<AuthRegisterPatientEvent>(authRegisterPatientEvent);
    on<AuthRegisterDoctorEvent>(authRegisterDoctorEvent);
    on<GetDoctorFullContactsEvent>(getDoctorFullContactsEvent);
    on<NavigateToAdminLoginScreenEvent>(navigateToAdminLoginScreenEvent);
    on<ChooseMedicalIdImageEvent>(chooseMedicalIdImageEvent);
    on<RemoveMedicalIdImageEvent>(removeImage);
    on<SubmitDoctorMedicalVerificationEvent>(
        submitDoctorMedicalVerificationEvent);
    on<ChangeWaitingForApprovalEvent>(changeWaitingForApprovalEvent);
    on<ProgressBarCompletedEvent>(progressBarCompletedEvent);
  }

  FutureOr<void> authInitialEvent(
      AuthInitialEvent event, Emitter<AuthState> emit) {
    emit(AuthInitialState());
  }

  FutureOr<void> authLoginPatientEvent(
      AuthLoginPatientEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoginLoadingState());

    try {
      await patientAuthenticationController.patientLogin(
        email: event.email,
        password: event.password,
        accountType: 'Patient',
      );

      emit(AuthLoginPatientSuccessState());
    } catch (e) {
      emit(AuthLoginPatientFailureState('Login Failed: Please Try Again'));
    }
  }

  FutureOr<void> authLoginDoctorEvent(
      AuthLoginDoctorEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoginLoadingState());

    try {
      final doctorVerificationStatus =
          await doctorAuthenticationController.doctorLogin(
        email: event.email,
        password: event.password,
        accountType: 'Doctor',
      );

      if (doctorVerificationStatus == 'Pending') {
        emit(AuthWaitingForApprovalState());
      } else if (doctorVerificationStatus == 'Declined') {
        final declineReason =
            await doctorAuthenticationController.getDeclineReason();
        emit(AuthVerificationDeclinedState(declineReason: declineReason));
      } else if (doctorVerificationStatus == 'Approved' &&
          waitingForApproval == false) {
        emit(AuthLoginDoctorSuccessState());
      } else if (doctorVerificationStatus == 'Approved') {
        emit(AuthVerificationApprovedState());
      }
    } catch (e) {
      emit(AuthLoginDoctorFailureState("Login Failed: Please Try Again"));
    }
  }

  FutureOr<void> authEmitSignUpStateEvent(
      AuthEmitSignUpStateEvent event, Emitter<AuthState> emit) {
    emit(AuthEmitSignUpScreenState());
  }

  FutureOr<void> authRegisterPatientEvent(
      AuthRegisterPatientEvent event, Emitter<AuthState> emit) async {
    emit(AuthRegisterLoadingState());

    try {
      await patientAuthenticationController.registerPatient(
        email: event.email,
        password: event.password,
        name: event.name,
        gender: event.gender,
        dateOfBirth: event.dateOfBirth,
        address: event.address,
      );
      emit(AuthRegisterPatientSuccessState());
    } catch (e) {
      emit(AuthRegisterPatientFailureState(e.toString()));
    }
  }

  FutureOr<void> authRegisterDoctorEvent(
      AuthRegisterDoctorEvent event, Emitter<AuthState> emit) async {
    emit(AuthRegisterLoadingState());

    try {
      final result = await doctorAuthenticationController.registerDoctor(
        name: event.name,
        email: event.email,
        password: event.password,
        medicalSpecialty: event.medicalSpecialty,
        medicalLicenseNumber: event.medicalLicenseNumber,
        boardCertificationOrganization: event.boardCertificationOrganization,
        boardCertificationDate: event.boardCertificationDate,
        medicalSchool: event.medicalSchool,
        medicalSchoolStartDate: event.medicalSchoolStartDate,
        medicalSchoolEndDate: event.medicalSchoolEndDate,
        residencyProgram: event.residencyProgram,
        residencyProgramStartDate: event.residencyProgramStartDate,
        residencyProgramGraduationYear: event.residencyProgramGraduationYear,
        fellowShipProgram: event.fellowShipProgram,
        fellowShipProgramStartDate: event.fellowShipProgramStartDate,
        fellowShipProgramEndDate: event.fellowShipProgramEndDate,
        officeAddress: event.officeAddress,
        officeMapsLocationAddress: event.officeMapsLocationAddress,
        officeLatLngAddress: event.officeLatLngAddress,
        officePhoneNumber: event.officePhoneNumber,
      );
      registeredDoctorUid = result;
      emit(AuthRegisterDoctorSuccessState());
    } catch (e) {
      emit(AuthRegisterDoctorFailureState(e.toString()));
    }
  }

  void dispose() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    medicalLicenseNumberController.clear();
    boardCertificationOrganizationController.clear();
    boardCertificationDateController.clear();
    medicalSchoolController.clear();
    medicalSchoolStartDateController.clear();
    medicalSchoolEndDateController.clear();
    residencyProgramController.clear();
    residencyProgramStartDateController.clear();
    residencyProgramGraduationYearController.clear();
    fellowShipProgramController.clear();
    fellowShipProgramStartDateController.clear();
    fellowShipProgramEndDateController.clear();
    officeAddressController.clear();
    mapsLocationAddressController.clear();
    officePhoneNumberController.clear();
  }

  FutureOr<void> getDoctorFullContactsEvent(
      GetDoctorFullContactsEvent event, Emitter<AuthState> emit) {
    emit(DoctorGetFullContactsState());
  }

  FutureOr<void> navigateToAdminLoginScreenEvent(
      NavigateToAdminLoginScreenEvent event, Emitter<AuthState> emit) {
    emit(NavigateToAdminLoginScreenState());
  }

  void selectDate(
      BuildContext context, TextEditingController dateController) async {
    DateTime selectedDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      dateController.text = DateFormat('MMMM d, y').format(picked);
    }
  }

  FutureOr<void> chooseMedicalIdImageEvent(
      ChooseMedicalIdImageEvent event, Emitter<AuthState> emit) async {
    emit(UploadMedicalImageLoadingState());
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      medicalImageId = File(pickedImage.path);
      medicalImageIdTitle = File(pickedImage.name);
      emit(UploadMedicalImageState(
        medicalImageId: medicalImageId!,
        medicalImageIdTitle: medicalImageIdTitle!,
      ));
    }
  }

  FutureOr<void> removeImage(
      RemoveMedicalIdImageEvent event, Emitter<AuthState> emit) {
    emit(UploadMedicalImageLoadingState());

    medicalImageId = File('');
    medicalImageIdTitle = File('');

    emit(UploadMedicalImageState(
      medicalImageId: medicalImageId!,
      medicalImageIdTitle: medicalImageIdTitle!,
    ));
  }

  FutureOr<void> submitDoctorMedicalVerificationEvent(
      SubmitDoctorMedicalVerificationEvent event,
      Emitter<AuthState> emit) async {
    emit(SubmittingVerificationLoadingState());

    final result =
        await doctorAuthenticationController.submissionOfDoctorVerification(
      doctorUid: event.doctorUid,
      medicalLicenseImageTitle: event.medicalLicenseImageTitle,
      medicalLicenseImageFile: event.medicalLicenseImage,
    );

    if (result) {
      emit(UploadMedicalImageSuccessState());
    } else {
      emit(const UploadMedicalImageFailureState(
        'Failed to Submit Medical Verification: Please Try Again',
      ));
    }
  }

  FutureOr<void> changeWaitingForApprovalEvent(
      ChangeWaitingForApprovalEvent event, Emitter<AuthState> emit) async {
    await doctorAuthenticationController.changeWaitingApprovalStatus();
  }

  FutureOr<void> progressBarCompletedEvent(
      ProgressBarCompletedEvent event, Emitter<AuthState> emit) {
    if (state is UploadMedicalImageState) {
      emit((state as UploadMedicalImageState)
          .copyWith(hasShownProgressBar: true));
    }
  }
}
