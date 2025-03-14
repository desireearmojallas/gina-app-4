import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/1_controllers/appointment_controller.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/1_controllers/period_tracker_controller.dart';
import 'package:gina_app_4/features/patient_features/profile/1_controllers/profile_controller.dart';
import 'package:geodesy/geodesy.dart' as geo;

part 'home_event.dart';
part 'home_state.dart';

List<PeriodTrackerModel>? periodTrackerModelList;
LatLng? storePatientCurrentLatLng;
geo.LatLng? storePatientCurrentGeoLatLng;
List<AppointmentModel> storedCompletedAppointments = [];

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProfileController profileController;
  final AppointmentController appointmentController;
  final PeriodTrackerController periodTrackerController;
  HomeBloc({
    required this.profileController,
    required this.appointmentController,
    required this.periodTrackerController,
  }) : super(HomeInitial(
          completedAppointments: storedCompletedAppointments,
        )) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<GetPatientNameEvent>(getPatientName);
    on<GetPatientCurrentLocationEvent>(getPatientCurrentLocationEvent);
    on<HomeNavigateToFindDoctorEvent>(homeNavigateToFindDoctorEvent);
    on<HomeNavigateToForumEvent>(homeNavigateToForumEvent);
    // on<HomeGetPeriodTrackerDataAndConsultationHistoryEvent>(
    //     homeGetPeriodTrackerDataAndConsultationHistoryEvent);
  }
  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    final result = await appointmentController.getAllCompletedAppointments();

    result.fold(
      (failure) {},
      (completedAppointments) {
        storedCompletedAppointments = completedAppointments;
        emit(HomeInitial(
          completedAppointments: completedAppointments,
        ));
        add(GetPatientNameEvent());
      },
    );
  }

  FutureOr<void> getPatientName(
      GetPatientNameEvent event, Emitter<HomeState> emit) async {
    final currentPatientName = await profileController.getCurrentPatientName();
    emit(GetPatientNameState(
      patientName: currentPatientName,
    ));
  }

  FutureOr<void> getPatientCurrentLocationEvent(
      GetPatientCurrentLocationEvent event, Emitter<HomeState> emit) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();

    try {
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      LatLng patientLatLng = LatLng(position.latitude, position.longitude);

      storePatientCurrentLatLng = patientLatLng;
      storePatientCurrentGeoLatLng = geo.LatLng(
          storePatientCurrentLatLng!.latitude,
          storePatientCurrentLatLng!.longitude);

      debugPrint('Patient current location: $storePatientCurrentLatLng');
      debugPrint('Patient current GeoLocation: $storePatientCurrentGeoLatLng');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  FutureOr<void> homeNavigateToFindDoctorEvent(
      HomeNavigateToFindDoctorEvent event, Emitter<HomeState> emit) {
    emit(HomeNavigateToFindDoctorActionState());
  }

  FutureOr<void> homeNavigateToForumEvent(
      HomeNavigateToForumEvent event, Emitter<HomeState> emit) {
    emit(HomeNavigateToForumActionState());
  }

  //TODO: HOME GET PERIOD TRACKER DATA AND CONSULTATION HISTORY EVENT

  // FutureOr<void> homeGetPeriodTrackerDataAndConsultationHistoryEvent(
  //     HomeGetPeriodTrackerDataAndConsultationHistoryEvent event,
  //     Emitter<HomeState> emit) async {
  //   emit(HomeGetPeriodTrackerDataAndConsultationHistoryLoadingState());
  //   List<AppointmentModel> completedAppointments = [];
  //   final consultationHistory =
  //       await appointmentController.getAllCompletedAppointments();

  //   consultationHistory.fold(
  //     (failure) {
  //       emit(HomeInitialError(errorMessage: failure.toString()));
  //     },
  //     (consultationHistory) {
  //       completedAppointments = consultationHistory;
  //       storedCompletedAppointments = consultationHistory;
  //     },
  //   );

  //   try {
  //     final periodTrackerData = await periodTrackerController.getAllPeriods();

  //     periodTrackerData.fold(
  //       (error) {
  //         emit(HomeGetPeriodTrackerDataAndConsultationHistoryDataError(
  //             errorMessage: error.toString()));
  //       },
  //       (data) {
  //         periodTrackerModelList = data;

  //         List<DateTime> dateRange = [];

  //         for (var period in periodTrackerModelList!) {
  //           DateTime startDate = period.startDate;
  //           int periodLength
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     emit(HomeGetPeriodTrackerDataAndConsultationHistoryDataError(
  //         errorMessage: e.toString()));
  //   }
  // }
}
