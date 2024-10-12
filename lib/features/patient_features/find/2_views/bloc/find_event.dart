part of 'find_bloc.dart';

abstract class FindEvent extends Equatable {
  const FindEvent();

  @override
  List<Object> get props => [];
}


class ToggleOtherCitiesVisibilityEvent extends FindEvent {}