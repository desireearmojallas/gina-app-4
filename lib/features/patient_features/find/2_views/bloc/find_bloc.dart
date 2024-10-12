import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'find_event.dart';
part 'find_state.dart';

class FindBloc extends Bloc<FindEvent, FindState> {
  bool showDoctorsFromOtherCities = false;

  FindBloc() : super(FindInitial()) {
    on<FindEvent>((event, emit) {});
    on<ToggleOtherCitiesVisibilityEvent>(toggleOtherCitiesVisibilityEvent);
  }

  FutureOr<void> toggleOtherCitiesVisibilityEvent(
      ToggleOtherCitiesVisibilityEvent event, Emitter<FindState> emit) {
    showDoctorsFromOtherCities = !showDoctorsFromOtherCities;
    if (showDoctorsFromOtherCities) {
      emit(OtherCitiesVisibleState());
    } else {
      emit(OtherCitiesHiddenState());
    }
  }
}
