part of 'my_forums_bloc.dart';

sealed class MyForumsState extends Equatable {
  const MyForumsState();
  
  @override
  List<Object> get props => [];
}

final class MyForumsInitial extends MyForumsState {}
