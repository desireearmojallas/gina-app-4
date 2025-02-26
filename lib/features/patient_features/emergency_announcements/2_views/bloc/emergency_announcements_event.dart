part of 'emergency_announcements_bloc.dart';

abstract class EmergencyAnnouncementsEvent extends Equatable {
  const EmergencyAnnouncementsEvent();

  @override
  List<Object> get props => [];
}

class GetEmergencyAnnouncements extends EmergencyAnnouncementsEvent {}
