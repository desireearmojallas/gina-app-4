part of 'doctor_forum_badge_bloc.dart';

sealed class DoctorForumBadgeState extends Equatable {
  const DoctorForumBadgeState();
  
  @override
  List<Object> get props => [];
}

final class DoctorForumBadgeInitial extends DoctorForumBadgeState {}
