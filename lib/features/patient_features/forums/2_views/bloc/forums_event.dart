part of 'forums_bloc.dart';

abstract class ForumsEvent extends Equatable {
  const ForumsEvent();

  @override
  List<Object> get props => [];
}

class ForumsFetchRequestedEvent extends ForumsEvent {}

class CreateForumsPostEvent extends ForumsEvent {
  final String title;
  final String content;
  final Timestamp postedAt;

  const CreateForumsPostEvent({
    required this.title,
    required this.content,
    required this.postedAt,
  });

  @override
  List<Object> get props => [title, content, postedAt];
}

class NavigateToForumsDetailedPostEvent extends ForumsEvent {
  final ForumModel forumPost;
  final int doctorRatingId;

  const NavigateToForumsDetailedPostEvent({
    required this.forumPost,
    required this.doctorRatingId,
  });

  @override
  List<Object> get props => [forumPost, doctorRatingId];
}

class NavigateToForumsCreatePostEvent extends ForumsEvent {}

class NavigateToForumsReplyPostEvent extends ForumsEvent {
  final ForumModel forumPost;

  const NavigateToForumsReplyPostEvent({required this.forumPost});

  @override
  List<Object> get props => [forumPost];
}

class CreateReplyForumsPostEvent extends ForumsEvent {
  final ForumModel forumPost;
  final String replyContent;
  final Timestamp repliedAt;

  const CreateReplyForumsPostEvent({
    required this.forumPost,
    required this.replyContent,
    required this.repliedAt,
  });

  @override
  List<Object> get props => [forumPost, replyContent, repliedAt];
}

class GetRepliesForumsPostEvent extends ForumsEvent {
  final ForumModel forumPost;

  const GetRepliesForumsPostEvent({required this.forumPost});

  @override
  List<Object> get props => [forumPost];
}
