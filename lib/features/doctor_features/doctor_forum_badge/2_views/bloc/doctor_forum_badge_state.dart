part of 'doctor_forum_badge_bloc.dart';

abstract class DoctorForumBadgeState extends Equatable {
  const DoctorForumBadgeState();

  @override
  List<Object> get props => [];
}

abstract class DoctorForumBadgeActionState extends DoctorForumBadgeState {}

class DoctorForumBadgeInitial extends DoctorForumBadgeState {}

class DoctorForumBadgeLoadingState extends DoctorForumBadgeState {}

class DoctorForumBadgeScuccessState extends DoctorForumBadgeState {
  final DoctorModel doctorPost;

  const DoctorForumBadgeScuccessState({required this.doctorPost});

  @override
  List<Object> get props => [doctorPost];
}

class DoctorForumBadgeFailedState extends DoctorForumBadgeState {
  final String message;

  const DoctorForumBadgeFailedState({required this.message});

  @override
  List<Object> get props => [message];
}
