part of 'find_bloc.dart';

abstract class FindState extends Equatable {
  const FindState();

  @override
  List<Object> get props => [];
}

abstract class FindActionState extends FindState {}

class FindInitial extends FindState {}

class OtherCitiesHiddenState extends FindState {}

class OtherCitiesVisibleState extends FindState {}
