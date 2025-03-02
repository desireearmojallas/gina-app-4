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
    on<NavigateToPeriodTrackerEditDatesEvent>(navigateToPeriodTrackerEditDates);
    on<LogFirstMenstrualPeriodEvent>(logFirstMenstrualPeriod);
    on<GetFirstMenstrualPeriodDatesEvent>(getFirstMenstrualDatesPeriod);
    on<SelectDateEvent>(selectDateEvent);
  }

  FutureOr<void> navigateToPeriodTrackerEditDates(
      NavigateToPeriodTrackerEditDatesEvent event,
      Emitter<PeriodTrackerState> emit) {}

  FutureOr<void> logFirstMenstrualPeriod(
      LogFirstMenstrualPeriodEvent event, Emitter<PeriodTrackerState> emit) {}

  FutureOr<void> getFirstMenstrualDatesPeriod(
      GetFirstMenstrualPeriodDatesEvent event,
      Emitter<PeriodTrackerState> emit) {}

  FutureOr<void> selectDateEvent(
      SelectDateEvent event, Emitter<PeriodTrackerState> emit) {}
}
