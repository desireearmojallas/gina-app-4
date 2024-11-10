import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/1_controllers/doctor_profile_controller.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/1_controllers/doctor_home_dashboard_controllers.dart';

part 'home_dashboard_event.dart';
part 'home_dashboard_state.dart';

class HomeDashboardBloc extends Bloc<HomeDashboardEvent, HomeDashboardState> {
  final DoctorHomeDashboardController doctorHomeDashboardController;
  final DoctorProfileController doctorProfileController;
  HomeDashboardBloc({
    required this.doctorHomeDashboardController,
    required this.doctorProfileController,
  }) : super(HomeDashboardInitial(
          pendingAppointments: pendingAppointmentsCount ?? 0,
          confirmedAppointments: confirmedAppointmentsCount ?? 0,
        )) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<GetDoctorNameEvent>(getDoctorName);
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeDashboardState> emit) async {
    int? pendingAppointmentsCount;

    final getTheNumberOfConfirmedAppointments =
        await doctorHomeDashboardController.getConfirmedAppointments();

    final getTheNumberOfPendingAppointments =
        await doctorHomeDashboardController.getPendingAppointments();

    getTheNumberOfPendingAppointments.fold((failure) {}, (pendingAppointments) {
      pendingAppointmentsCount = pendingAppointments;
    });

    getTheNumberOfConfirmedAppointments.fold((failure) {},
        (confirmedAppointments) {
      confirmedAppointments = confirmedAppointments;

      emit(HomeDashboardInitial(
        pendingAppointments: pendingAppointmentsCount ?? 0,
        confirmedAppointments: confirmedAppointments,
      ));
    });
  }

  FutureOr<void> getDoctorName(
      GetDoctorNameEvent event, Emitter<HomeDashboardState> emit) async {
    final currentDoctorName =
        await doctorProfileController.getCurrentDoctorName();
    emit(GetDoctorNameState(
      doctorName: currentDoctorName,
    ));
  }
}
