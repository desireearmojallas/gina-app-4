import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/profile/1_controllers/profile_controller.dart';

part 'floating_menu_event.dart';
part 'floating_menu_state.dart';

class FloatingMenuBloc extends Bloc<FloatingMenuEvent, FloatingMenuState> {
  final ProfileController profileController;
  FloatingMenuBloc({
    required this.profileController,
  }) : super(FloatingMenuInitial()) {
    on<FloatingMenuEvent>((event, emit) {});

    on<GetPatientNameEvent>(getPatientName);
  }

  FutureOr<void> getPatientName(
      GetPatientNameEvent event, Emitter<FloatingMenuState> emit) async {
    final currentPatientName = await profileController.getCurrentPatientName();
    emit(GetPatientName(patientName: currentPatientName));
  }
}
