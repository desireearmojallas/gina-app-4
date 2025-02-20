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

  FutureOr<void> checkOngoingAppointments(
    CheckOngoingAppointments event,
    Emitter<FloatingContainerForOngoingApptState> emit,
  ) async {
    try {
      emit(FloatingContainerForOngoingApptLoading());

      final snapshotStream =
          appointmentController.checkOngoingAppointmentStream();

      await for (var snapshot in snapshotStream) {
        final ongoingAppointment = snapshot;

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

  FutureOr<void> resetOngoingAppointments(
    ResetOngoingAppointments event,
    Emitter<FloatingContainerForOngoingApptState> emit,
  ) async {
    try {
      appointmentController.resetOnGoingAppointment(
        clearDoctor: event.clearDoctor,
        clearAppointment: event.clearAppointment,
        notify: event.notify,
      );

      emit(NoOngoingAppointments());
    } catch (error) {
      emit(OngoingAppointmentError(message: error.toString()));
    }
  }

  @override
  Future<void> close() {
    _ongoingAppointmentSubscription?.cancel();
    return super.close();
  }
}
