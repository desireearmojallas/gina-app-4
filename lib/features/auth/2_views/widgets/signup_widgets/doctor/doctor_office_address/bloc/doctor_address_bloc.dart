import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'doctor_address_event.dart';
part 'doctor_address_state.dart';

Set<Marker> markers = {};
Position? storePosition;
LatLng? storeLatLng;

class DoctorAddressBloc extends Bloc<DoctorAddressEvent, DoctorAddressState> {
  DoctorAddressBloc() : super(DoctorAddressInitial()) {
    on<DoctorRequestedEventLocation>(doctorRequestedEventLocation);
    on<AddMarkersInMapEvent>(addMarkersInMapEvent);
  }

  FutureOr<void> doctorRequestedEventLocation(
      DoctorRequestedEventLocation event,
      Emitter<DoctorAddressState> emit) async {
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
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng latLng = LatLng(position.latitude, position.longitude);

      storePosition = position;
      storeLatLng = latLng;
      emit(DoctorSuccessLocationState(
        currentLocation: position,
        currentLatLng: latLng,
      ));
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  FutureOr<void> addMarkersInMapEvent(
      AddMarkersInMapEvent event, Emitter<DoctorAddressState> emit) {
    markers.clear();
    markers.add(Marker(
      markerId: const MarkerId('office_location'),
      position: event.latLng,
    ));
    emit(DoctorSuccessLocationState(
        currentLocation: storePosition!, currentLatLng: storeLatLng!));
    emit(DoctorSuccessMarkersState(markers: markers));
  }
}
