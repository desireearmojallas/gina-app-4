import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/profile/1_controllers/profile_controller.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileController profileController;
  ProfileBloc({required this.profileController}) : super(ProfileInitial()) {
    on<GetProfileEvent>(getProfileEvent);
    on<NavigateToEditProfileEvent>(navigateToEditProfileEvent);
    on<ProfileNavigateToCycleHistoryEvent>(profileNavigateToCycleHistoryEvent);
    on<ProfileNavigateToMyForumsPostEvent>(profileNavigateToMyForumsPostEvent);
  }

  FutureOr<void> getProfileEvent(
      GetProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    final getProfileData = await profileController.getPatientProfile();

    getProfileData
        .fold((failure) => emit(ProfileError(message: failure.toString())),
            (patientData) {
      currentActivePatient = patientData;

      emit(ProfileLoaded(patientData: patientData));
    });
  }

  FutureOr<void> navigateToEditProfileEvent(
      NavigateToEditProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    final getProfileData = await profileController.getPatientProfile();

    getProfileData.fold(
      (failure) => emit(ProfileError(message: failure.toString())),
      (patientData) =>
          emit(NavigateToEditProfileState(patientData: patientData)),
    );
  }

  FutureOr<void> profileNavigateToCycleHistoryEvent(
      ProfileNavigateToCycleHistoryEvent event, Emitter<ProfileState> emit) {
    emit(ProfileNavigateToCycleHistoryState());
  }

  FutureOr<void> profileNavigateToMyForumsPostEvent(
      ProfileNavigateToMyForumsPostEvent event, Emitter<ProfileState> emit) {
    emit(ProfileNavigateToMyForumsPostState());
  }
}
