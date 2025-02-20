part of 'doctor_my_forums_bloc.dart';

abstract class DoctorMyForumsEvent extends Equatable {
  const DoctorMyForumsEvent();

  @override
  List<Object> get props => [];
}

class GetMyDoctorForumsPostEvent extends DoctorMyForumsEvent {}

class DeleteMyForumsPostEvent extends DoctorMyForumsEvent {
  final String forumUid;

  const DeleteMyForumsPostEvent({required this.forumUid});

  @override
  List<Object> get props => [forumUid];
}
