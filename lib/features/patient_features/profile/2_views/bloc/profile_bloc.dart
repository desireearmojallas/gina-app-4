import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/profile/1_controllers/profile_controller.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileController profileController;
  ProfileBloc({required this.profileController}) : super(ProfileInitial()) {
    on<GetProfileEvent>(getProfileEvent);
  }

  FutureOr<void> getProfileEvent(
      GetProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    final getProfileData = await profileController.getPatientProfile();
    //TODO: TO DELETE AWAIT FUTURE DELAYED : ONLY TO CHECK IS PROFILE LOADING IS WORKING
    await Future.delayed(const Duration(milliseconds: 1000));

    getProfileData
        .fold((failure) => emit(ProfileError(message: failure.toString())),
            (patientData) {
      // currentActivePatient = patientData;
      // TODO: IMPLEMENT ABOVE CURRENT ACTIVE PATIENT CONNECTED TO BOOK APPOINTMENT

      emit(ProfileLoaded(patientData: patientData));
    });
  }
}
