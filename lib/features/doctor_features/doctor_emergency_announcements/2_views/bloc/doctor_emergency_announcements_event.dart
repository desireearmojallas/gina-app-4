part of 'doctor_emergency_announcements_bloc.dart';

abstract class DoctorEmergencyAnnouncementsEvent extends Equatable {
  const DoctorEmergencyAnnouncementsEvent();

  @override
  List<Object> get props => [];
}

class GetDoctorEmergencyAnnouncementsEvent
    extends DoctorEmergencyAnnouncementsEvent {}

class NavigateToDoctorEmergencyCreateAnnouncementEvent
    extends DoctorEmergencyAnnouncementsEvent {}

class NavigateToPatientList extends DoctorEmergencyAnnouncementsEvent {}

class SelectPatientsEvent extends DoctorEmergencyAnnouncementsEvent {
  final List<AppointmentModel> selectedAppointments;

  const SelectPatientsEvent({required this.selectedAppointments});

  @override
  List<Object> get props => [selectedAppointments];
}

class NavigateToDoctorCreatedAnnouncementEvent
    extends DoctorEmergencyAnnouncementsEvent {
  final EmergencyAnnouncementModel emergencyAnnouncement;
  final String appointmentUid;

  const NavigateToDoctorCreatedAnnouncementEvent(
      {required this.emergencyAnnouncement, required this.appointmentUid});

  @override
  List<Object> get props => [emergencyAnnouncement, appointmentUid];
}

class CreateEmergencyAnnouncementEvent
    extends DoctorEmergencyAnnouncementsEvent {
  final String message;
  final List<AppointmentModel> appointments;

  const CreateEmergencyAnnouncementEvent({
    required this.message,
    required this.appointments,
  });

  // For backwards compatibility with code that expects a single appointment
  AppointmentModel? get appointment =>
      appointments.isNotEmpty ? appointments.first : null;

  @override
  List<Object> get props => [message, appointments];
}

class DeleteEmergencyAnnouncementEvent
    extends DoctorEmergencyAnnouncementsEvent {
  final EmergencyAnnouncementModel emergencyAnnouncement;

  const DeleteEmergencyAnnouncementEvent({required this.emergencyAnnouncement});

  @override
  List<Object> get props => [emergencyAnnouncement];
}

class AddPatientToSelectionEvent extends DoctorEmergencyAnnouncementsEvent {
  final AppointmentModel appointment;

  const AddPatientToSelectionEvent({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

class RemovePatientFromSelectionEvent
    extends DoctorEmergencyAnnouncementsEvent {
  final AppointmentModel appointment;

  const RemovePatientFromSelectionEvent({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

class TogglePatientSelectionEvent extends DoctorEmergencyAnnouncementsEvent {
  final AppointmentModel appointment;
  final bool isSelected;

  const TogglePatientSelectionEvent({
    required this.appointment,
    required this.isSelected,
  });

  @override
  List<Object> get props => [appointment, isSelected];
}
