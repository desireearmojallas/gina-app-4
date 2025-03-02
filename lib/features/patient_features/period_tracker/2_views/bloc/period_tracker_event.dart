part of 'period_tracker_bloc.dart';

abstract class PeriodTrackerEvent extends Equatable {
  const PeriodTrackerEvent();

  @override
  List<Object> get props => [];
}

class NavigateToPeriodTrackerEditDatesEvent extends PeriodTrackerEvent {
  final List<PeriodTrackerModel> periodTrackerModel;

  const NavigateToPeriodTrackerEditDatesEvent({
    required this.periodTrackerModel,
  });

  @override
  List<Object> get props => [periodTrackerModel];
}

class LogFirstMenstrualPeriodEvent extends PeriodTrackerEvent {
  final List<DateTime> periodDates;
  final DateTime startDate;
  final DateTime endDate;

  const LogFirstMenstrualPeriodEvent({
    required this.periodDates,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}

class GetFirstMenstrualPeriodDatesEvent extends PeriodTrackerEvent {}

class LogSecondMenstrualPeriodEvent extends PeriodTrackerEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LogSecondMenstrualPeriodEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}

class GetSecondMenstrualPeriodDatesEvent extends PeriodTrackerEvent {}

class LogThirdMenstrualPeriodEvent extends PeriodTrackerEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LogThirdMenstrualPeriodEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}

class SelectDateEvent extends PeriodTrackerEvent {
  final DateTime periodDate;

  const SelectDateEvent({
    required this.periodDate,
  });

  @override
  List<Object> get props => [periodDate];
}
