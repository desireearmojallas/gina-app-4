import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/1_controllers/appointment_controller.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation/0_model/chat_message_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';
import 'package:gina_app_4/features/patient_features/find/1_controllers/find_controllers.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:gina_app_4/features/patient_features/profile/1_controllers/profile_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

String? storedAppointmentUid;
String? storedAppointmentTime;
AppointmentModel? appointmentDetails;
AppointmentModel? appointmentDetailsForReschedule;
List<String>? storedPrescriptionImages;
bool isUploadPrescriptionMode = false;
bool isFromAppointmentTabs = false;
bool isFromConsultationHistory = false;
List<ChatMessageModel> chatMessages = [];

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
    on<CancelAppointmentInAppointmentTabsEvent>(
        cancelAppointmentInAppointmentTabsEvent);
    on<AppointmentTabChangedEvent>(appointmentTabChangedEvent);
  }

  List<File> prescriptionImages = [];
  List<File> imageTitles = [];
  List<AppointmentModel> storedAppointments = [];

  FutureOr<void> getAppointmentsEvent(
      GetAppointmentsEvent event, Emitter<AppointmentState> emit) async {
    emit(GetAppointmentsLoading());

    final result = await appointmentController.getCurrentPatientAppointment();
    final chatRoomsResult =
        await appointmentController.getPatientChatroomsAndMessages();

    result.fold(
      (failure) {
        emit(GetAppointmentsError(errorMessage: failure.toString()));
      },
      (appointments) {
        chatRoomsResult.fold(
          (chatRoomsFailure) {
            emit(GetAppointmentsError(
                errorMessage: chatRoomsFailure.toString()));
          },
          (chatRooms) {
            storedAppointments = appointments;
            chatMessages = chatRooms;
            emit(GetAppointmentsLoaded(
              appointments: appointments,
              chatRooms: chatRoomsResult.getOrElse(() => []),
            ));
          },
        );
      },
    );
  }

  Future<void> navigateToAppointmentDetailsEvent(
      NavigateToAppointmentDetailsEvent event,
      Emitter<AppointmentState> emit) async {
    try {
      debugPrint('===============================================');
      debugPrint('PROCESSING NavigateToAppointmentDetailsEvent');
      debugPrint('Appointment UID: ${event.appointmentUid}');
      debugPrint('Doctor UID: ${event.doctorUid}');

      emit(AppointmentDetailsLoading());
      debugPrint('Emitted AppointmentDetailsLoading state');

      storedAppointmentUid = event.appointmentUid;

      // Fetch doctor details
      debugPrint('Fetching doctor details for UID: ${event.doctorUid}');
      final getDoctorDetails = await appointmentController.getDoctorDetail(
          doctorUid: event.doctorUid);

      DoctorModel? doctorInformation;

      getDoctorDetails.fold(
        (failure) {
          debugPrint('FAILED to fetch doctor details: $failure');
        },
        (getDoctorDetails) {
          doctorInformation = getDoctorDetails;
          doctorDetails = getDoctorDetails;
          debugPrint(
              'Successfully fetched doctor details: ${doctorInformation?.name}');
        },
      );

      // Fetch patient profile
      debugPrint('Fetching patient profile data');
      final getProfileData = await profileController.getPatientProfile();

      getProfileData.fold(
        (failure) {
          debugPrint('FAILED to fetch patient profile data: $failure');
        },
        (patientData) {
          currentActivePatient = patientData;
          debugPrint(
              'Successfully fetched patient profile data: ${currentActivePatient?.name}');
        },
      );

      // Fetch appointment details
      debugPrint(
          'Fetching appointment details for UID: ${event.appointmentUid}');
      final result = await appointmentController.getAppointmentDetails(
          appointmentUid: event.appointmentUid);

      await result.fold(
        (failure) async {
          debugPrint('FAILED to fetch appointment details: $failure');
          emit(AppointmentDetailsError(errorMessage: failure.toString()));
        },
        (appointment) async {
          debugPrint(
              'Successfully fetched appointment details: ${appointment.appointmentUid}');
          if (appointment.appointmentStatus ==
                  AppointmentStatus.completed.index ||
              appointment.appointmentStatus == 2) {
            debugPrint(
                'Fetching prescription images for appointment UID: ${event.appointmentUid}');
            final images = await appointmentController.getPrescriptionImages(
                appointmentUid: event.appointmentUid);

            await images.fold(
              (failure) async {
                debugPrint('Failed to fetch prescription images: $failure');
                emit(GetPrescriptionImagesError(
                    errorMessage: failure.toString()));
              },
              (images) async {
                storedPrescriptionImages = images;
                debugPrint('Fetched prescription images: $images');
                if (doctorInformation != null && currentActivePatient != null) {
                  emit(ConsultationHistoryState(
                    appointment: appointment,
                    doctorDetails: doctorInformation!,
                    currentPatient: currentActivePatient!,
                    prescriptionImages: images,
                  ));
                } else {
                  emit(const AppointmentDetailsError(
                      errorMessage:
                          'Doctor information or patient data is null'));
                }
              },
            );
          } else {
            if (doctorInformation != null && currentActivePatient != null) {
              debugPrint(
                  'All required data available, emitting AppointmentDetailsState');
              emit(AppointmentDetailsState(
                appointment: appointment,
                doctorDetails: doctorInformation!,
                currentPatient: currentActivePatient!,
              ));
              debugPrint('SUCCESSFULLY emitted AppointmentDetailsState');
            } else {
              debugPrint(
                  'ERROR: Missing required data for AppointmentDetailsState');
              debugPrint(
                  'Doctor information available: ${doctorInformation != null}');
              debugPrint(
                  'Patient data available: ${currentActivePatient != null}');
              emit(const AppointmentDetailsError(
                  errorMessage: 'Doctor information or patient data is null'));
            }
          }
        },
      );
      debugPrint('NavigateToAppointmentDetailsEvent processing completed');
      debugPrint('===============================================');
    } catch (e, stackTrace) {
      debugPrint('===============================================');
      debugPrint('ERROR in navigateToAppointmentDetailsEvent: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('===============================================');
      emit(AppointmentDetailsError(errorMessage: e.toString()));
    }
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

  FutureOr<void> cancelAppointmentInAppointmentTabsEvent(
      CancelAppointmentInAppointmentTabsEvent event,
      Emitter<AppointmentState> emit) async {
    emit(CancelAppointmentLoading());

    try {
      final result = await appointmentController.cancelAppointment(
        appointmentUid: event.appointmentUid,
      );

      await result.fold(
        (failure) {
          emit(CancelAppointmentError(errorMessage: failure.toString()));
        },
        (success) async {
          // Get the latest appointment details to check refund status
          final appointmentDetails =
              await appointmentController.getAppointmentDetails(
            appointmentUid: event.appointmentUid,
          );

          await appointmentDetails.fold(
            (failure) {
              emit(CancelAppointmentError(errorMessage: failure.toString()));
            },
            (appointment) {
              if (appointment.refundStatus != null) {
                emit(CancelAppointmentWithRefundState(
                  refundStatus: appointment.refundStatus!,
                  refundId: appointment.refundId,
                  refundInitiatedAt: appointment.refundInitiatedAt,
                  refundAmount: appointment.refundAmount,
                ));
              } else {
                emit(CancelAppointmentState());
              }
            },
          );
        },
      );
    } catch (e) {
      emit(CancelAppointmentError(errorMessage: e.toString()));
    }
  }

  FutureOr<void> appointmentTabChangedEvent(
      AppointmentTabChangedEvent event, Emitter<AppointmentState> emit) {
    emit(AppointmentTabViewState(activeTabIndex: event.index));
  }

  Future<void> handleConsultationNavigation(state, BuildContext context) async {
    HapticFeedback.mediumImpact();
    isFromConsultationHistory = false;
    selectedDoctorAppointmentModel = state.appointment;
    final appointmentUid = state.appointment.appointmentUid;

    if (appointmentUid != null) {
      debugPrint('Fetching appointment details for UID: $appointmentUid');
      final appointment =
          await appointmentController.getAppointmentDetailsNew(appointmentUid);

      if (appointment != null) {
        final bool isValidTime = _isWithinAppointmentTime(appointment);
        if (isValidTime &&
            state.appointment.appointmentStatus ==
                AppointmentStatus.confirmed.index) {
          debugPrint('Marking appointment as visited for UID: $appointmentUid');
          await appointmentController
              .markAsVisitedConsultationRoom(appointmentUid);
        } else {
          debugPrint(
              'Appointment is not within the valid time range or status is not confirmed.');
        }
      } else {
        debugPrint('Appointment not found.');
      }
    } else {
      debugPrint('Appointment UID is null.');
    }

    if (context.mounted) {
      Navigator.pushNamed(context, '/consultation').then(
        (value) => context.read<AppointmentBloc>().add(
              NavigateToAppointmentDetailsEvent(
                doctorUid: doctorDetails!.uid,
                appointmentUid: state.appointment.appointmentUid!,
              ),
            ),
      );
    }
  }

  bool _isWithinAppointmentTime(AppointmentModel appointment) {
    final DateFormat dateFormat = DateFormat('MMMM d, yyyy');
    final DateFormat timeFormat = DateFormat('hh:mm a');
    final DateTime now = DateTime.now();

    final DateTime appointmentDate =
        dateFormat.parse(appointment.appointmentDate!.trim());
    final List<String> times = appointment.appointmentTime!.split(' - ');
    final DateTime startTime = timeFormat.parse(times[0].trim());
    final DateTime endTime = timeFormat.parse(times[1].trim());

    final DateTime appointmentStartDateTime = DateTime(
      appointmentDate.year,
      appointmentDate.month,
      appointmentDate.day,
      startTime.hour,
      startTime.minute,
    );

    final DateTime appointmentEndDateTime = DateTime(
      appointmentDate.year,
      appointmentDate.month,
      appointmentDate.day,
      endTime.hour,
      endTime.minute,
    );

    debugPrint('Current time: $now');
    debugPrint('Appointment start time: $appointmentStartDateTime');
    debugPrint('Appointment end time: $appointmentEndDateTime');

    return now.isAfter(appointmentStartDateTime) &&
        now.isBefore(appointmentEndDateTime);
  }
}
