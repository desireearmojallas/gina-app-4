import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/1_controllers/appointment_controller.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/1_controllers/period_tracker_controller.dart';
import 'package:gina_app_4/features/patient_features/profile/1_controllers/profile_controller.dart';
import 'package:geodesy/geodesy.dart' as geo;

part 'home_event.dart';
part 'home_state.dart';

List<PeriodTrackerModel>? periodTrackerModelList;
LatLng? storePatientCurrentLatLng;
geo.LatLng? storePatientCurrentGeoLatLng;

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProfileController profileController;
  final AppointmentController appointmentController;
  final PeriodTrackerController periodTrackerController;
  HomeBloc({
    required this.profileController,
    required this.appointmentController,
    required this.periodTrackerController,
  }) : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<GetPatientNameEvent>(getPatientName);
    on<GetPatientCurrentLocationEvent>(getPatientCurrentLocationEvent);
    on<HomeNavigateToFindDoctorEvent>(navigateToFindDoctorEvent);
    on<HomeNavigateToForumEvent>(navigateToForumEvent);
    on<HomeGetPeriodTrackerDataAndConsultationHistoryEvent>(
        homeGetPeriodTrackerDataEvent);
  }
  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(HomeInitial());
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

  FutureOr<void> navigateToFindDoctorEvent(
      HomeNavigateToFindDoctorEvent event, Emitter<HomeState> emit) {
    emit(HomeNavigateToFindDoctorActionState());
  }

  FutureOr<void> navigateToForumEvent(
      HomeNavigateToForumEvent event, Emitter<HomeState> emit) {
    emit(HomeNavigateToForumActionState());
  }

  // FutureOr<void> homeGetPeriodTrackerDataEvent(
  //     HomeGetPeriodTrackerDataAndConsultationHistoryEvent event,
  //     Emitter<HomeState> emit) async {
  //   emit(HomeGetPeriodTrackerDataAndConsultationHistoryLoadingState());
  //   List<AppointmentModel> filteredAppointments = [];
  //   final consultationHistory =
  //       await appointmentController.getCurrentPatientAppointment();

  //   consultationHistory.fold(
  //     (failure) {
  //       emit(HomeInitialError(errorMessage: failure.toString()));
  //     },
  //     (consultationHistory) {
  //       var filteredConsultationHistory = consultationHistory
  //           .where((appointment) =>
  //               appointment.appointmentStatus ==
  //                   AppointmentStatus.completed.index ||
  //               appointment.appointmentStatus ==
  //                   AppointmentStatus.cancelled.index ||
  //               appointment.appointmentStatus ==
  //                   AppointmentStatus.declined.index)
  //           .toList();

  //       filteredAppointments = filteredConsultationHistory;
  //     },
  //   );

  //   try {
  //     // final periodTrackerData = await periodTrackerController.getAllPeriods();

  //     final periodTrackerData =
  //         await periodTrackerController.getAllPeriodsWith28DaysPredictions();

  //     periodTrackerData.fold(
  //       (failure) => emit(
  //           HomeGetPeriodTrackerDataAndConsultationHistoryDataError(
  //               errorMessage: failure.toString())),
  //       (periodTrackerData) {
  //         periodTrackerModelList = periodTrackerData;

  //         List<DateTime> dateRange = [];

  //         for (var period in periodTrackerModelList!) {
  //           DateTime startDate = period.startDate;
  //           int periodLength =
  //               period.endDate.difference(period.startDate).inDays;

  //           for (var i = 0; i <= periodLength; i++) {
  //             dateRange.add(startDate.add(Duration(days: i)));
  //           }
  //         }

  //         emit(HomeGetPeriodTrackerDataAndConsultationHistorySuccess(
  //           periodTrackerModel: dateRange,
  //           consultationHistory: filteredAppointments,
  //         ));
  //       },
  //     );
  //   } catch (e) {
  //     emit(HomeGetPeriodTrackerDataAndConsultationHistoryDataError(
  //         errorMessage: e.toString()));
  //   }
  // }

  FutureOr<void> homeGetPeriodTrackerDataEvent(
      HomeGetPeriodTrackerDataAndConsultationHistoryEvent event,
      Emitter<HomeState> emit) async {
    emit(HomeGetPeriodTrackerDataAndConsultationHistoryLoadingState());

    try {
      // Fetch patient name
      final currentPatientName =
          await profileController.getCurrentPatientName();

      // Fetch consultation history
      final consultationHistory =
          await appointmentController.getCurrentPatientAppointment();

      List<AppointmentModel> filteredAppointments = [];
      consultationHistory.fold(
        (failure) {
          emit(HomeInitialError(errorMessage: failure.toString()));
        },
        (appointments) {
          filteredAppointments = appointments
              .where((appointment) =>
                  appointment.appointmentStatus ==
                      AppointmentStatus.completed.index ||
                  appointment.appointmentStatus ==
                      AppointmentStatus.cancelled.index ||
                  appointment.appointmentStatus ==
                      AppointmentStatus.declined.index)
              .toList();
        },
      );

      // Fetch period tracker data
      final periodTrackerData =
          await periodTrackerController.getAllPeriodsWith28DaysPredictions();

      periodTrackerData.fold(
        (failure) => emit(
            HomeGetPeriodTrackerDataAndConsultationHistoryDataError(
                errorMessage: failure.toString())),
        (periods) {
          periodTrackerModelList = periods;

          List<DateTime> dateRange = [];

          for (var period in periodTrackerModelList!) {
            DateTime startDate = period.startDate;
            int periodLength =
                period.endDate.difference(period.startDate).inDays;

            for (var i = 0; i <= periodLength; i++) {
              dateRange.add(startDate.add(Duration(days: i)));
            }
          }

          // Emit combined state
          emit(HomeLoadedState(
            patientName: currentPatientName,
            periodTrackerModel: dateRange,
            consultationHistory: filteredAppointments,
          ));
        },
      );
    } catch (e) {
      emit(HomeGetPeriodTrackerDataAndConsultationHistoryDataError(
          errorMessage: e.toString()));
    }
  }
}
