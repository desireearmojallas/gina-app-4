import 'package:get_it/get_it.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/floating_menu_bar/2_views/bloc/floating_menu_bloc.dart';
import 'package:gina_app_4/core/storage/shared_preferences/shared_preferences_manager.dart';
import 'package:gina_app_4/features/auth/1_controllers/doctor_auth_controller.dart';
import 'package:gina_app_4/features/auth/1_controllers/patient_auth_controller.dart';
import 'package:gina_app_4/features/auth/2_views/bloc/auth_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_office_address/bloc/doctor_address_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/bloc/bottom_navigation_bloc.dart';
import 'package:gina_app_4/features/patient_features/forums/1_controllers/forums_controller.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/bloc/forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/bloc/home_bloc.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/1_controllers/period_tracker_controller.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/bloc/period_tracker_bloc.dart';
import 'package:gina_app_4/features/patient_features/profile/1_controllers/profile_controller.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/bloc/profile_bloc.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/widgets/profile_update_dialog/bloc/profile_update_bloc.dart';
import 'package:gina_app_4/features/splash/bloc/splash_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.I;

Future<void> init() async {
  //! Core
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerFactory(() => sharedPreferences);
  sl.registerLazySingleton<SharedPreferencesManager>(
      () => SharedPreferencesManager());

//----------------------------------------------------------------------------
  //! Features - Splash
  sl.registerFactory(
    () => SplashBloc(
      sharedPreferencesManager: sl(),
    ),
  );
// ---------------------------------------------------------------------------
  //! Features - Auth
  sl.registerFactory(() => AuthBloc(
        patientAuthenticationController: sl(),
        doctorAuthenticationController: sl(),
      ));

  sl.registerFactory(() => AuthenticationController());
  sl.registerFactory(() => DoctorAuthenticationController());

// -------ADMIN FEATURES-------

//! Features - Admin Login

// -------PATIENT FEATURES-------

//! Features - Doctor Address Location
  sl.registerFactory(
    () => DoctorAddressBloc(),
  );

//! Features - Bottom Navigation Bar
  sl.registerFactory(
    () => BottomNavigationBloc(),
  );

//------------------------------------------------------------------------------

//! Features - Home
  sl.registerFactory(
    () => HomeBloc(),
  );

//------------------------------------------------------------------------------

//! Features - Floating Menu Bar
  sl.registerFactory(
    () => FloatingMenuBloc(
      profileController: sl(),
    ),
  );

//------------------------------------------------------------------------------

  //! Features - Patient Appointment

//------------------------------------------------------------------------------

  //! Features - Period Tracker
  sl.registerFactory(() => PeriodTrackerController());

  sl.registerFactory(
    () => PeriodTrackerBloc(
      periodTrackerController: sl(),
    ),
  );

//------------------------------------------------------------------------------

  //! Features - Forums (Patient)
  sl.registerFactory(() => ForumsController());

  sl.registerFactory(
    () => ForumsBloc(
      forumsController: sl(),
    ),
  );

//------------------------------------------------------------------------------

  //! Features - Patient Profile
  sl.registerFactory(() => ProfileBloc(
        profileController: sl(),
      ));

  sl.registerFactory(
    () => ProfileUpdateBloc(
      profileController: sl(),
    ),
  );

  sl.registerFactory(() => ProfileController());
}

//------------------------------------------------------------------------------
