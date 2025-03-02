// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'doctor_forums_bloc.dart';

abstract class DoctorForumsState extends Equatable {
  const DoctorForumsState();

  @override
  List<Object> get props => [];
}

abstract class DoctorForumsActionState extends DoctorForumsState {}

class DoctorForumsInitial extends DoctorForumsState {}

class GetDoctorForumsPostsSuccessState extends DoctorForumsState {
  final List<ForumModel> forumsPosts;
  final List<int> doctorRatingIds;

  const GetDoctorForumsPostsSuccessState({
    required this.forumsPosts,
    required this.doctorRatingIds,
  });

  @override
  List<Object> get props => [forumsPosts, doctorRatingIds];
}

class GetDoctorForumsPostsFailedState extends DoctorForumsState {
  final String message;

  const GetDoctorForumsPostsFailedState({required this.message});

  @override
  List<Object> get props => [message];
}

class GetDoctorForumsPostsLoadingState extends DoctorForumsState {}

class GetDoctorForumsPostsEmptyState extends DoctorForumsState {}

class NavigateToDoctorForumsDetailedPostState extends DoctorForumsState {
  final ForumModel doctorForumPost;
  final List<ForumModel> forumReplies;
  final int doctorRatingId;
  final User? currentUser;

  const NavigateToDoctorForumsDetailedPostState({
    required this.doctorForumPost,
    required this.forumReplies,
    required this.doctorRatingId,
    required this.currentUser,
  });

  @override
  List<Object> get props =>
      [doctorForumPost, forumReplies, doctorRatingId, currentUser!];
}

class NavigateToDoctorForumsCreatePostState extends DoctorForumsActionState {}

class NavigateToDoctorForumsReplyPostState extends DoctorForumsState {
  final ForumModel docForumPost;

  const NavigateToDoctorForumsReplyPostState({required this.docForumPost});

  @override
  List<Object> get props => [docForumPost];
}

class CreateDoctorForumsPostSuccessState extends DoctorForumsActionState {}

class CreateDoctorForumsPostFailedState extends DoctorForumsActionState {}

class CreateDoctorForumsPostLoadingState extends DoctorForumsActionState {}

class CreateReplyDoctorForumsPostSuccessState extends DoctorForumsActionState {}

class CreateReplyDoctorForumsPostFailedState extends DoctorForumsActionState {}

class CreateReplyDoctorForumsPostLoadingState extends DoctorForumsActionState {}

class GetRepliesDoctorForumsPostSuccessState extends DoctorForumsState {
  final ForumModel forumPost;
  final List<ForumModel> forumReplies;
  final int doctorRatingId;
  final User? currentUser;

  const GetRepliesDoctorForumsPostSuccessState({
    required this.forumPost,
    required this.forumReplies,
    required this.doctorRatingId,
    required this.currentUser,
  });

  //! added doctorRatingId to the props list. delete it causes errors
  @override
  List<Object> get props =>
      [forumPost, forumReplies, doctorRatingId, currentUser!];
}

class GetRepliesDoctorForumsPostLoadingState extends DoctorForumsState {}

class GetRepliesDoctorForumsPostFailedState extends DoctorForumsState {
  final String message;

  const GetRepliesDoctorForumsPostFailedState({required this.message});

  @override
  List<Object> get props => [message];
}

class GetRepliesDoctorForumsPostEmptyState extends DoctorForumsState {
  final ForumModel forumPost;
  final List<ForumModel> forumReplies;
  final int doctorRatingId;

  const GetRepliesDoctorForumsPostEmptyState({
    required this.forumPost,
    required this.forumReplies,
    required this.doctorRatingId,
  });

  //! added doctorRatingId to the props list. delete it causes errors
  @override
  List<Object> get props => [forumPost, forumReplies, doctorRatingId];
}

class DoctorDetailsLoadingState extends DoctorForumsState {}

class DoctorDetailsLoadedState extends DoctorForumsState {
  final DoctorModel doctor;
  final int doctorRatingId;

  const DoctorDetailsLoadedState(this.doctor, this.doctorRatingId);

  @override
  List<Object> get props => [doctor, doctorRatingId];
}

class DoctorDetailsErrorState extends DoctorForumsState {
  final String message;

  const DoctorDetailsErrorState(this.message);

  @override
  List<Object> get props => [message];
}
