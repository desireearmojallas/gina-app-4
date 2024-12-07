import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/patient_features/find/1_controllers/find_controllers.dart';

part 'find_event.dart';
part 'find_state.dart';

List<DoctorModel>? doctorNearMeLists;
Map<String, List<DoctorModel>>? storedCitiesWithDoctors;
List<DoctorModel>? getAllDoctors;
DoctorModel? doctorDetails;

class FindBloc extends Bloc<FindEvent, FindState> {
  final FindController findController;
  bool showDoctorsFromOtherCities = false;

  FindBloc({
    required this.findController,
  }) : super(FindInitial()) {
    on<FindEvent>((event, emit) {});
    on<ToggleOtherCitiesVisibilityEvent>(toggleOtherCitiesVisibilityEvent);
    //! to be continued... add more events in the bloc
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
