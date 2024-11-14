import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/screens/admin_dashboard_screen.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_list/2_views/screens/admin_doctor_list_screen.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/screens/admin_doctor_verification_screen.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/screens/admin_patient_list_screen.dart';

part 'admin_navigation_drawer_event.dart';
part 'admin_navigation_drawer_state.dart';

class AdminNavigationDrawerBloc extends Bloc<AdminNavigationDrawerEvent, AdminNavigationDrawerState> {
  AdminNavigationDrawerBloc()
      : super(const AdminNavigationDrawerInitial(
            currentIndex: 0, selectedScreen: AdminDashboardScreenProvider())) {
    on<TabChangedEvent>((event, emit) {
      switch (event.tab) {
        case 0:
          emit(const AdminNavigationDrawerInitial(
              currentIndex: 0, selectedScreen: AdminDashboardScreenProvider()));
          break;
        case 1:
          emit(const AdminNavigationDrawerInitial(
              currentIndex: 1, selectedScreen: AdminVerifyDoctorScreenProvider()));
          break;
        case 2:
          emit(const AdminNavigationDrawerInitial(
              currentIndex: 2, selectedScreen: AdminDoctorListScreenProvider()));
          break;
        case 3:
          emit(const AdminNavigationDrawerInitial(
              currentIndex: 3, selectedScreen: AdminPatientListScreenProvider()));
          break;
        default:
          break;
      }
    });
  }
}