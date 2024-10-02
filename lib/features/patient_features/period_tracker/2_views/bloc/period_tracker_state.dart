part of 'period_tracker_bloc.dart';

abstract class PeriodTrackerState extends Equatable {
  const PeriodTrackerState();

  @override
  List<Object> get props => [];
}

abstract class PeriodTrackerActionState extends PeriodTrackerState {}

class PeriodTrackerInitialState extends PeriodTrackerState {}

class NavigateToPeriodTrackerEditDatesState extends PeriodTrackerState {}
