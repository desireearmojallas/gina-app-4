import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/1_controllers/doctor_appointment_request_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/1_controllers/doctor_chat_message_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/1_controllers/appointment_chat_controller.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';

part 'doctor_consultation_event.dart';
part 'doctor_consultation_state.dart';

String? doctorChatRoom;
String? selectedPatientUid;
String? selectedPatientName;
AppointmentModel? selectedPatientAppointmentModel;
UserModel? selectedPatientDetails;
bool isF2FSession = false;
bool f2fAppointmentStarted = false;
bool f2fAppointmentEnded = false;
List<AppointmentModel>? completedAppointmentsForPatientDataMenu;
List<PeriodTrackerModel>? patientPeriodsForPatientDataMenu;

class DoctorConsultationBloc
    extends Bloc<DoctorConsultationEvent, DoctorConsultationState> {
  final DoctorChatMessageController doctorChatMessageController;
  final AppointmentChatController appointmentChatController;
  final DoctorAppointmentRequestController doctorAppointmentRequestController;
  DoctorConsultationBloc({
    required this.doctorChatMessageController,
    required this.appointmentChatController,
    required this.doctorAppointmentRequestController,
  }) : super(DoctorConsultationInitial()) {
    on<DoctorConsultationGetRequestedAppointmentEvent>(
        getRequestedAppointmentEvent);
    on<DoctorConsultationSendFirstMessageEvent>(sendFirstMessageEvent);
    on<DoctorConsultationSendChatMessageEvent>(sendChatMessageEvent);
    on<CompleteDoctorConsultationButtonEvent>(completeDoctorConsultation);
    on<NavigateToPatientDataEvent>(navigateToPatientDataEvent);
    on<DoctorConsultationCheckStatusEvent>(checkStatusEvent);
    on<BeginF2FSessionEvent>(beginF2FSessionEvent);
    on<ConcludeF2FSessionEvent>(concludeF2FSessionEvent);
  }

  FutureOr<void> getRequestedAppointmentEvent(
      DoctorConsultationGetRequestedAppointmentEvent event,
      Emitter<DoctorConsultationState> emit) async {
    // emit(DoctorConsultationLoadingState());

    if (isFromChatRoomLists) {
      debugPrint('isFromChatRoomLists is true');
      final chatRoomId = await doctorChatMessageController.initChatRoom(
        doctorChatMessageController.generateRoomId(event.recipientUid),
        event.recipientUid,
      );

      doctorChatRoom = chatRoomId;

      debugPrint(
          'Emitting DoctorConsultationLoadedAppointmentState with chatRoomId: $chatRoomId');
      emit(DoctorConsultationLoadedAppointmentState(
          chatRoomId: chatRoomId!, recipientUid: event.recipientUid));
    } else {
      debugPrint('isFromChatRoomLists is false');
      final checkAppointmentForOnlineConsultation =
          await appointmentChatController.chatStatusDecider(
        appointmentId: selectedPatientAppointment!,
      );

      debugPrint(
          'DoctorConsultationGetRequestedAppointmentEvent selectedPatientAppointment: $selectedPatientAppointment');

      debugPrint(
          'DoctorConsultationGetRequestedAppointmentEvent checkAppointmentForOnlineConsultation: $checkAppointmentForOnlineConsultation');

      if (checkAppointmentForOnlineConsultation == 'canChat') {
        debugPrint('checkAppointmentForOnlineConsultation == canChat');
        isAppointmentFinished = false;
        isChatWaiting = false;
        final chatRoomId = await doctorChatMessageController.initChatRoom(
          doctorChatMessageController.generateRoomId(event.recipientUid),
          event.recipientUid,
        );

        chatRoom = chatRoomId;
        debugPrint(
            'Emitting DoctorConsultationLoadedAppointmentState with chatRoomId: $chatRoomId');
        emit(DoctorConsultationLoadedAppointmentState(
            chatRoomId: chatRoomId!, recipientUid: event.recipientUid));
      } else if (checkAppointmentForOnlineConsultation ==
          'appointmentNotStartedYet') {
        isChatWaiting = true;
        isAppointmentFinished = false;
        debugPrint(
            'checkAppointmentForOnlineConsultation == appointmentIsNotStartedYet');
        emit(DoctorConsultationWaitingForAppointmentState(
          appointment: selectedPatientAppointmentModel!,
        ));
      } else if (checkAppointmentForOnlineConsultation ==
          'waitingForTheAppointment') {
        debugPrint(
            'checkAppointmentForOnlineConsultation == waitingForTheAppointment');
        isChatWaiting = true;
        isAppointmentFinished = false;
        final chatRoomId = await doctorChatMessageController.initChatRoom(
          doctorChatMessageController.generateRoomId(event.recipientUid),
          event.recipientUid,
        );

        chatRoom = chatRoomId;
        debugPrint(
            'Emitting DoctorConsultationLoadedAppointmentState with chatRoomId: $chatRoomId');
        emit(DoctorConsultationLoadedAppointmentState(
            chatRoomId: chatRoomId!, recipientUid: event.recipientUid));
      } else if (checkAppointmentForOnlineConsultation == 'chatIsFinished' ||
          checkAppointmentForOnlineConsultation == 'missedAppointment') {
        debugPrint('checkAppointmentForOnlineConsultation == chatIsFinished');
        isAppointmentFinished = true;
        isChatWaiting = false;

        final chatRoomId = await doctorChatMessageController.initChatRoom(
          doctorChatMessageController.generateRoomId(event.recipientUid),
          event.recipientUid,
        );

        chatRoom = chatRoomId;
        debugPrint(
            'Emitting DoctorConsultationLoadedAppointmentState with chatRoomId: $chatRoomId');
        emit(DoctorConsultationLoadedAppointmentState(
            chatRoomId: chatRoomId!, recipientUid: event.recipientUid));
      } else if (checkAppointmentForOnlineConsultation ==
          'faceToFaceAppointment') {
        isChatWaiting = true;
        isAppointmentFinished = false;
        debugPrint(
            'checkAppointmentForOnlineConsultation == faceToFaceAppointment');
        final patientDetailsResult = await doctorAppointmentRequestController
            .getPatientData(patientUid: event.recipientUid);
        patientDetailsResult.fold(
          (failure) {
            emit(DoctorConsultationErrorAppointmentState(
                message: failure.toString()));
          },
          (patientDetails) {
            isF2FSession = true;
            f2fAppointmentStarted == true
                ? emit(DoctorConsultationF2FSessionStartedState())
                : f2fAppointmentEnded == true
                    ? emit(DoctorConsultationF2FSessionEndedState())
                    : emit(DoctorConsultationFaceToFaceAppointmentState(
                        patientDetails: patientDetails,
                      ));
          },
        );
      } else if (checkAppointmentForOnlineConsultation == 'invalid') {
        debugPrint('checkAppointmentForOnlineConsultation == invalid');
        isAppointmentFinished = false;
        isChatWaiting = false;
        emit(DoctorConsultationNoAppointmentState());
      } else {
        debugPrint(
            'Unexpected value for checkAppointmentForOnlineConsultation: $checkAppointmentForOnlineConsultation');
      }
    }
  }

  FutureOr<void> sendFirstMessageEvent(
      DoctorConsultationSendFirstMessageEvent event,
      Emitter<DoctorConsultationState> emit) async {
    await doctorChatMessageController.sendFirstMessage(
      message: event.message,
      recipient: event.recipient,
      appointment: selectedPatientAppointmentModel!,
    );
  }

  FutureOr<void> sendChatMessageEvent(
      DoctorConsultationSendChatMessageEvent event,
      Emitter<DoctorConsultationState> emit) async {
    await doctorChatMessageController.sendMessage(
      message: event.message,
      recipient: event.recipient,
      appointment: selectedPatientAppointmentModel!,
    );
  }

  FutureOr<void> completeDoctorConsultation(
      CompleteDoctorConsultationButtonEvent event,
      Emitter<DoctorConsultationState> emit) async {
    final result = await doctorAppointmentRequestController
        .completePatientAppointment(appointmentId: event.appointmentId);

    result.fold(
      (failure) {
        emit(DoctorConsultationErrorAppointmentState(
            message: failure.toString()));
      },
      (success) {
        emit(DoctorConsultationCompletedAppointmentState());
      },
    );
  }

  FutureOr<void> navigateToPatientDataEvent(NavigateToPatientDataEvent event,
      Emitter<DoctorConsultationState> emit) async {
    debugPrint(
        'PERIODS TRACE: NavigateToPatientData handler received periods: ${event.patientPeriods.length}');

    // Fetch patient data which may contain periods
    final patientData = await doctorAppointmentRequestController
        .getDoctorPatients(patientUid: event.appointment.patientUid!);

    final completedAppointmentsResults =
        await doctorAppointmentRequestController
            .getPatientCompletedAppointmentsWithCurrentDoctor(
                patientUid: event.appointment.patientUid!);

    patientData.fold(
      (failure) {
        emit(DoctorConsultationErrorAppointmentState(
            message: failure.toString()));
      },
      (patientData) {
        completedAppointmentsResults.fold((failure) {
          emit(DoctorConsultationErrorAppointmentState(
              message: failure.toString()));
        }, (completedAppointments) {
          // Determine which periods data to use
          List<PeriodTrackerModel> periodsToUse = [];

          // Check if periods came from the consultation menu
          if (event.patientPeriods.isNotEmpty) {
            // Use periods from the event (consultation menu path)
            debugPrint(
                'PERIODS TRACE: Using periods from event: ${event.patientPeriods.length}');
            periodsToUse = event.patientPeriods;
          }
          // Check if periods exist in patientData
          else if (patientData.patientPeriods.isNotEmpty) {
            // Use periods from patientData (e-consult path)
            debugPrint(
                'PERIODS TRACE: Using periods from patientData: ${patientData.patientPeriods.length}');
            periodsToUse = patientData.patientPeriods;
          }
          // Use global variable as last resort
          else if (patientPeriodsForPatientDataMenu != null &&
              patientPeriodsForPatientDataMenu!.isNotEmpty) {
            debugPrint(
                'PERIODS TRACE: Using global periods: ${patientPeriodsForPatientDataMenu!.length}');
            periodsToUse = patientPeriodsForPatientDataMenu!;
          }
          // If all else fails, try fetching periods directly
          else {
            debugPrint(
                'PERIODS TRACE: All periods sources empty, will fetch directly');
            // Store for potential async fetch - will be empty initially
            periodsToUse = [];

            // Start an async fetch that doesn't block navigation
            _fetchPeriodsForPatientAsync(event.appointment.patientUid!);
          }

          // Update the global variable for future reference
          patientPeriodsForPatientDataMenu = periodsToUse;

          debugPrint(
              'PERIODS TRACE: Final periods count for navigation: ${periodsToUse.length}');

          emit(NavigateToPatientDataState(
            patientData: event.patientData,
            appointment: event.appointment,
            patientPeriods: periodsToUse,
            patientAppointments: completedAppointments,
          ));
        });
      },
    );
  }

  // Helper method to fetch periods asynchronously without blocking navigation
  Future<void> _fetchPeriodsForPatientAsync(String patientUid) async {
    debugPrint('PERIODS TRACE: Attempting to fetch periods asynchronously');
    try {
      final periodsResult = await doctorAppointmentRequestController
          .getPatientPeriods(patientUid);

      periodsResult.fold((failure) {
        debugPrint('PERIODS TRACE: Async fetch failed: $failure');
      }, (periods) {
        debugPrint(
            'PERIODS TRACE: Async fetch succeeded: ${periods.length} periods');
        // Update global variable for future use
        patientPeriodsForPatientDataMenu = periods;
      });
    } catch (e) {
      debugPrint('PERIODS TRACE: Exception during async periods fetch: $e');
    }
  }

  FutureOr<void> checkStatusEvent(DoctorConsultationCheckStatusEvent event,
      Emitter<DoctorConsultationState> emit) async {
    debugPrint('checkStatusEvent triggered');

    final checkAppointmentForOnlineConsultation =
        await appointmentChatController.chatStatusDecider(
      appointmentId: event.appointmentId,
    );

    debugPrint(
        'DoctorConsultationCheckStatusEvent checkAppointmentForOnlineConsultation: $checkAppointmentForOnlineConsultation');

    if (checkAppointmentForOnlineConsultation == 'chatIsFinished' ||
        checkAppointmentForOnlineConsultation == 'missedAppointment') {
      debugPrint(
          'checkAppointmentForOnlineConsultation == chatIsFinished or missedAppointment');
      isAppointmentFinished = true;
    } else {
      isAppointmentFinished = false;
    }
  }

  FutureOr<void> beginF2FSessionEvent(
    BeginF2FSessionEvent event,
    Emitter<DoctorConsultationState> emit,
  ) async {
    // emit(DoctorConsultationF2FLoadingState());
    final result = await doctorAppointmentRequestController
        .beginF2FPatientAppointment(appointmentId: event.appointmentId);

    result.fold(
      (exception) {
        emit(DoctorConsultationErrorAppointmentState(
            message: exception.toString()));
      },
      (success) {
        f2fAppointmentStarted = true;
        emit(DoctorConsultationF2FSessionStartedState());
      },
    );
  }

  FutureOr<void> concludeF2FSessionEvent(ConcludeF2FSessionEvent event,
      Emitter<DoctorConsultationState> emit) async {
    // emit(DoctorConsultationF2FLoadingState());
    final result = await doctorAppointmentRequestController
        .concludeF2FPatientAppointment(appointmentId: event.appointmentId);

    result.fold(
      (exception) {
        emit(DoctorConsultationErrorAppointmentState(
            message: exception.toString()));
      },
      (success) {
        f2fAppointmentEnded = true;
        emit(DoctorConsultationF2FSessionEndedState());
      },
    );
  }

  Stream<AppointmentModel> doctorAppointmentStream(String appointmentId) {
    return doctorChatMessageController
        .getAppointmentStatusStream(appointmentId);
  }
}
