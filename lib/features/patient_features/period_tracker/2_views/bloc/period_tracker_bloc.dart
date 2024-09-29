import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/1_controllers/period_tracker_controller.dart';

part 'period_tracker_event.dart';
part 'period_tracker_state.dart';

class PeriodTrackerBloc extends Bloc<PeriodTrackerEvent, PeriodTrackerState> {
  final PeriodTrackerController periodTrackerController;
  PeriodTrackerBloc({required this.periodTrackerController})
      : super(PeriodTrackerInitialState()) {
    on<PeriodTrackerInitialEvent>(periodTrackerInitial);
    on<FetchPeriodData>(fetchPeriodData);
    on<LogPeriod>(logPeriod);
    on<DeletePeriod>(deletePeriod);
    on<NavigateToPeriodTrackerEditDatesEvent>(navigateToPeriodTrackerEditDates);
  }

  FutureOr<void> fetchPeriodData(
      FetchPeriodData event, Emitter<PeriodTrackerState> emit) async {
    emit(PeriodTrackerLoading());
    try {
      await periodTrackerController.fetchPeriods();
      emit(PeriodTrackerLoaded(periodTrackerController.periods));
    } catch (e) {
      emit(PeriodTrackerError(e.toString()));
    }
  }

  FutureOr<void> logPeriod(
      LogPeriod event, Emitter<PeriodTrackerState> emit) async {
    try {
      await periodTrackerController.logPeriod(event.startDate, event.endDate);
      add(FetchPeriodData());
    } catch (e) {
      emit(PeriodTrackerError(e.toString()));
    }
  }

  FutureOr<void> deletePeriod(
      DeletePeriod event, Emitter<PeriodTrackerState> emit) async {
    try {
      await periodTrackerController.deletePeriod(event.id);
      add(FetchPeriodData());
    } catch (e) {
      emit(PeriodTrackerError(e.toString()));
    }
  }

  FutureOr<void> navigateToPeriodTrackerEditDates(
      NavigateToPeriodTrackerEditDatesEvent event,
      Emitter<PeriodTrackerState> emit) {
    emit(NavigateToPeriodTrackerEditDatesState());
  }

  FutureOr<void> periodTrackerInitial(
      PeriodTrackerInitialEvent event, Emitter<PeriodTrackerState> emit) async {
    debugPrint('initial period tracker event triggered');
    emit(PeriodTrackerInitialState());
  }
}
