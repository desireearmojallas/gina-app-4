import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/1_controllers/doctor_appointment_request_controller.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

part 'doctor_floating_container_for_ongoing_appt_event.dart';
part 'doctor_floating_container_for_ongoing_appt_state.dart';

class DoctorFloatingContainerForOngoingApptBloc extends Bloc<
    DoctorFloatingContainerForOngoingApptEvent,
    DoctorFloatingContainerForOngoingApptState> {
  final DoctorAppointmentRequestController doctorAppointmentRequestController;
  StreamSubscription<AppointmentModel?>? _ongoingAppointmentSubscription;

  DoctorFloatingContainerForOngoingApptBloc({
    required this.doctorAppointmentRequestController,
  }) : super(DoctorFloatingContainerForOngoingApptLoading()) {
    on<DoctorCheckOngoingAppointments>(doctorCheckOngoingAppointments);
    on<DoctorResetOngoingAppointments>(doctorResetOngoingAppointments);
  }

  FutureOr<void> doctorCheckOngoingAppointments(
      DoctorCheckOngoingAppointments event,
      Emitter<DoctorFloatingContainerForOngoingApptState> emit) async {
    try {
      emit(DoctorFloatingContainerForOngoingApptLoading());

      final snapshotStream =
          doctorAppointmentRequestController.checkOnGoingAppointmentStream();

      await for (var snapshot in snapshotStream) {
        final ongoingAppointment = snapshot;

        if (ongoingAppointment != null) {
          emit(DoctorOngoingAppointmentFound(
            ongoingAppointment: ongoingAppointment,
          ));
        } else {
          emit(DoctorNoOngoingAppointments());
        }
      }
    } catch (error) {
      emit(DoctorOngoingAppointmentError(message: error.toString()));
    }
  }

  FutureOr<void> doctorResetOngoingAppointments(
      DoctorResetOngoingAppointments event,
      Emitter<DoctorFloatingContainerForOngoingApptState> emit) async {
    try {
      doctorAppointmentRequestController.resetOnGoingAppointment(
        clearDoctor: event.clearDoctor,
        clearAppointment: event.clearAppointment,
        notify: event.notify,
      );

      emit(DoctorNoOngoingAppointments());
    } catch (e) {
      emit(DoctorOngoingAppointmentError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    // Cancel the stream subscription when the bloc is closed
    _ongoingAppointmentSubscription?.cancel();
    return super.close();
  }
}
