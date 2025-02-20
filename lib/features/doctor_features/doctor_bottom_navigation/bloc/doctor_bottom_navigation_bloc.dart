import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/screens/doctor_appointment_request.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/screens/doctor_econsult_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/screens/doctor_forums_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/screens/doctor_profile_screen.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/screens/doctor_home_dashboard_screen.dart';
import 'package:gina_app_4/main.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

part 'doctor_bottom_navigation_event.dart';
part 'doctor_bottom_navigation_state.dart';

class DoctorBottomNavigationBloc
    extends Bloc<DoctorBottomNavigationEvent, DoctorBottomNavigationState> {
  DoctorBottomNavigationBloc()
      : super(const DoctorBottomNavigationInitial(
          currentIndex: 0,
          selectedScreen: DoctorHomeScreenDashboardProvider(),
          navigationHistory: [0],
        )) {
    on<TabChangedEvent>((event, emit) async {
      final newHistory = List<int>.from(state.navigationHistory);

      if (newHistory.last != event.tab) {
        newHistory.add(event.tab);
      }

      if (canVibrate == true) {
        await Haptics.vibrate(HapticsType.selection);
      }

      emit(DoctorBottomNavigationInitial(
        currentIndex: event.tab,
        selectedScreen: _getScreenForIndex(event.tab),
        navigationHistory: newHistory,
      ));
    });

    on<BackPressedEvent>((event, emit) {
      final newHistory = List<int>.from(state.navigationHistory);

      if (newHistory.length > 1) {
        newHistory.removeLast();
        int previousIndex = newHistory.last;

        emit(DoctorBottomNavigationInitial(
          currentIndex: previousIndex,
          selectedScreen: _getScreenForIndex(previousIndex),
          navigationHistory: newHistory,
        ));
      }
    });
  }

  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return const DoctorHomeScreenDashboardProvider();
      case 1:
        return const DoctorAppointmentRequestProvider();
      case 2:
        return const DoctorEConsultScreenProvider();
      case 3:
        return const DoctorForumsScreenProvider();
      case 4:
        return const DoctorProfileScreenProvider();
      default:
        return const DoctorHomeScreenDashboardProvider();
    }
  }
}
