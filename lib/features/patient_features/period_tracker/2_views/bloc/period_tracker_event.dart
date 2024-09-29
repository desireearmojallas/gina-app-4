part of 'period_tracker_bloc.dart';

abstract class PeriodTrackerEvent extends Equatable {
  const PeriodTrackerEvent();

  @override
  List<Object> get props => [];
}

class PeriodTrackerInitialEvent extends PeriodTrackerEvent {}

class FetchPeriodData extends PeriodTrackerEvent {}

class LogPeriod extends PeriodTrackerEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LogPeriod(this.startDate, this.endDate);
}

class UpdatePeriod extends PeriodTrackerEvent {
  final DateTime startDate;
  final DateTime endDate;

  const UpdatePeriod(this.startDate, this.endDate);
}

class DeletePeriod extends PeriodTrackerEvent {
  final String id;

  const DeletePeriod(this.id);
}


class NavigateToPeriodTrackerEditDatesEvent extends PeriodTrackerEvent {}