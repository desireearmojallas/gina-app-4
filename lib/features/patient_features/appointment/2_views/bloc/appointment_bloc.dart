import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/1_controllers/appointment_controller.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/find/1_controllers/find_controllers.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:gina_app_4/features/patient_features/profile/1_controllers/profile_controller.dart';
import 'package:image_picker/image_picker.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

String? storedAppointmentUid;
String? storedAppointmentTime;
AppointmentModel? appointmentDetails;
List<String>? storedPrescriptionImages;
bool isUploadPrescriptionMode = false;
bool isFromAppointmentTabs = false;
bool isFromConsultationHistory = false;

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentController appointmentController;
  final ProfileController profileController;
  final FindController findController;

  AppointmentBloc({
    required this.appointmentController,
    required this.profileController,
    required this.findController,
  }) : super(AppointmentInitial()) {
    // }) : super(const AppointmentTabViewState(activeTabIndex: 0)) {
    on<GetAppointmentsEvent>(getAppointmentsEvent);
    on<NavigateToAppointmentDetailsEvent>(navigateToAppointmentDetailsEvent);
    on<NavigateToConsultationHistoryEvent>(navigateToConsultationHistoryEvent);
    on<ChooseImageEvent>(chooseImageEvent);
    on<RemoveImageEvent>(removeImageEvent);
    on<UploadPrescriptionEvent>(uploadPrescriptionEvent);
    on<CancelAppointmentInAppointmentTabsEvent>(cancelAppointmentEvent);
    on<AppointmentTabChangedEvent>(appointmentTabChangedEvent);
  }

  List<File> prescriptionImages = [];
  List<File> imageTitles = [];
  List<AppointmentModel> storedAppointments = [];

  FutureOr<void> getAppointmentsEvent(
      GetAppointmentsEvent event, Emitter<AppointmentState> emit) async {
    emit(GetAppointmentsLoading());

    final result = await appointmentController.getCurrentPatientAppointment();

    result.fold(
      (failure) {
        emit(GetAppointmentsError(errorMessage: failure.toString()));
      },
      (appointments) {
        storedAppointments = appointments;
        emit(GetAppointmentsLoaded(appointments: appointments));
      },
    );
  }

  FutureOr<void> navigateToAppointmentDetailsEvent(
      NavigateToAppointmentDetailsEvent event,
      Emitter<AppointmentState> emit) async {
    emit(AppointmentDetailsLoading());

    storedAppointmentUid = event.appointmentUid;

    final getDoctorDetails =
        await appointmentController.getDoctorDetail(doctorUid: event.doctorUid);

    DoctorModel? doctorInformation;

    getDoctorDetails.fold(
      (failure) {},
      (getDoctorDetails) {
        doctorInformation = getDoctorDetails;
        doctorDetails = getDoctorDetails;
      },
    );

    final getProfileData = await profileController.getPatientProfile();

    getProfileData.fold(
      (failure) {},
      (patientData) {
        currentActivePatient = patientData;
      },
    );

    final result = await appointmentController.getAppointmentDetails(
        appointmentUid: event.appointmentUid);

    result.fold(
      (failure) {
        emit(AppointmentDetailsError(errorMessage: failure.toString()));
      },
      (appointment) {
        emit(AppointmentDetailsState(
          appointment: appointment,
          doctorDetails: doctorInformation!,
          currentPatient: currentActivePatient!,
        ));
      },
    );
  }

  FutureOr<void> navigateToConsultationHistoryEvent(
      NavigateToConsultationHistoryEvent event,
      Emitter<AppointmentState> emit) async {
    emit(ConsultationHistoryLoading());

    final getDoctorDetails =
        await appointmentController.getDoctorDetail(doctorUid: event.doctorUid);

    DoctorModel? doctorInformation;

    getDoctorDetails.fold(
      (failure) {},
      (getDoctorDetails) {
        doctorDetails = getDoctorDetails;
        doctorInformation = getDoctorDetails;
      },
    );

    final getProfileData = await profileController.getPatientProfile();

    getProfileData.fold(
      (failure) {},
      (patientData) {
        currentActivePatient = patientData;
      },
    );

    final result = await appointmentController.getCompletedAppointmentByApptId(
        appointmentUid: event.appointmentUid);

    result.fold(
      (failure) {
        emit(AppointmentDetailsError(errorMessage: failure.toString()));
      },
      (appointment) async {
        appointmentDetails = appointment;
      },
    );

    final images = await appointmentController.getPrescriptionImages(
        appointmentUid: event.appointmentUid);

    images.fold(
      (failure) {
        emit(GetPrescriptionImagesError(errorMessage: failure.toString()));
      },
      (images) {
        storedPrescriptionImages = images;
        emit(ConsultationHistoryState(
          appointment: appointmentDetails!,
          doctorDetails: doctorInformation!,
          currentPatient: currentActivePatient!,
          prescriptionImages: images,
        ));
      },
    );
  }

  FutureOr<void> chooseImageEvent(
      ChooseImageEvent event, Emitter<AppointmentState> emit) async {
    emit(UploadPrescriptionLoading());

    final pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      for (var pickedFile in pickedFiles) {
        prescriptionImages.add(File(pickedFile.path));
        imageTitles.add(File(pickedFile.path));
      }

      emit(UploadPrescriptionState(
        prescriptionImage: prescriptionImages,
        imageTitle: imageTitles,
      ));
    }
  }

  FutureOr<void> removeImageEvent(
      RemoveImageEvent event, Emitter<AppointmentState> emit) {
    emit(UploadPrescriptionLoading());

    prescriptionImages.removeAt(event.index);
    imageTitles.removeAt(event.index);

    emit(UploadPrescriptionState(
      prescriptionImage: prescriptionImages,
      imageTitle: imageTitles,
    ));
  }

  FutureOr<void> uploadPrescriptionEvent(
      UploadPrescriptionEvent event, Emitter<AppointmentState> emit) async {
    emit(UploadingPrescriptionInFirebase());

    final result = await appointmentController.uploadPrescriptionImages(
      appointmentUid: storedAppointmentUid!,
      images: event.images,
    );

    result.fold(
      (failure) {
        emit(UploadPrescriptionError(errorMessage: failure.toString()));
      },
      (prescriptionImages) {
        emit(PrescriptionUploadedSuccessfully());
      },
    );
  }

  FutureOr<void> cancelAppointmentEvent(
      CancelAppointmentInAppointmentTabsEvent event,
      Emitter<AppointmentState> emit) async {
    emit(CancelAppointmentLoading());

    final result = await appointmentController.cancelAppointment(
      appointmentUid: event.appointmentUid,
    );

    result.fold(
      (failure) {
        emit(CancelAppointmentError(errorMessage: failure.toString()));
      },
      (appointment) {
        emit(CancelAppointmentState());
        emit(GetAppointmentsLoaded(appointments: storedAppointments));
      },
    );
  }

  FutureOr<void> appointmentTabChangedEvent(
      AppointmentTabChangedEvent event, Emitter<AppointmentState> emit) {
    emit(AppointmentTabViewState(activeTabIndex: event.index));
  }
}
