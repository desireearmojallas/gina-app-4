part of 'cycle_history_bloc.dart';

abstract class CycleHistoryState extends Equatable {
  const CycleHistoryState();

  @override
  List<Object> get props => [];
}

abstract class CycleHistoryActionState extends CycleHistoryState {}

class CycleHistoryInitial extends CycleHistoryState {}

class CycleHistoryLoading extends CycleHistoryState {}

class CycleHistoryLoaded extends CycleHistoryState {
  final List<PeriodTrackerModel>? cycleHistoryList;
  final int? averageCycleLengthOfPatient;
  final DateTime? getLastPeriodDateOfPatient;
  final int? getLastPeriodLengthOfPatient;

  const CycleHistoryLoaded({
    required this.cycleHistoryList,
    required this.averageCycleLengthOfPatient,
    required this.getLastPeriodDateOfPatient,
    required this.getLastPeriodLengthOfPatient,
  });

  @override
  List<Object> get props => [
        cycleHistoryList!,
        averageCycleLengthOfPatient!,
        getLastPeriodDateOfPatient!,
        getLastPeriodLengthOfPatient!,
      ];
}

class CycleHistoryError extends CycleHistoryState {
  final String message;

  const CycleHistoryError(this.message);

  @override
  List<Object> get props => [message];
}
