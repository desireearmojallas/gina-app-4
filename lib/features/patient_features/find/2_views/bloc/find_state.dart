part of 'find_bloc.dart';

sealed class FindState extends Equatable {
  const FindState();
  
  @override
  List<Object> get props => [];
}

final class FindInitial extends FindState {}
