part of 'emergency_announcements_bloc.dart';

abstract class EmergencyAnnouncementsEvent extends Equatable {
  const EmergencyAnnouncementsEvent();

  @override
  List<Object> get props => [];
}

class GetEmergencyAnnouncements extends EmergencyAnnouncementsEvent {}

class EmergencyNotificationReceivedEvent extends EmergencyAnnouncementsEvent {
  final EmergencyAnnouncementModel announcement;

  const EmergencyNotificationReceivedEvent(this.announcement);

  @override
  List<Object> get props => [announcement];
}

class MarkAnnouncementAsClickedEvent extends EmergencyAnnouncementsEvent {
  final String emergencyId;
  final String patientUid;

  const MarkAnnouncementAsClickedEvent({
    required this.emergencyId,
    required this.patientUid,
  });

  @override
  List<Object> get props => [emergencyId, patientUid];
}
