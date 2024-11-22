part of 'doctor_emergency_announcements_bloc.dart';

sealed class DoctorEmergencyAnnouncementsState extends Equatable {
  const DoctorEmergencyAnnouncementsState();
  
  @override
  List<Object> get props => [];
}

final class DoctorEmergencyAnnouncementsInitial extends DoctorEmergencyAnnouncementsState {}
