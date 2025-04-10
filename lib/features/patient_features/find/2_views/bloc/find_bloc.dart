import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/find/1_controllers/find_controllers.dart';

part 'find_event.dart';
part 'find_state.dart';

List<DoctorModel>? doctorNearMeLists;
Map<String, List<DoctorModel>>? storedCitiesWithDoctors;
List<DoctorModel>? getAllDoctors;
DoctorModel? doctorDetails;
AppointmentModel? appointmentForNearbyDocLatestAppointment;

class FindBloc extends Bloc<FindEvent, FindState> {
  final FindController findController;
  bool showDoctorsFromOtherCities = false;

  FindBloc({
    required this.findController,
  }) : super(const FindInitial()) {
    on<FindInitialEvent>(findInitialEvent);
    on<GetDoctorsNearMeEvent>(getDoctorsNearMe);
    on<FindNavigateToDoctorDetailsEvent>(navigateToDoctorDetails);
    on<GetDoctorsInTheNearestCityEvent>(getDoctorsInTheNearestCity);
    on<GetAllDoctorsEvent>(getAllDoctorsEvent);
    on<ToggleOtherCitiesVisibilityEvent>(toggleOtherCitiesVisibilityEvent);
    on<SetSearchRadiusEvent>(setSearchRadius);
  }

  FutureOr<void> findInitialEvent(
      FindInitialEvent event, Emitter<FindState> emit) {
    emit(FindLoaded());
  }

  FutureOr<void> getDoctorsNearMe(
      GetDoctorsNearMeEvent event, Emitter<FindState> emit) async {
    emit(const GetDoctorNearMeLoadingState());

    final doctorLists =
        await findController.getDoctorsNearMe(radius: state.searchRadius);

    doctorLists.fold(
      (failure) {
        emit(GetDoctorNearMeFailedState(
            errorMessage: failure.toString(),
            searchRadius: state.searchRadius));
      },
      (doctorLists) {
        doctorNearMeLists = doctorLists;
        emit(GetDoctorNearMeSuccessState(
            doctorLists: doctorLists, searchRadius: state.searchRadius));
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
      try {
        // This is an intermediate state
        emit(GetDoctorsInTheNearestCityLoadingState(
            searchRadius: state.searchRadius));

        final citiesWithDoctors = await findController.getDoctorInCities();

        citiesWithDoctors.fold(
          (failure) {
            emit(GetDoctorsInTheNearestCityFailedState(
                errorMessage: failure.toString(),
                searchRadius: state.searchRadius // Preserve radius
                ));
          },
          (citiesWithDoctors) {
            emit(GetDoctorsInTheNearestCitySuccessState(
                citiesWithDoctors: citiesWithDoctors,
                searchRadius: state.searchRadius // Preserve radius
                ));
          },
        );
      } catch (e) {
        showDoctorsFromOtherCities = false; // Revert toggle
        emit(ToggleOtherCitiesVisibilityFailedState(
            errorMessage: e.toString(),
            searchRadius: state.searchRadius // Preserve radius
            ));
      }
    } else {
      emit(OtherCitiesHiddenState(
          searchRadius: state.searchRadius)); // Preserve radius
    }
  }

  FutureOr<void> setSearchRadius(
      SetSearchRadiusEvent event, Emitter<FindState> emit) async {
    // First emit a loading state with the new radius
    emit(GetDoctorNearMeLoadingState(searchRadius: event.radius));

    // Then fetch doctors with the new radius
    final doctorLists =
        await findController.getDoctorsNearMe(radius: event.radius);

    doctorLists.fold(
      (failure) {
        emit(GetDoctorNearMeFailedState(
            errorMessage: failure.toString(),
            searchRadius: event.radius // Important: maintain the radius here
            ));
      },
      (doctorLists) {
        doctorNearMeLists = doctorLists;
        emit(GetDoctorNearMeSuccessState(
            doctorLists: doctorLists,
            searchRadius: event.radius // Important: maintain the radius here
            ));
        // Don't emit another state here as it can override your radius state
      },
    );
  }
}
