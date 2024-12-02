import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/1_controllers/doctor_profile_controller.dart';

part 'doctor_profile_update_event.dart';
part 'doctor_profile_update_state.dart';

class DoctorProfileUpdateBloc
    extends Bloc<DoctorProfileUpdateEvent, DoctorProfileUpdateState> {
  final DoctorProfileController doctorProfileController;
  DoctorProfileUpdateBloc({required this.doctorProfileController})
      : super(DoctorProfileUpdateInitial()) {
    on<EditDoctorProfileSaveButtonEvent>(editDoctorProfileSaveButtonEvent);
  }

  FutureOr<void> editDoctorProfileSaveButtonEvent(
      EditDoctorProfileSaveButtonEvent event,
      Emitter<DoctorProfileUpdateState> emit) async {
    emit(DoctorProfileUpdating());

    try {
      await doctorProfileController.editDoctorData(
        name: event.name,
        phoneNumber: event.phoneNumber,
        address: event.address,
      );
      emit(DoctorProfileUpdateSuccess());
    } catch (e) {
      emit(DoctorProfileUpdateError(message: e.toString()));
    }
  }
}
