part of 'period_tracker_bloc.dart';

sealed class PeriodTrackerState extends Equatable {
  const PeriodTrackerState();
  
  @override
  List<Object> get props => [];
}

final class PeriodTrackerInitial extends PeriodTrackerState {}
