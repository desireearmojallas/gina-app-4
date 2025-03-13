part of 'cycle_history_bloc.dart';

sealed class CycleHistoryState extends Equatable {
  const CycleHistoryState();
  
  @override
  List<Object> get props => [];
}

final class CycleHistoryInitial extends CycleHistoryState {}
