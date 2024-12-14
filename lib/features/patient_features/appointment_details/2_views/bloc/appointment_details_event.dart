part of 'appointment_details_bloc.dart';

abstract class AppointmentDetailsEvent extends Equatable {
  const AppointmentDetailsEvent();

  @override
  List<Object> get props => [];
}

class NavigateToAppointmentDetailsStatusEvent extends AppointmentDetailsEvent {}

class CancelAppointmentEvent extends AppointmentDetailsEvent {
  final String appointmentUid;

  const CancelAppointmentEvent({required this.appointmentUid});

  @override
  List<Object> get props => [appointmentUid];
}

class RescheduleAppointmentEvent extends AppointmentDetailsEvent {
  final String appointmentUid;
  final String appointmentDate;
  final String appointmentTime;
  final int modeOfAppointment;

  const RescheduleAppointmentEvent({
    required this.appointmentUid,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.modeOfAppointment,
  });

  @override
  List<Object> get props => [
        appointmentUid,
        appointmentDate,
        appointmentTime,
        modeOfAppointment,
      ];
}

class NavigateToReviewRescheduledAppointmentEvent
    extends AppointmentDetailsEvent {
  final String appointmentUid;

  const NavigateToReviewRescheduledAppointmentEvent(
      {required this.appointmentUid});

  @override
  List<Object> get props => [appointmentUid];
}
