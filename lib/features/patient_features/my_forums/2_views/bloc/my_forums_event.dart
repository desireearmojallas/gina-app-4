part of 'my_forums_bloc.dart';

abstract class MyForumsEvent extends Equatable {
  const MyForumsEvent();

  @override
  List<Object> get props => [];
}

class GetMyForumsPostEvent extends MyForumsEvent {}
