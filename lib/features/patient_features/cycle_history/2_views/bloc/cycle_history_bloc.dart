import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/cycle_history/1_controllers/cycle_history_controller.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';

part 'cycle_history_event.dart';
part 'cycle_history_state.dart';

class CycleHistoryBloc extends Bloc<CycleHistoryEvent, CycleHistoryState> {
  final CycleHistoryController cycleHistoryController;
  CycleHistoryBloc({
    required this.cycleHistoryController,
  }) : super(CycleHistoryInitial()) {
    on<GetCycleHistoryEvent>(getCycleHistoryEvent);
  }

  FutureOr<void> getCycleHistoryEvent(
      GetCycleHistoryEvent event, Emitter<CycleHistoryState> emit) async {
    emit(CycleHistoryLoading());

    List<PeriodTrackerModel>? cycleHistoryList;

    final cycleHistory = await cycleHistoryController.getCycleHistory();

    cycleHistory.fold((failure) => emit(CycleHistoryError(failure.toString())),
        (cycleHistory) async {
      cycleHistoryList = cycleHistory;
    });

    final averageCycleLength =
        await cycleHistoryController.getAverageCycleLength();

    final getLastPeriodDate = await cycleHistoryController.getLastPeriodDate();

    final getLastPeriodLenth =
        await cycleHistoryController.getLastPeriodDuration();

    emit(CycleHistoryLoaded(
      cycleHistoryList: cycleHistoryList,
      averageCycleLengthOfPatient: averageCycleLength,
      getLastPeriodDateOfPatient: getLastPeriodDate,
      getLastPeriodLengthOfPatient: getLastPeriodLenth,
    ));
  }
}
