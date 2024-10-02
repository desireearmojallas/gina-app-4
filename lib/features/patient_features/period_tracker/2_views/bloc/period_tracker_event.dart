part of 'period_tracker_bloc.dart';

abstract class PeriodTrackerEvent extends Equatable {
  const PeriodTrackerEvent();

  @override
  List<Object> get props => [];
}

class PeriodTrackerInitialEvent extends PeriodTrackerEvent {}




class NavigateToPeriodTrackerEditDatesEvent extends PeriodTrackerEvent {}