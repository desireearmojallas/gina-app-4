import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc({int initialIndex = 0})
      : super(BottomNavigationInitial(
          currentIndex: initialIndex,
          selectedScreen: _getScreenForIndex(
            initialIndex,
            initialIndex: initialIndex,
          ),
          navigationHistory: [initialIndex],
        )) {
    debugPrint('Bloc initialized with index: $initialIndex');
    // on<TabChangedEvent>((event, emit) async {
    //   final newHistory = List<int>.from(state.navigationHistory);

    //   if (newHistory.last != event.tab) {
    //     newHistory.add(event.tab);
    //   }

    //   if (canVibrate == true) {
    //     await Haptics.vibrate(HapticsType.selection);
    //   }

    //   emit(BottomNavigationInitial(
    //     currentIndex: event.tab,
    //     selectedScreen: _getScreenForIndex(event.tab),
    //     navigationHistory: newHistory,
    //   ));
    // });

    on<TabChangedEvent>((event, emit) {
      emit(BottomNavigationInitial(
        currentIndex: event.tab,
        selectedScreen: _getScreenForIndex(event.tab),
        navigationHistory: [...state.navigationHistory, event.tab],
      ));
    });

    on<BackPressedEvent>((event, emit) {
      final history = List<int>.from(state.navigationHistory);
      history.removeLast();
      final newIndex = history.isNotEmpty ? history.last : 0;
      emit(BottomNavigationInitial(
        currentIndex: newIndex,
        selectedScreen: _getScreenForIndex(newIndex),
        navigationHistory: history,
      ));
    });
  }

  //   on<BackPressedEvent>((event, emit) {
  //     final newHistory = List<int>.from(state.navigationHistory);

  //     if (newHistory.length > 1) {
  //       newHistory.removeLast();
  //       int previousIndex = newHistory.last;

  //       emit(BottomNavigationInitial(
  //         currentIndex: previousIndex,
  //         selectedScreen: _getScreenForIndex(previousIndex),
  //         navigationHistory: newHistory,
  //       ));
  //     }
  //   });
  // }

  static Widget _getScreenForIndex(int index, {int? initialIndex}) {
    debugPrint('initialIndex passed: $initialIndex');
    switch (index) {
      case 0:
        return const HomeScreenProvider();
      case 1:
        return const FindScreenProvider();
      case 2:
        return AppointmentScreenProvider(
          initialIndex: initialIndex,
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
