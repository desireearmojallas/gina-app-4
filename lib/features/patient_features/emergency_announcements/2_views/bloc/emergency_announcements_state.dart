part of 'emergency_announcements_bloc.dart';

abstract class EmergencyAnnouncementsState extends Equatable {
  const EmergencyAnnouncementsState();

  @override
  List<Object> get props => [];
}

class EmergencyAnnouncementsInitial extends EmergencyAnnouncementsState {}

class EmergencyAnnouncementsLoaded extends EmergencyAnnouncementsState {
  final EmergencyAnnouncementModel emergencyAnnouncement;
  final String doctorMedicalSpecialty;

  const EmergencyAnnouncementsLoaded({
    required this.emergencyAnnouncement,
    required this.doctorMedicalSpecialty,
  });

  @override
  List<Object> get props => [emergencyAnnouncement];
}

class EmergencyAnnouncementsError extends EmergencyAnnouncementsState {
  final String message;

  const EmergencyAnnouncementsError(this.message);

  @override
  List<Object> get props => [message];
}

class EmergencyAnnouncementsLoading extends EmergencyAnnouncementsState {}
