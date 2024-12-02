import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/1_controllers/doctor_profile_controller.dart';

part 'doctor_profile_event.dart';
part 'doctor_profile_state.dart';

int? profileDoctorRatingId;

class DoctorProfileBloc extends Bloc<DoctorProfileEvent, DoctorProfileState> {
  final DoctorProfileController doctorProfileController;
  DoctorProfileBloc({required this.doctorProfileController})
      : super(DoctorProfileInitial()) {
    on<GetDoctorProfileEvent>(getDoctorProfileEvent);
    on<NavigateToEditDoctorProfileEvent>(navigateToEditDoctorProfileEvent);
    on<DoctorProfileNavigateToMyForumsPostEvent>(
        profileNavigateToMyForumsPostEvent);
  }

  FutureOr<void> getDoctorProfileEvent(
      GetDoctorProfileEvent event, Emitter<DoctorProfileState> emit) async {
    emit(DoctorProfileLoading());

    final getProfileData = await doctorProfileController.getDoctorProfile();

    getProfileData.fold(
      (failure) {
        emit(DoctorProfileError(message: failure.toString()));
      },
      (doctorData) {
        profileDoctorRatingId = doctorData.doctorRatingId;
        emit(DoctorProfileLoaded(
          doctorData: doctorData,
        ));
      },
    );
  }

  FutureOr<void> navigateToEditDoctorProfileEvent(
      NavigateToEditDoctorProfileEvent event,
      Emitter<DoctorProfileState> emit) async {
    emit(DoctorProfileLoading());

    final getProfileData = await doctorProfileController.getDoctorProfile();

    getProfileData.fold(
      (failure) {
        emit(DoctorProfileError(message: failure.toString()));
      },
      (doctorData) {
        emit(NavigateToEditDoctorProfileState(
          doctorData: doctorData,
        ));
      },
    );
  }

  FutureOr<void> profileNavigateToMyForumsPostEvent(
      DoctorProfileNavigateToMyForumsPostEvent event,
      Emitter<DoctorProfileState> emit) {
    emit(DoctorProfileNavigateToMyForumsPostState());
  }
}
