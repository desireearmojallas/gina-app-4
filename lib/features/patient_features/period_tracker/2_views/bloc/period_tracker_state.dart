part of 'period_tracker_bloc.dart';

abstract class PeriodTrackerState extends Equatable {
  const PeriodTrackerState();

  @override
  List<Object> get props => [];
}

abstract class PeriodTrackerActionState extends PeriodTrackerState {}

class PeriodTrackerInitial extends PeriodTrackerState {}

class PeriodTrackerLoading extends PeriodTrackerState {}

class PeriodTrackerLoaded extends PeriodTrackerState {
  final List<PeriodTrackerModel> periodDates;

  const PeriodTrackerLoaded(this.periodDates);
}

class PeriodTrackerError extends PeriodTrackerState {
  final String message;

  const PeriodTrackerError(this.message);
}


class NavigateToPeriodTrackerEditDatesState extends PeriodTrackerState {}
