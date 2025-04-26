part of 'emergency_announcements_bloc.dart';

abstract class EmergencyAnnouncementsState extends Equatable {
  const EmergencyAnnouncementsState();

  @override
  List<Object> get props => [];
}

class EmergencyAnnouncementsInitial extends EmergencyAnnouncementsState {}

class EmergencyAnnouncementsLoaded extends EmergencyAnnouncementsState {
  final List<EmergencyAnnouncementModel> emergencyAnnouncements;
  final String doctorMedicalSpecialty;

  const EmergencyAnnouncementsLoaded({
    required this.emergencyAnnouncements,
    required this.doctorMedicalSpecialty,
  });

  @override
  List<Object> get props => [emergencyAnnouncements];
}

class EmergencyAnnouncementsError extends EmergencyAnnouncementsState {
  final String message;

  const EmergencyAnnouncementsError(this.message);

  @override
  List<Object> get props => [message];
}

class EmergencyAnnouncementsLoading extends EmergencyAnnouncementsState {}

class EmergencyNotificationReceivedState extends EmergencyAnnouncementsState {
  final EmergencyAnnouncementModel announcement;

  const EmergencyNotificationReceivedState(this.announcement);

  @override
  List<Object> get props => [announcement];
}
