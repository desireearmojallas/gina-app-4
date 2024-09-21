import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'period_tracker_event.dart';
part 'period_tracker_state.dart';

class PeriodTrackerBloc extends Bloc<PeriodTrackerEvent, PeriodTrackerState> {
  PeriodTrackerBloc() : super(PeriodTrackerInitial()) {
    on<PeriodTrackerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
