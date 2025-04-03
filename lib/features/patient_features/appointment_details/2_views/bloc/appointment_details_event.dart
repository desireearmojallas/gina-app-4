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
  final DoctorModel doctor;
  final String appointmentUid;
  final String appointmentDate;
  final String appointmentTime;

  const RescheduleAppointmentEvent({
    required this.doctor,
    required this.appointmentUid,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  @override
  List<Object> get props => [
        doctor,
        appointmentUid,
        appointmentDate,
        appointmentTime,
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

class FetchLatestAppointmentDetailsEvent extends AppointmentDetailsEvent {
  final String appointmentUid;

  const FetchLatestAppointmentDetailsEvent({required this.appointmentUid});

  @override
  List<Object> get props => [appointmentUid];
}
