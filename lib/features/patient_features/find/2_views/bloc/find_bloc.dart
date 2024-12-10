import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
    on<FindInitialEvent>(findInitialEvent);
    on<GetDoctorsNearMeEvent>(getDoctorsNearMe);
    on<FindNavigateToDoctorDetailsEvent>(navigateToDoctorDetails);
    on<GetDoctorsInTheNearestCityEvent>(getDoctorsInTheNearestCity);
    on<GetAllDoctorsEvent>(getAllDoctorsEvent);
    on<ToggleOtherCitiesVisibilityEvent>(toggleOtherCitiesVisibilityEvent);
  }

  FutureOr<void> findInitialEvent(
      FindInitialEvent event, Emitter<FindState> emit) {
    emit(FindLoaded());
  }

  FutureOr<void> getDoctorsNearMe(
      GetDoctorsNearMeEvent event, Emitter<FindState> emit) async {
    emit(GetDoctorNearMeLoadingState());

    final doctorLists = await findController.getDoctorsNearMe();

    doctorLists.fold(
      (failure) {
        emit(GetDoctorNearMeFailedState(errorMessage: failure.toString()));
      },
      (doctorLists) {
        doctorNearMeLists = doctorLists;
        emit(GetDoctorNearMeSuccessState(
          doctorLists: doctorLists,
        ));
        emit(GetDoctorsInTheNearestCitySuccessState(
            citiesWithDoctors: storedCitiesWithDoctors ?? {}));
      },
    );
  }

  FutureOr<void> navigateToDoctorDetails(
      FindNavigateToDoctorDetailsEvent event, Emitter<FindState> emit) {
    doctorDetails = event.doctor;
    emit(FindNavigateToDoctorDetailsState(
      doctor: event.doctor,
    ));
  }

  FutureOr<void> getDoctorsInTheNearestCity(
      GetDoctorsInTheNearestCityEvent event, Emitter<FindState> emit) async {
    emit(GetDoctorsInTheNearestCityLoadingState());

    final citiesWithDoctors = await findController.getDoctorInCities();

    citiesWithDoctors.fold(
      (failure) {
        GetDoctorsInTheNearestCityFailedState(
          errorMessage: failure.toString(),
        );
      },
      (citiesWithDoctors) {
        storedCitiesWithDoctors = citiesWithDoctors;
        emit(GetDoctorsInTheNearestCitySuccessState(
          citiesWithDoctors: citiesWithDoctors,
        ));
      },
    );
  }

  FutureOr<void> getAllDoctorsEvent(
      GetAllDoctorsEvent event, Emitter<FindState> emit) async {
    emit(GetAllDoctorsLoadingState());

    final allDoctors = await findController.getDoctors();

    allDoctors.fold(
      (failure) {
        emit(GetAllDoctorsFailedState(errorMessage: failure.toString()));
      },
      (doctorLists) {
        getAllDoctors = doctorLists;
      },
    );
  }

  FutureOr<void> toggleOtherCitiesVisibilityEvent(
      ToggleOtherCitiesVisibilityEvent event, Emitter<FindState> emit) async {
    showDoctorsFromOtherCities = !showDoctorsFromOtherCities;
    if (showDoctorsFromOtherCities) {
      // emit(OtherCitiesVisibleState());
      try {
        await getDoctorsInTheNearestCity(
            GetDoctorsInTheNearestCityEvent(), emit);
      } catch (e) {
        showDoctorsFromOtherCities = false; // Revert toggle
        emit(
            ToggleOtherCitiesVisibilityFailedState(errorMessage: e.toString()));
      }
    } else {
      emit(OtherCitiesHiddenState());
    }
  }
}
