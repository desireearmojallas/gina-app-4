part of 'appointment_bloc.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object> get props => [];
}

class GetAppointmentsEvent extends AppointmentEvent {}

class NavigateToAppointmentDetailsEvent extends AppointmentEvent {
  final String doctorUid;
  final String appointmentUid;

  const NavigateToAppointmentDetailsEvent({
    required this.doctorUid,
    required this.appointmentUid,
  });

  @override
  List<Object> get props => [doctorUid, appointmentUid];
}

class NavigateToConsultationHistoryEvent extends AppointmentEvent {
  final String doctorUid;
  final String appointmentUid;

  const NavigateToConsultationHistoryEvent({
    required this.doctorUid,
    required this.appointmentUid,
  });

  @override
  List<Object> get props => [doctorUid, appointmentUid];
}

class ChooseImageEvent extends AppointmentEvent {}

class RemoveImageEvent extends AppointmentEvent {
  final int index;

  const RemoveImageEvent({required this.index});

  @override
  List<Object> get props => [index];
}

class UploadPrescriptionEvent extends AppointmentEvent {
  final String appointmentUid;
  final List<File> images;

  const UploadPrescriptionEvent({
    required this.appointmentUid,
    required this.images,
  });

  @override
  List<Object> get props => [appointmentUid, images];
}

class GetPrescriptionImagesEvent extends AppointmentEvent {
  final String appointmentUid;

  const GetPrescriptionImagesEvent({required this.appointmentUid});

  @override
  List<Object> get props => [appointmentUid];
}

class CancelAppointmentInAppointmentTabsEvent extends AppointmentEvent {
  final String appointmentUid;

  const CancelAppointmentInAppointmentTabsEvent({required this.appointmentUid});

  @override
  List<Object> get props => [appointmentUid];
}
