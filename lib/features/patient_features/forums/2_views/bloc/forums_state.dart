part of 'forums_bloc.dart';

sealed class ForumsState extends Equatable {
  const ForumsState();
  
  @override
  List<Object> get props => [];
}

final class ForumsInitial extends ForumsState {}
