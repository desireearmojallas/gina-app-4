part of 'cycle_history_bloc.dart';

abstract class CycleHistoryEvent extends Equatable {
  const CycleHistoryEvent();

  @override
  List<Object> get props => [];
}

class GetCycleHistoryEvent extends CycleHistoryEvent {}
