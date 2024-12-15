part of 'period_tracker_bloc.dart';

abstract class PeriodTrackerState extends Equatable {
  const PeriodTrackerState();

  @override
  List<Object> get props => [];
}

abstract class PeriodTrackerActionState extends PeriodTrackerState {}

class PeriodTrackerInitialState extends PeriodTrackerState {}

class NavigateToPeriodTrackerEditDatesState extends PeriodTrackerState {
  final List<PeriodTrackerModel> periodTrackerModel;
  final List<DateTime> loggedPeriodDates;

  const NavigateToPeriodTrackerEditDatesState({
    required this.periodTrackerModel,
    required this.loggedPeriodDates,
  });

  @override
  List<Object> get props => [periodTrackerModel, loggedPeriodDates];
}

class LogFirstMenstrualPeriodLoadingState extends PeriodTrackerActionState {}

class LogFirstMenstrualPeriodSuccess extends PeriodTrackerActionState {}

class LogFirstMenstrualPeriodError extends PeriodTrackerActionState {
  final String errorMessage;

  LogFirstMenstrualPeriodError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class GetFirstMenstrualPeriodLoadingState extends PeriodTrackerState {}

class GetFirstMenstrualPeriodSuccess extends PeriodTrackerState {
  final List<PeriodTrackerModel> periodTrackerModel;
  final List<PeriodTrackerModel> allPeriodsWithPredictions;
  final List<PeriodTrackerModel> defaultPeriodPredictions;

  const GetFirstMenstrualPeriodSuccess({
    required this.periodTrackerModel,
    required this.allPeriodsWithPredictions,
    required this.defaultPeriodPredictions,
  });

  @override
  List<Object> get props => [periodTrackerModel];
}

class GetFirstMenstrualPeriodError extends PeriodTrackerState {
  final String errorMessage;

  const GetFirstMenstrualPeriodError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class SelectedPeriodDates extends PeriodTrackerState {
  final List<DateTime> selectedPeriodDates;

  const SelectedPeriodDates({
    required this.selectedPeriodDates,
  });

  @override
  List<Object> get props => [selectedPeriodDates];
}
