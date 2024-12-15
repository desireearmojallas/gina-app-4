import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/1_controllers/doctor_chat_message_controller.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation/1_controllers/appointment_chat_controller.dart';

part 'consultation_event.dart';
part 'consultation_state.dart';

String? chatRoom;
bool isAppointmentFinished = false;
bool isChatWaiting = false;

class ConsultationBloc extends Bloc<ConsultationEvent, ConsultationState> {
  final AppointmentChatController appointmentChatController;
  final DoctorChatMessageController chatMessageController;
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
      final chatroomId = await chatMessageController.initChatRoom(
        chatMessageController.generateRoomId(event.recipientUid),
        event.recipientUid,
      );

      chatRoom = chatroomId;
      emit(ConsultationLoadedAppointmentState(
          chatroomId: chatroomId!, recipientUid: event.recipientUid));
    } else {
      final checkAppointmentForOnlineConsultation =
          await appointmentChatController.chatStatusDecider(
        appointmentId: storedAppointmentUid!,
      );

      if (checkAppointmentForOnlineConsultation == 'canChat') {
        isAppointmentFinished = false;
        isChatWaiting = false;
        final chatroomId = await chatMessageController.initChatRoom(
          chatMessageController.generateRoomId(event.recipientUid),
          event.recipientUid,
        );

        chatRoom = chatroomId;
        emit(ConsultationLoadedAppointmentState(
          chatroomId: chatroomId!,
          recipientUid: event.recipientUid,
        ));
      } else if (checkAppointmentForOnlineConsultation ==
          'appointmentIsNotStartedYet') {
        emit(ConsultationWaitingAppointmentState());
      } else if (checkAppointmentForOnlineConsultation ==
          'waitingForTheAppointment') {
        isChatWaiting = true;
        isAppointmentFinished = false;
        final chatroomId = await chatMessageController.initChatRoom(
          chatMessageController.generateRoomId(event.recipientUid),
          event.recipientUid,
        );

        chatRoom = chatroomId;
        emit(ConsultationLoadedAppointmentState(
            chatroomId: chatroomId!, recipientUid: event.recipientUid));
      } else if (checkAppointmentForOnlineConsultation == 'chatIsFinished') {
        isAppointmentFinished = true;
        isChatWaiting = false;

        final chatroomId = await chatMessageController.initChatRoom(
          chatMessageController.generateRoomId(event.recipientUid),
          event.recipientUid,
        );

        chatRoom = chatroomId;
        emit(ConsultationLoadedAppointmentState(
            chatroomId: chatroomId!, recipientUid: event.recipientUid));
      } else if (checkAppointmentForOnlineConsultation == 'invalid') {
        isAppointmentFinished = false;
        isChatWaiting = false;
        emit(ConsultationNoAppointmentState());
      }
    }
  }

  FutureOr<void> sendFirstMessageEvent(
      SendFirstMessageEvent event, Emitter<ConsultationState> emit) async {
    await chatMessageController.sendFirstMessage(
      message: event.message,
      recipient: event.recipient,
    );
  }

  FutureOr<void> sendChatMessageEvent(
      SendChatMessageEvent event, Emitter<ConsultationState> emit) async {
    await chatMessageController.sendMessage(
      recipient: event.recipient,
      message: event.message,
    );
  }
}
