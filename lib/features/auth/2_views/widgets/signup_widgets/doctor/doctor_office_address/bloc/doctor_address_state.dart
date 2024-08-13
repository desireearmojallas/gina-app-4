part of 'doctor_address_bloc.dart';

abstract class DoctorAddressState extends Equatable {
  const DoctorAddressState();

  @override
  List<Object> get props => [];
}

class DoctorAddressInitial extends DoctorAddressState {}

class DoctorSuccessLocationState extends DoctorAddressState {
  final Position currentLocation;
  final LatLng currentLatLng;

  const DoctorSuccessLocationState({
    required this.currentLocation,
    required this.currentLatLng,
  });

  @override
  List<Object> get props => [currentLocation];
}

class DoctorSuccessMarkersState extends DoctorAddressState {
  final Set<Marker> markers;

  const DoctorSuccessMarkersState({
    required this.markers,
  });

  @override
  List<Object> get props => [markers];
}
