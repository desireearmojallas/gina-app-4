part of 'my_forums_bloc.dart';

abstract class MyForumsEvent extends Equatable {
  const MyForumsEvent();

  @override
  List<Object> get props => [];
}

class GetMyForumsPostEvent extends MyForumsEvent {}

class DeleteMyForumsPostEvent extends MyForumsEvent {
  final String forumUid;

  const DeleteMyForumsPostEvent({required this.forumUid});

  @override
  List<Object> get props => [forumUid];
}
