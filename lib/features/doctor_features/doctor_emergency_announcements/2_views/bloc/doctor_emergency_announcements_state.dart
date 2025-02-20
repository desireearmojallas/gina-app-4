part of 'doctor_emergency_announcements_bloc.dart';

abstract class DoctorEmergencyAnnouncementsState extends Equatable {
  const DoctorEmergencyAnnouncementsState();

  @override
  List<Object> get props => [];
}

abstract class DoctorEmergencyAnnouncementsActionState
    extends DoctorEmergencyAnnouncementsState {}

class DoctorEmergencyAnnouncementsInitial
    extends DoctorEmergencyAnnouncementsState {}

class DoctorEmergencyAnnouncementsLoading
    extends DoctorEmergencyAnnouncementsState {}

class DoctorEmergencyAnnouncementsLoaded
    extends DoctorEmergencyAnnouncementsState {
  final Map<DateTime, List<EmergencyAnnouncementModel>> emergencyAnnouncements;

  const DoctorEmergencyAnnouncementsLoaded(
      {required this.emergencyAnnouncements});

  @override
  List<Object> get props => [emergencyAnnouncements];
}

class DoctorEmergencyAnnouncementsError
    extends DoctorEmergencyAnnouncementsState {
  final String errorMessage;

  const DoctorEmergencyAnnouncementsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class DoctorEmergencyAnnouncementsEmpty
    extends DoctorEmergencyAnnouncementsState {}

class DoctorEmergencyGetApprovedPatientList
    extends DoctorEmergencyAnnouncementsState {
  final Map<DateTime, List<AppointmentModel>> approvedPatientList;

  const DoctorEmergencyGetApprovedPatientList(
      {required this.approvedPatientList});

  @override
  List<Object> get props => [approvedPatientList];
}

class CreateAnnouncementState extends DoctorEmergencyAnnouncementsState {}

class CreateAnnouncementLoadingState
    extends DoctorEmergencyAnnouncementsState {}

class SelectedAPatientState extends DoctorEmergencyAnnouncementsState {
  final AppointmentModel appointment;

  const SelectedAPatientState({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

class CreateEmergencyAnnouncementPostSuccessState
    extends DoctorEmergencyAnnouncementsActionState {}

class NavigateToDoctorCreatedAnnouncementState
    extends DoctorEmergencyAnnouncementsState {
  final EmergencyAnnouncementModel emergencyAnnouncement;

  const NavigateToDoctorCreatedAnnouncementState(
      {required this.emergencyAnnouncement});

  @override
  List<Object> get props => [emergencyAnnouncement];
}
