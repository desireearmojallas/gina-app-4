part of 'my_forums_bloc.dart';

abstract class MyForumsState extends Equatable {
  const MyForumsState();

  @override
  List<Object> get props => [];
}

abstract class MyForumsActionState extends MyForumsState {}

class MyForumsInitial extends MyForumsState {}

class MyForumsLoadedState extends MyForumsState {
  final List<ForumModel> myForumsPosts;
  final User? currentUser;

  const MyForumsLoadedState({
    required this.myForumsPosts,
    required this.currentUser,
  });

  @override
  List<Object> get props => [myForumsPosts, currentUser!];
}

class MyForumsEmptyState extends MyForumsState {}

class MyForumsErrorState extends MyForumsState {
  final String message;

  const MyForumsErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class MyForumsLoadingState extends MyForumsActionState {}

class DeleteMyForumsPostSuccessState extends MyForumsState {}
