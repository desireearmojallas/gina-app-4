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
            emit(DoctorConsultationFaceToFaceAppointmentState(
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
    final patientData = await doctorAppointmentRequestController
        .getDoctorPatients(patientUid: event.appointment.patientUid!);

    patientData.fold(
      (failure) {
        emit(DoctorConsultationErrorAppointmentState(
            message: failure.toString()));
      },
      (patientData) {
        emit(NavigateToPatientDataState(
          patientData: event.patientData,
          appointment: event.appointment,
          patientPeriods: patientData.patientPeriods,
          patientAppointments: patientData.patientAppointments,
        ));
      },
    );
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
}
