import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/profile/1_controllers/profile_controller.dart';

part 'profile_update_event.dart';
part 'profile_update_state.dart';

class ProfileUpdateBloc extends Bloc<ProfileUpdateEvent, ProfileUpdateState> {
  final ProfileController profileController;
  ProfileUpdateBloc({
    required this.profileController,
  }) : super(ProfileUpdateInitial()) {
    on<EditProfileSaveButtonEvent>(editProfileSaveButtonEvent);
  }

  FutureOr<void> editProfileSaveButtonEvent(EditProfileSaveButtonEvent event,
      Emitter<ProfileUpdateState> emit) async {
    emit(ProfileUpdating());

    try {
      await profileController.editPatientData(
        name: event.name,
        dateOfBirth: event.dateOfBirth,
        address: event.address,
      );
      emit(ProfileUpdateSuccess());
    } catch (e) {
      emit(
        ProfileUpdateError(
          message: e.toString(),
        ),
      );
    }
  }
}
