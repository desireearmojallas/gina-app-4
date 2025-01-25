import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/1_controllers/appointment_controller.dart';

part 'floating_container_for_ongoing_appt_event.dart';
part 'floating_container_for_ongoing_appt_state.dart';

class FloatingContainerForOngoingApptBloc extends Bloc<
    FloatingContainerForOngoingApptEvent,
    FloatingContainerForOngoingApptState> {
  final AppointmentController appointmentController;
  StreamSubscription<AppointmentModel?>? _ongoingAppointmentSubscription;

  FloatingContainerForOngoingApptBloc({
    required this.appointmentController,
  }) : super(FloatingContainerForOngoingApptLoading()) {
    on<CheckOngoingAppointments>(checkOngoingAppointments);
    on<ResetOngoingAppointments>(resetOngoingAppointments);
  }

  // This function listens for ongoing appointments and emits new states when the status changes
  FutureOr<void> checkOngoingAppointments(
    CheckOngoingAppointments event,
    Emitter<FloatingContainerForOngoingApptState> emit,
  ) async {
    try {
      emit(FloatingContainerForOngoingApptLoading());

      // Listen to the Firestore snapshot stream for real-time updates
      final snapshotStream =
          appointmentController.checkOngoingAppointmentStream();

      // Use await for the stream listening
      await for (var snapshot in snapshotStream) {
        // Your existing logic to process the snapshot
        final ongoingAppointment =
            snapshot; // Adjust based on the snapshot structure

        // Emit updated state to reflect the ongoing appointment or error
        if (ongoingAppointment != null) {
          emit(OngoingAppointmentFound(
            ongoingAppointment: ongoingAppointment,
          ));
        } else {
          emit(NoOngoingAppointments());
        }
      }
    } catch (error) {
      emit(OngoingAppointmentError(message: error.toString()));
    }
  }

  // Reset ongoing appointments state
  FutureOr<void> resetOngoingAppointments(
    ResetOngoingAppointments event,
    Emitter<FloatingContainerForOngoingApptState> emit,
  ) async {
    try {
      // Call the reset logic from the controller
      appointmentController.resetOnGoingAppointment(
        clearDoctor: event.clearDoctor,
        clearAppointment: event.clearAppointment,
        notify: event.notify,
      );

      emit(NoOngoingAppointments()); // Emit the default state
    } catch (error) {
      emit(OngoingAppointmentError(message: error.toString()));
    }
  }

  @override
  Future<void> close() {
    // Cancel the stream subscription when the bloc is closed
    _ongoingAppointmentSubscription?.cancel();
    return super.close();
  }
}
