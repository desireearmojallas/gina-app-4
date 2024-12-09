import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gina_app_4/features/patient_features/profile/1_controllers/profile_controller.dart';
import 'package:geodesy/geodesy.dart' as geo;

part 'home_event.dart';
part 'home_state.dart';

LatLng? storePatientCurrentLatLng;
geo.LatLng? storePatientCurrentGeoLatLng;

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProfileController profileController;
  HomeBloc({
    required this.profileController,
  }) : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<GetPatientNameEvent>(getPatientName);
    on<GetPatientCurrentLocationEvent>(getPatientCurrentLocationEvent);
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
}
