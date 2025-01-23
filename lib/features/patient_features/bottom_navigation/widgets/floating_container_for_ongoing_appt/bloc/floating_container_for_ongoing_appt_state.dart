part of 'floating_container_for_ongoing_appt_bloc.dart';

sealed class FloatingContainerForOngoingApptState extends Equatable {
  const FloatingContainerForOngoingApptState();

  @override
  List<Object?> get props => [];
}

final class FloatingContainerForOngoingApptLoading
    extends FloatingContainerForOngoingApptState {}

final class NoOngoingAppointments
    extends FloatingContainerForOngoingApptState {}

class OngoingAppointmentFound extends FloatingContainerForOngoingApptState {
  final AppointmentModel ongoingAppointment;

  const OngoingAppointmentFound({required this.ongoingAppointment});

  @override
  List<Object?> get props => [ongoingAppointment];
}

class OngoingAppointmentError extends FloatingContainerForOngoingApptState {
  final String message;

  const OngoingAppointmentError({required this.message});

  @override
  List<Object?> get props => [message];
}
