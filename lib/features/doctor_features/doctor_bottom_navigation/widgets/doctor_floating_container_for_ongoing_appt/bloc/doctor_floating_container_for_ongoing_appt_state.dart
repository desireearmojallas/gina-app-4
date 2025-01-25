part of 'doctor_floating_container_for_ongoing_appt_bloc.dart';

sealed class DoctorFloatingContainerForOngoingApptState extends Equatable {
  const DoctorFloatingContainerForOngoingApptState();

  @override
  List<Object> get props => [];
}

final class DoctorFloatingContainerForOngoingApptLoading
    extends DoctorFloatingContainerForOngoingApptState {}

final class DoctorNoOngoingAppointments
    extends DoctorFloatingContainerForOngoingApptState {}

class DoctorOngoingAppointmentFound
    extends DoctorFloatingContainerForOngoingApptState {
  final AppointmentModel ongoingAppointment;

  const DoctorOngoingAppointmentFound({required this.ongoingAppointment});

  @override
  List<Object> get props => [ongoingAppointment];
}

class DoctorOngoingAppointmentError
    extends DoctorFloatingContainerForOngoingApptState {
  final String message;

  const DoctorOngoingAppointmentError({required this.message});

  @override
  List<Object> get props => [message];
}
