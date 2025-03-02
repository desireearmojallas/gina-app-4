import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/1_controllers/doctor_consultation_fee_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forum_badge/1_controller/doctor_forum_badge_controller.dart';

part 'doctor_forum_badge_event.dart';
part 'doctor_forum_badge_state.dart';

class DoctorForumBadgeBloc
    extends Bloc<DoctorForumBadgeEvent, DoctorForumBadgeState> {
  final DoctorConsultationFeeController doctorConsultationFeeController;
  final DoctorForumBadgeController doctorForumBadgeController;
  DoctorForumBadgeBloc(
      {required this.doctorConsultationFeeController,
      required this.doctorForumBadgeController})
      : super(DoctorForumBadgeInitial()) {
    on<GetForumBadgeEvent>(getDoctorForumsPost);
  }
  FutureOr<void> getDoctorForumsPost(
      GetForumBadgeEvent event, Emitter<DoctorForumBadgeState> emit) async {
    emit(DoctorForumBadgeLoadingState());

    await doctorForumBadgeController.getDoctorPostsCount();

    final getForumsPosts =
        await doctorConsultationFeeController.getCurrentDoctor();

    getForumsPosts.fold(
      (failure) =>
          emit(DoctorForumBadgeFailedState(message: failure.toString())),
      (doctorPost) {
        emit(DoctorForumBadgeScuccessState(
          doctorPost: doctorPost,
        ));
      },
    );
  }
}
