part of 'forums_bloc.dart';

abstract class ForumsState extends Equatable {
  const ForumsState();

  @override
  List<Object> get props => [];
}

abstract class ForumsActionState extends ForumsState {}

class ForumsInitial extends ForumsState {}

class GetForumsPostsSuccessState extends ForumsState {
  final List<ForumModel> forumsPosts;
  final List<int> doctorRatingIds;

  const GetForumsPostsSuccessState({
    required this.forumsPosts,
    required this.doctorRatingIds,
  });

  @override
  List<Object> get props => [forumsPosts, doctorRatingIds];
}

class GetForumsPostsFailedState extends ForumsState {
  final String message;

  const GetForumsPostsFailedState({required this.message});

  @override
  List<Object> get props => [message];
}

class GetForumsPostsLoadingState extends ForumsState {}

class GetForumsPostsEmptyState extends ForumsState {}

class NavigateToForumsDetailedPostState extends ForumsState {
  final ForumModel forumPost;
  final List<ForumModel> forumReplies;
  final int doctorRatingId;
  final User? currentUser;

  const NavigateToForumsDetailedPostState({
    required this.forumPost,
    required this.forumReplies,
    required this.doctorRatingId,
    required this.currentUser,
  });

  @override
  List<Object> get props =>
      [forumPost, forumReplies, doctorRatingId, currentUser!];
}

class NavigateToForumsCreatePostState extends ForumsActionState {}

class NavigateToForumsReplyPostState extends ForumsState {
  final ForumModel forumPost;

  const NavigateToForumsReplyPostState({required this.forumPost});

  @override
  List<Object> get props => [forumPost];
}

class GetRepliesForumsPostSuccessState extends ForumsState {
  final ForumModel forumPost;
  final List<ForumModel> forumReplies;
  final int doctorRatingId;
  final User? currentUser;

  const GetRepliesForumsPostSuccessState({
    required this.forumPost,
    required this.forumReplies,
    required this.doctorRatingId,
    required this.currentUser,
  });

  @override
  List<Object> get props => [forumPost, forumReplies, currentUser!];
}

class GetRepliesForumsPostFailedState extends ForumsState {
  final String message;

  const GetRepliesForumsPostFailedState({required this.message});

  @override
  List<Object> get props => [message];
}

class GetRepliesForumsPostLoadingState extends ForumsState {}

class CreateForumsPostSuccessState extends ForumsActionState {}

class CreateForumsPostFailedState extends ForumsActionState {}

class CreateForumsPostLoadingState extends ForumsActionState {}

class CreateReplyForumsPostSuccessState extends ForumsActionState {}

class CreateReplyForumsPostFailedState extends ForumsActionState {}

class CreateReplyForumsPostLoadingState extends ForumsActionState {}
