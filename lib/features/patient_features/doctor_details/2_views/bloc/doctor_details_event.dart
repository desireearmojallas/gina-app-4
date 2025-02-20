part of 'doctor_details_bloc.dart';

abstract class DoctorDetailsEvent extends Equatable {
  const DoctorDetailsEvent();

  @override
  List<Object> get props => [];
}

class DoctorDetailsFetchRequestedEvent extends DoctorDetailsEvent {}

class DoctorDetailsNavigateToConsultationEvent extends DoctorDetailsEvent {}

class NavigateToDoctorOfficeAddressMapViewEvent extends DoctorDetailsEvent {}
