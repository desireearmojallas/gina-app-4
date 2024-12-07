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

class SelectPatientEvent extends DoctorEmergencyAnnouncementsEvent {
  final AppointmentModel appointment;

  const SelectPatientEvent({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

class NavigateToDoctorCreatedAnnouncementEvent
    extends DoctorEmergencyAnnouncementsEvent {
  final EmergencyAnnouncementModel emergencyAnnouncement;

  const NavigateToDoctorCreatedAnnouncementEvent(
      {required this.emergencyAnnouncement});

  @override
  List<Object> get props => [emergencyAnnouncement];
}

class CreateEmergencyAnnouncementEvent
    extends DoctorEmergencyAnnouncementsEvent {
  final String message;
  final AppointmentModel appointment;

  const CreateEmergencyAnnouncementEvent(
      {required this.message, required this.appointment});

  @override
  List<Object> get props => [message, appointment];
}
