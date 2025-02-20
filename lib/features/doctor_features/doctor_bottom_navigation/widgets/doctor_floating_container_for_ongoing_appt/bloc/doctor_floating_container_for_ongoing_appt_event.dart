part of 'doctor_floating_container_for_ongoing_appt_bloc.dart';

sealed class DoctorFloatingContainerForOngoingApptEvent extends Equatable {
  const DoctorFloatingContainerForOngoingApptEvent();

  @override
  List<Object> get props => [];
}

class DoctorCheckOngoingAppointments
    extends DoctorFloatingContainerForOngoingApptEvent {}

class DoctorResetOngoingAppointments
    extends DoctorFloatingContainerForOngoingApptEvent {
  final bool clearDoctor;
  final bool clearAppointment;
  final bool notify;

  const DoctorResetOngoingAppointments({
    this.clearDoctor = true,
    this.clearAppointment = true,
    this.notify = true,
  });

  @override
  List<Object> get props => [clearDoctor, clearAppointment, notify];
}
