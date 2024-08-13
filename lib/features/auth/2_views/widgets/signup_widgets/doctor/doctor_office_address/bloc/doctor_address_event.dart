part of 'doctor_address_bloc.dart';

abstract class DoctorAddressEvent extends Equatable {
  const DoctorAddressEvent();

  @override
  List<Object> get props => [];
}

class DoctorRequestedEventLocation extends DoctorAddressEvent {}

class AddMarkersInMapEvent extends DoctorAddressEvent {
  final LatLng latLng;

  const AddMarkersInMapEvent({
    required this.latLng,
  });

  @override
  List<Object> get props => [latLng];
}
