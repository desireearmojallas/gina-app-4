part of 'doctor_forums_bloc.dart';

abstract class DoctorForumsEvent extends Equatable {
  const DoctorForumsEvent();

  @override
  List<Object> get props => [];
}

class DoctorForumsFetchRequestedEvent extends DoctorForumsEvent {}

class CreateDoctorForumsPostEvent extends DoctorForumsEvent {
  final String title;
  final String content;
  final Timestamp postedAt;

  const CreateDoctorForumsPostEvent({
    required this.title,
    required this.content,
    required this.postedAt,
  });

  @override
  List<Object> get props => [title, content, postedAt];
}

class NavigateToDoctorForumsDetailedPostEvent extends DoctorForumsEvent {
  final ForumModel docForumPost;
  final int doctorRatingId;

  const NavigateToDoctorForumsDetailedPostEvent({
    required this.docForumPost,
    required this.doctorRatingId,
  });

  @override
  List<Object> get props => [docForumPost, doctorRatingId];
}

class NavigateToDoctorForumsCreatePostEvent extends DoctorForumsEvent {}

class NavigateToDoctorForumsReplyPostEvent extends DoctorForumsEvent {
  final ForumModel docForumPost;

  const NavigateToDoctorForumsReplyPostEvent({required this.docForumPost});

  @override
  List<Object> get props => [docForumPost];

  get forumPost => null;
}

class CreateReplyDoctorForumsPostEvent extends DoctorForumsEvent {
  final ForumModel docForumPost;
  final String replyContent;
  final Timestamp repliedAt;

  const CreateReplyDoctorForumsPostEvent({
    required this.docForumPost,
    required this.replyContent,
    required this.repliedAt,
  });

  @override
  List<Object> get props => [docForumPost, replyContent, repliedAt];
}

class GetRepliesDoctorForumsPostRequestedEvent extends DoctorForumsEvent {
  final ForumModel docForumPost;

  const GetRepliesDoctorForumsPostRequestedEvent({
    required this.docForumPost,
  });

  @override
  List<Object> get props => [docForumPost];
}
