import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/storage/shared_preferences/shared_preferences_manager.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final SharedPreferencesManager sharedPreferencesManager;

  SplashBloc({
    required this.sharedPreferencesManager,
  }) : super(SplashInitial()) {
    on<SplashCheckLoginStatusEvent>(splashCheckLoginStatusEvent);
  }

  FutureOr<void> splashCheckLoginStatusEvent(
      SplashCheckLoginStatusEvent event, Emitter<SplashState> emit) async {
    bool isPatientLoggedIn =
        await sharedPreferencesManager.getPatientIsLoggedIn() ?? false;
    bool isDoctorLoggedIn =
        await sharedPreferencesManager.getDoctorIsLoggedIn() ?? false;
    bool isAdminLoggedIn =
        await sharedPreferencesManager.getAdminIsLoggedIn() ?? false;

    if (isPatientLoggedIn) {
      emit(SplashNavigateToHomeState());
    } else if (isDoctorLoggedIn) {
      emit(SplashNavigateToDoctorHomeState());
    } else if (isAdminLoggedIn) {
      emit(SplashNavigateToAdminHomeState());
    } else if (kIsWeb && !isAdminLoggedIn) {
      emit(SplashNavigateToAdminLoginState());
    } else {
      emit(SplashNavigateToLoginState());
    }
  }
}
