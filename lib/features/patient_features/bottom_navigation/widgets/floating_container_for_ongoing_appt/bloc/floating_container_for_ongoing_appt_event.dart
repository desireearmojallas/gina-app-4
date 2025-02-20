part of 'floating_container_for_ongoing_appt_bloc.dart';

sealed class FloatingContainerForOngoingApptEvent extends Equatable {
  const FloatingContainerForOngoingApptEvent();

  @override
  List<Object?> get props => [];
}

class CheckOngoingAppointments extends FloatingContainerForOngoingApptEvent {}

class ResetOngoingAppointments extends FloatingContainerForOngoingApptEvent {
  final bool clearDoctor;
  final bool clearAppointment;
  final bool notify;

  const ResetOngoingAppointments({
    this.clearDoctor = true,
    this.clearAppointment = true,
    this.notify = true,
  });

  @override
  List<Object?> get props => [clearDoctor, clearAppointment, notify];
}
