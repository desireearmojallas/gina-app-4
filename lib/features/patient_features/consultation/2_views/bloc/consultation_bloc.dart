import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/1_controllers/appointment_chat_controller.dart';
import 'package:gina_app_4/features/patient_features/consultation/1_controllers/chat_message_controllers.dart';

part 'consultation_event.dart';
part 'consultation_state.dart';

String? chatRoom;
bool isAppointmentFinished = false;
bool isChatWaiting = false;
AppointmentModel? selectedDoctorAppointmentModel;

class ConsultationBloc extends Bloc<ConsultationEvent, ConsultationState> {
  final AppointmentChatController appointmentChatController;
  final ChatMessageController chatMessageController;
  ConsultationBloc({
    required this.appointmentChatController,
    required this.chatMessageController,
  }) : super(ConsultationInitial()) {
    on<ConsultationGetRequestedAppointmentEvent>(
        consultationGetRequestedAppointmentEvent);
    on<SendFirstMessageEvent>(sendFirstMessageEvent);
    on<SendChatMessageEvent>(sendChatMessageEvent);
  }

  FutureOr<void> consultationGetRequestedAppointmentEvent(
      ConsultationGetRequestedAppointmentEvent event,
      Emitter<ConsultationState> emit) async {
    if (isFromConsultationHistory) {
      final chatRoomId = await chatMessageController.initChatRoom(
        chatMessageController.generateRoomId(event.recipientUid),
        event.recipientUid,
      );

      chatRoom = chatRoomId;

      debugPrint(
          'Emitting ConsultationLoadedAppointmentState with chatRoomId: $chatRoomId');
      emit(ConsultationLoadedAppointmentState(
          chatRoomId: chatRoomId!, recipientUid: event.recipientUid));
    } else {
      debugPrint('isFromConsultationHistory is false');
      final checkAppointmentForOnlineConsultation =
          await appointmentChatController.chatStatusDecider(
        appointmentId: storedAppointmentUid!,
      );

      debugPrint(
          'ConsultationGetRequestedAppointmentEvent selectedPatientAppointment: $storedAppointmentUid');

      debugPrint(
          'DoctorConsultationGetRequestedAppointmentEvent checkAppointmentForOnlineConsultation: $checkAppointmentForOnlineConsultation');

      if (checkAppointmentForOnlineConsultation == 'canChat') {
        debugPrint('checkAppointmentForOnlineConsultation == canChat');
        isAppointmentFinished = false;
        isChatWaiting = false;
        final chatRoomId = await chatMessageController.initChatRoom(
          chatMessageController.generateRoomId(event.recipientUid),
          event.recipientUid,
        );

        chatRoom = chatRoomId;
        debugPrint(
            'Emitting DoctorConsultationLoadedAppointmentState with chatRoomId: $chatRoomId');
        emit(ConsultationLoadedAppointmentState(
            chatRoomId: chatRoomId!, recipientUid: event.recipientUid));
      } else if (checkAppointmentForOnlineConsultation ==
          'appointmentNotStartedYet') {
        debugPrint(
            'checkAppointmentForOnlineConsultation == appointmentIsNotStartedYet');
        emit(ConsultationWaitingForAppointmentState(
          appointment: selectedDoctorAppointmentModel!,
        ));
      } else if (checkAppointmentForOnlineConsultation ==
          'waitingForTheAppointment') {
        debugPrint(
            'checkAppointmentForOnlineConsultation == waitingForTheAppointment');
        isChatWaiting = true;
        isAppointmentFinished = false;
        final chatRoomId = await chatMessageController.initChatRoom(
          chatMessageController.generateRoomId(event.recipientUid),
          event.recipientUid,
        );

        chatRoom = chatRoomId;
        debugPrint(
            'Emitting DoctorConsultationLoadedAppointmentState with chatRoomId: $chatRoomId');
        emit(ConsultationLoadedAppointmentState(
            chatRoomId: chatRoomId!, recipientUid: event.recipientUid));
      } else if (checkAppointmentForOnlineConsultation == 'chatIsFinished') {
        debugPrint('checkAppointmentForOnlineConsultation == chatIsFinished');
        isAppointmentFinished = true;
        isChatWaiting = false;

        final chatRoomId = await chatMessageController.initChatRoom(
          chatMessageController.generateRoomId(event.recipientUid),
          event.recipientUid,
        );

        chatRoom = chatRoomId;
        debugPrint(
            'Emitting DoctorConsultationLoadedAppointmentState with chatRoomId: $chatRoomId');
        emit(ConsultationLoadedAppointmentState(
            chatRoomId: chatRoomId!, recipientUid: event.recipientUid));
      } else if (checkAppointmentForOnlineConsultation ==
          'faceToFaceAppointment') {
        debugPrint(
            'checkAppointmentForOnlineConsultation == faceToFaceAppointment');
        emit(ConsultationFaceToFaceAppointmentState(
          appointment: selectedDoctorAppointmentModel!,
        ));
      } else if (checkAppointmentForOnlineConsultation == 'invalid') {
        debugPrint('checkAppointmentForOnlineConsultation == invalid');
        isAppointmentFinished = false;
        isChatWaiting = false;
        emit(ConsultationNoAppointmentState());
      } else {
        debugPrint(
            'Unexpected value for checkAppointmentForOnlineConsultation: $checkAppointmentForOnlineConsultation');
      }
    }
  }

  FutureOr<void> sendFirstMessageEvent(
      SendFirstMessageEvent event, Emitter<ConsultationState> emit) async {
    await chatMessageController.sendFirstMessage(
      message: event.message,
      recipient: event.recipient,
      appointment: selectedDoctorAppointmentModel!,
    );
  }

  FutureOr<void> sendChatMessageEvent(
      SendChatMessageEvent event, Emitter<ConsultationState> emit) async {
    await chatMessageController.sendMessage(
      recipient: event.recipient,
      message: event.message,
      appointment: selectedDoctorAppointmentModel!,
    );
  }

  Stream<AppointmentModel> patientAppointmentStream(String appointmentId) {
    return chatMessageController.getAppointmentStatusStream(appointmentId);
  }
}
