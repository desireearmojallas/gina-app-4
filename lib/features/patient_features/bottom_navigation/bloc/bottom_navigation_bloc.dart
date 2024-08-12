import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/screens/appointment_screen.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/screens/find_screen.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/screens/forum_screen.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/screens/home_screen.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/screens/profile_screen.dart';

part 'bottom_navigation_event.dart';
part 'bottom_navigation_state.dart';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc()
      : super(const BottomNavigationInitial(
            currentIndex: 0, selectedScreen: HomeScreenProvider())) {
    on<BottomNavigationEvent>((event, emit) {
      if (event is TabChangedEvent) {
        switch (event.tab) {
          // TODO: SELECTED SCREENS ROUTE
          case 0:
            emit(BottomNavigationInitial(
                currentIndex: event.tab,
                selectedScreen: const HomeScreenProvider()));
            break;
          case 1:
            emit(BottomNavigationInitial(
                currentIndex: event.tab,
                selectedScreen: const FindScreenProvider()));
            break;
          case 2:
            emit(BottomNavigationInitial(
                currentIndex: event.tab,
                selectedScreen: const AppointmentScreenProvider()));
            break;
          case 3:
            emit(BottomNavigationInitial(
                currentIndex: event.tab, selectedScreen: const ForumScreenProvider()));
            break;
          case 4:
            emit(BottomNavigationInitial(
                currentIndex: event.tab, selectedScreen: const ProfileScreenProvider()));
            break;
        }
      }
    });
  }
}
