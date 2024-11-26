import 'package:get_it/get_it.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/floating_doctor_menu_bar/bloc/floating_doctor_menu_bar_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/floating_menu_bar/2_views/bloc/floating_menu_bloc.dart';
import 'package:gina_app_4/core/storage/shared_preferences/shared_preferences_manager.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/bloc/admin_dashboard_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_list/2_views/bloc/admin_doctor_list_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/bloc/admin_doctor_verification_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_login/1_controllers/admin_login_controllers.dart';
import 'package:gina_app_4/features/admin_features/admin_login/2_views/bloc/admin_login_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_navigation_drawer/2_views/bloc/admin_navigation_drawer_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/bloc/admin_patient_list_bloc.dart';
import 'package:gina_app_4/features/auth/1_controllers/doctor_auth_controller.dart';
import 'package:gina_app_4/features/auth/1_controllers/patient_auth_controller.dart';
import 'package:gina_app_4/features/auth/2_views/bloc/auth_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/screens/forgot_password/2_views/bloc/forgot_password_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_office_address/bloc/doctor_address_bloc.dart';
import 'package:gina_app_4/features/doctor_features/create_doctor_schedule/2_views/bloc/create_doctor_schedule_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/bloc/doctor_appointment_request_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/screens/bloc/doctor_appointment_request_screen_loaded_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/approved_state/bloc/approved_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/cancelled_state/bloc/cancelled_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/declined_state/bloc/declined_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/bloc/pending_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_bottom_navigation/bloc/doctor_bottom_navigation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/bloc/doctor_consultation_fee_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/bloc/doctor_emergency_announcements_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forum_badge/2_views/bloc/doctor_forum_badge_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/1_controllers/doctor_forums_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/bloc/doctor_forums_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/1_controllers/doctor_profile_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/bloc/doctor_profile_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_schedule_management/2_views/bloc/doctor_schedule_management_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patient_details/2_views/bloc/doctor_view_patient_details_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patients/2_views/bloc/doctor_view_patients_bloc.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/1_controllers/doctor_home_dashboard_controllers.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/bloc/home_dashboard_bloc.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/bloc/bottom_navigation_bloc.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
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

  sl.registerFactory(
    () => ForgotPasswordBloc(),
  );

// -------ADMIN FEATURES-------

//! Features - Admin Login
  sl.registerFactory(
    () => AdminLoginBloc(
      adminLoginControllers: sl(),
    ),
  );

  sl.registerFactory(() => AdminLoginControllers());

//! Features - Admin Navigation Drawer
  sl.registerFactory(
    () => AdminNavigationDrawerBloc(),
  );

//! Features - Admin Dashboard
  sl.registerFactory(
    () => AdminDashboardBloc(),
  );

//! Features - Admin Doctor Verification
  sl.registerFactory(
    () => AdminDoctorVerificationBloc(),
  );

//! Features - Admin Doctor List
  sl.registerFactory(
    () => AdminDoctorListBloc(),
  );

//! Features - Admin Patient List
  sl.registerFactory(
    () => AdminPatientListBloc(),
  );

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
    () => HomeBloc(
      profileController: sl(),
    ),
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

  //------------------------------------------------------------------------------

  //! Features - Find Doctors Bloc (Patient)
  sl.registerFactory(
    () => FindBloc(),
  );

  //------------------------------------------------------------------------------

  //------------------------------------------------------------------------------

  //------------------------------------------------------------------------------

  // -------DOCTOR FEATURES-------

  //! Features - Doctor Bottom Navigation Bar
  sl.registerFactory(
    () => DoctorBottomNavigationBloc(),
  );

  //! Features - Floating Doctor Menu Bar
  sl.registerFactory(
    () => FloatingDoctorMenuBarBloc(
      doctorProfileController: sl(),
    ),
  );

  sl.registerFactory(() => DoctorProfileController());

  //! Features - Doctor Home Dashboard
  sl.registerFactory(
    () => HomeDashboardBloc(
      doctorHomeDashboardController: sl(),
      doctorProfileController: sl(),
    ),
  );

  sl.registerFactory(() => DoctorHomeDashboardController());

  //! Features - Doctor Appointment Request
  sl.registerFactory(
    () => DoctorAppointmentRequestBloc(),
  );

  sl.registerFactory(
    () => DoctorAppointmentRequestScreenLoadedBloc(),
  );

  sl.registerFactory(
    () => PendingRequestStateBloc(),
  );

  sl.registerFactory(
    () => ApprovedRequestStateBloc(),
  );

  sl.registerFactory(
    () => DeclinedRequestStateBloc(),
  );

  sl.registerFactory(
    () => CancelledRequestStateBloc(),
  );

  //! Features - Doctor EConsult
  sl.registerFactory(
    () => DoctorEconsultBloc(),
  );

  //! Features - Doctor Forums
  sl.registerFactory(
    () => DoctorForumsBloc(
      docForumsController: sl(),
    ),
  );

  sl.registerFactory(() => DoctorForumsController());

  //! Features - Doctor Profile
  sl.registerFactory(
    () => DoctorProfileBloc(),
  );

  //! Features - Doctor Forum Badges
  sl.registerFactory(
    () => DoctorForumBadgeBloc(),
  );

  //! Features - Doctor Consultation Fee Setup
  sl.registerFactory(
    () => DoctorConsultationFeeBloc(),
  );

  //! Features - Doctor View Patients
  sl.registerFactory(
    () => DoctorViewPatientsBloc(),
  );

  //! Features - Doctor View Patient Details
  sl.registerFactory(
    () => DoctorViewPatientDetailsBloc(),
  );

  //! Features - Doctor Emergency Announcements
  sl.registerFactory(
    () => DoctorEmergencyAnnouncementsBloc(),
  );

  //! Features - Doctor Schedule Management
  sl.registerFactory(
    () => DoctorScheduleManagementBloc(),
  );

  //! Features - Doctor Create Schedule
  sl.registerFactory(
    () => CreateDoctorScheduleBloc(),
  );

  //! Features - Doctor Consultation Screen
  sl.registerFactory(
    () => DoctorConsultationBloc(),
  );
}
