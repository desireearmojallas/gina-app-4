import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/screens/appointment_screen.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/screens/find_screen.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/screens/forum_screen.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/screens/home_screen.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/screens/profile_screen.dart';
import 'package:gina_app_4/main.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

part 'bottom_navigation_event.dart';
part 'bottom_navigation_state.dart';

// ...existing code...
class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc({int initialIndex = 0, int? appointmentTabIndex})
      : super(BottomNavigationInitial(
          currentIndex: initialIndex,
          selectedScreen: _getScreenForIndex(
            initialIndex,
            appointmentTabIndex: appointmentTabIndex,
          ),
          navigationHistory: [initialIndex],
        )) {
    debugPrint(
        'Bloc initialized with index: $initialIndex and appointmentTabIndex: $appointmentTabIndex');

    on<TabChangedEvent>((event, emit) {
      debugPrint('TabChangedEvent: Changing tab to ${event.tab}');
      HapticFeedback.heavyImpact();
      emit(BottomNavigationInitial(
        currentIndex: event.tab,
        selectedScreen: _getScreenForIndex(event.tab,
            appointmentTabIndex: appointmentTabIndex),
        navigationHistory: [...state.navigationHistory, event.tab],
      ));
    });

    on<BackPressedEvent>((event, emit) {
      debugPrint('BackPressedEvent: Going back');
      final history = List<int>.from(state.navigationHistory);
      history.removeLast();
      final newIndex = history.isNotEmpty ? history.last : 0;
      emit(BottomNavigationInitial(
        currentIndex: newIndex,
        selectedScreen: _getScreenForIndex(newIndex,
            appointmentTabIndex: appointmentTabIndex),
        navigationHistory: history,
      ));
    });
  }

  static Widget _getScreenForIndex(int index, {int? appointmentTabIndex}) {
    debugPrint(
        '_getScreenForIndex called with index: $index and appointmentTabIndex: $appointmentTabIndex');
    switch (index) {
      case 0:
        return const HomeScreenProvider();
      case 1:
        return const FindScreenProvider();
      case 2:
        return AppointmentScreenProvider(
          initialIndex: appointmentTabIndex,
        );
      case 3:
        return const ForumScreenProvider();
      case 4:
        return const ProfileScreenProvider();
      default:
        return const HomeScreenProvider();
    }
  }
}
