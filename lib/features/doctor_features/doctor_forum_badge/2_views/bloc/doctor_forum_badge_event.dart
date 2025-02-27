part of 'doctor_forum_badge_bloc.dart';

sealed class DoctorForumBadgeEvent extends Equatable {
  const DoctorForumBadgeEvent();

  @override
  List<Object> get props => [];
}

class DoctorForumBadgeInitialEvent extends DoctorForumBadgeEvent {}

class GetForumBadgeEvent extends DoctorForumBadgeEvent {}
