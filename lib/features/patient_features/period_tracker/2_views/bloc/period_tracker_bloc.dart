import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/1_controllers/period_tracker_controller.dart';

part 'period_tracker_event.dart';
part 'period_tracker_state.dart';

bool isFirstPeriodLogged = false;
bool isSecondPeriodLogged = false;
bool isThirdPeriodLogged = false;

List<DateTime> periodDates = [];
List<DateTime> loggedPeriodDates = [];
List<PeriodTrackerModel> periodTrackerModel = [];

class PeriodTrackerBloc extends Bloc<PeriodTrackerEvent, PeriodTrackerState> {
  final PeriodTrackerController periodTrackerController;
  PeriodTrackerBloc({required this.periodTrackerController})
      : super(PeriodTrackerInitialState()) {
    on<NavigateToPeriodTrackerEditDatesEvent>(navigateToPeriodTrackerEditDates);
    on<LogFirstMenstrualPeriodEvent>(logFirstMenstrualPeriod);
    on<GetFirstMenstrualPeriodDatesEvent>(getFirstMenstrualDatesPeriod);
    on<SelectDateEvent>(selectDateEvent);
  }

  FutureOr<void> navigateToPeriodTrackerEditDates(
      NavigateToPeriodTrackerEditDatesEvent event,
      Emitter<PeriodTrackerState> emit) {
    emit(NavigateToPeriodTrackerEditDatesState(
        periodTrackerModel: event.periodTrackerModel,
        loggedPeriodDates:
            event.periodTrackerModel.expand((p) => p.periodDates).toList()));
  }

  FutureOr<void> logFirstMenstrualPeriod(LogFirstMenstrualPeriodEvent event,
      Emitter<PeriodTrackerState> emit) async {
    emit(LogFirstMenstrualPeriodLoadingState());
    try {
      await periodTrackerController
          .logMenstrualPeriod(
        periodDates: event.periodDates,
        startDate: event.startDate,
        endDate: event.endDate,
      )
          .then((value) async {
        await periodTrackerController.predictNext12PeriodsWithAvgCycleLength();
        await periodTrackerController.predictNext12PeriodsWith28DefaultLength();
      });

      emit(LogFirstMenstrualPeriodSuccess());
    } catch (error) {
      emit(LogFirstMenstrualPeriodError(errorMessage: error.toString()));
    }
  }

  FutureOr<void> getFirstMenstrualDatesPeriod(
      GetFirstMenstrualPeriodDatesEvent event,
      Emitter<PeriodTrackerState> emit) async {
    emit(GetFirstMenstrualPeriodLoadingState());
    List<PeriodTrackerModel> allPeriodsWithPredictions = [];
    List<PeriodTrackerModel> defaultPeriodPredictions = [];
    try {
      // final getALLPeriodsWithPredictions =
      //     await periodTrackerController.getAllPeriods();

      final getALLPeriodsWithPredictions =
          await periodTrackerController.getAllPeriodsWith28DaysPredictions();

      getALLPeriodsWithPredictions.fold(
          (error) => emit(
              GetFirstMenstrualPeriodError(errorMessage: error.toString())),
          (periods) {
        allPeriodsWithPredictions = periods;
      });

      final getDefaultPredictions =
          await periodTrackerController.getDefaultPredictions();
      getDefaultPredictions.fold(
          (error) => emit(
              GetFirstMenstrualPeriodError(errorMessage: error.toString())),
          (periods) {
        defaultPeriodPredictions = periods;
      });

      final getLogPeriods = await periodTrackerController.getMenstrualPeriods();
      getLogPeriods.fold(
          (error) => emit(
              GetFirstMenstrualPeriodError(errorMessage: error.toString())),
          (period) {
        periodTrackerModel != period;
        loggedPeriodDates = period.expand((p) => p.periodDates).toList();

        emit(GetFirstMenstrualPeriodSuccess(
            periodTrackerModel: period,
            allPeriodsWithPredictions: allPeriodsWithPredictions,
            defaultPeriodPredictions: defaultPeriodPredictions));
      });
    } catch (error) {
      emit(GetFirstMenstrualPeriodError(errorMessage: error.toString()));
    }
  }

  FutureOr<void> selectDateEvent(
      SelectDateEvent event, Emitter<PeriodTrackerState> emit) {
    if (periodDates.contains(event.periodDate)) {
      periodDates.remove(event.periodDate);
    } else {
      periodDates.add(event.periodDate);
    }

    emit(SelectedPeriodDates(selectedPeriodDates: periodDates));
    emit(NavigateToPeriodTrackerEditDatesState(
        periodTrackerModel: periodTrackerModel,
        loggedPeriodDates: periodDates + loggedPeriodDates));
  }
}
