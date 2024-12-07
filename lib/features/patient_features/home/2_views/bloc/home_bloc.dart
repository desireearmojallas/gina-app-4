import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/profile/1_controllers/profile_controller.dart';
import 'package:geodesy/geodesy.dart' as geo;

part 'home_event.dart';
part 'home_state.dart';

geo.LatLng? storePatientCurrentGeoLatLng;

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProfileController profileController;
  HomeBloc({
    required this.profileController,
  }) : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<GetPatientNameEvent>(getPatientName);
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
}
