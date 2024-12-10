import 'package:get_it/get_it.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/floating_doctor_menu_bar/bloc/floating_doctor_menu_bar_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/floating_menu_bar/2_views/bloc/floating_menu_bloc.dart';
import 'package:gina_app_4/core/storage/shared_preferences/shared_preferences_manager.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/1_controllers/admin_dashboard_controller.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/bloc/admin_dashboard_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_list/2_views/bloc/admin_doctor_list_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/1_controllers/admin_doctor_verification_controller.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/bloc/admin_doctor_verification_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_login/1_controllers/admin_login_controllers.dart';
import 'package:gina_app_4/features/admin_features/admin_login/2_views/bloc/admin_login_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_navigation_drawer/2_views/bloc/admin_navigation_drawer_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/1_controllers/admin_patient_list_controller.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/bloc/admin_patient_list_bloc.dart';
import 'package:gina_app_4/features/auth/1_controllers/doctor_auth_controller.dart';
import 'package:gina_app_4/features/auth/1_controllers/patient_auth_controller.dart';
import 'package:gina_app_4/features/auth/2_views/bloc/auth_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/screens/forgot_password/2_views/bloc/forgot_password_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_office_address/bloc/doctor_address_bloc.dart';
import 'package:gina_app_4/features/doctor_features/create_doctor_schedule/1_controllers/create_doctor_schedule_controller.dart';
import 'package:gina_app_4/features/doctor_features/create_doctor_schedule/2_views/bloc/create_doctor_schedule_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/bloc/doctor_appointment_request_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/screens/bloc/doctor_appointment_request_screen_loaded_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/approved_state/bloc/approved_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/cancelled_state/bloc/cancelled_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/declined_state/bloc/declined_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/bloc/pending_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_bottom_navigation/bloc/doctor_bottom_navigation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/1_controllers/doctor_consultation_fee_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/bloc/doctor_consultation_fee_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/1_controller/doctor_emergency_announcements_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/bloc/doctor_emergency_announcements_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forum_badge/2_views/bloc/doctor_forum_badge_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/1_controllers/doctor_forums_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/bloc/doctor_forums_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_my_forums/bloc/doctor_my_forums_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/1_controllers/doctor_profile_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/bloc/doctor_profile_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/widgets/doctor_profile_update_dialog/bloc/doctor_profile_update_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_schedule_management/1_controllers/doctor_schedule_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_schedule_management/2_views/bloc/doctor_schedule_management_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patient_details/2_views/bloc/doctor_view_patient_details_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patients/2_views/bloc/doctor_view_patients_bloc.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/1_controllers/doctor_home_dashboard_controllers.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/bloc/home_dashboard_bloc.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/bloc/bottom_navigation_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation_fee_details/1_controller/consultation_fee_details_controller.dart';
import 'package:gina_app_4/features/patient_features/consultation_fee_details/2_views/bloc/consultation_fee_details_bloc.dart';
import 'package:gina_app_4/features/patient_features/doctor_availability/1_controller/doctor_availability_controller.dart';
import 'package:gina_app_4/features/patient_features/doctor_availability/2_views/bloc/doctor_availability_bloc.dart';
import 'package:gina_app_4/features/patient_features/doctor_details/2_views/bloc/doctor_details_bloc.dart';
import 'package:gina_app_4/features/patient_features/find/1_controllers/find_controllers.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:gina_app_4/features/patient_features/forums/1_controllers/forums_controller.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/bloc/forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/bloc/home_bloc.dart';
import 'package:gina_app_4/features/patient_features/my_forums/1_controllers/my_forums_controller.dart';
import 'package:gina_app_4/features/patient_features/my_forums/2_views/bloc/my_forums_bloc.dart';
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

// ----------------------------------------------------------------------------------

// -------ADMIN FEATURES-------

//! Features - Admin Login
  sl.registerFactory(
    () => AdminLoginBloc(
      adminLoginControllers: sl(),
    ),
  );

  sl.registerFactory(() => AdminLoginControllers());

// ----------------------------------------------------------------------------------

//! Features - Admin Navigation Drawer
  sl.registerFactory(
    () => AdminNavigationDrawerBloc(),
  );

// ----------------------------------------------------------------------------------

//! Features - Admin Dashboard
  sl.registerFactory(
    () => AdminDashboardBloc(
      adminDashboardController: sl(),
      adminDoctorVerificationController: sl(),
    ),
  );

  sl.registerFactory(() => AdminDashboardController());

// ----------------------------------------------------------------------------------

//! Features - Admin Doctor Verification
  sl.registerFactory(
    () => AdminDoctorVerificationBloc(
      adminDoctorVerificationController: sl(),
    ),
  );

  sl.registerFactory(() => AdminDoctorVerificationController());

// ----------------------------------------------------------------------------------

//! Features - Admin Doctor List
  sl.registerFactory(
    () => AdminDoctorListBloc(
      adminDoctorVerificationController: sl(),
      adminDashboardController: sl(),
    ),
  );

// ----------------------------------------------------------------------------------

//! Features - Admin Patient List
  sl.registerFactory(
    () => AdminPatientListBloc(
      adminPatientListController: sl(),
    ),
  );

  sl.registerFactory(() => AdminPatientListController());

// ----------------------------------------------------------------------------------

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

  //! Features - My Forums (Patient)
  sl.registerFactory(() => MyForumsBloc(
        myForumsController: sl(),
      ));

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
    () => FindBloc(
      findController: sl(),
    ),
  );

  sl.registerFactory(() => FindController());

  //------------------------------------------------------------------------------

  //! Features - Find / Doctor Details
  sl.registerFactory(
    () => DoctorDetailsBloc(),
  );

  //------------------------------------------------------------------------------

  //! Features - Find / Doctor Availability
  sl.registerFactory(
    () => DoctorAvailabilityBloc(
      doctorAvailabilityController: sl(),
    ),
  );

  sl.registerFactory(() => DoctorAvailabilityController());

  //------------------------------------------------------------------------------

  //! Features - Find / Consultation Fee Details
  sl.registerFactory(
    () => ConsultationFeeDetailsBloc(
      consultationFeeDetailsController: sl(),
    ),
  );

  sl.registerFactory(() => ConsultationFeeDetailsController());

  //------------------------------------------------------------------------------

  //------------------------------------------------------------------------------

  //------------------------------------------------------------------------------

  // -------DOCTOR FEATURES-------

  //! Features - Doctor Bottom Navigation Bar
  sl.registerFactory(
    () => DoctorBottomNavigationBloc(),
  );

// ----------------------------------------------------------------------------------

  //! Features - Floating Doctor Menu Bar
  sl.registerFactory(
    () => FloatingDoctorMenuBarBloc(
      doctorProfileController: sl(),
    ),
  );

  sl.registerFactory(() => DoctorProfileController());

// ----------------------------------------------------------------------------------

  //! Features - Doctor Home Dashboard
  sl.registerFactory(
    () => HomeDashboardBloc(
      doctorHomeDashboardController: sl(),
      doctorProfileController: sl(),
    ),
  );

  sl.registerFactory(() => DoctorHomeDashboardController());

// ----------------------------------------------------------------------------------

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

// ----------------------------------------------------------------------------------

  //! Features - Doctor EConsult
  sl.registerFactory(
    () => DoctorEconsultBloc(),
  );

// ----------------------------------------------------------------------------------

  //! Features - Doctor Forums
  sl.registerFactory(
    () => DoctorForumsBloc(
      docForumsController: sl(),
    ),
  );

  sl.registerFactory(() => DoctorForumsController());

  //! Features - Doctor MyForums
  sl.registerFactory(
    () => DoctorMyForumsBloc(
      myForumsController: sl(),
    ),
  );

  sl.registerFactory(() => MyForumsController());
// ----------------------------------------------------------------------------------

  //! Features - Doctor Profile
  sl.registerFactory(
    () => DoctorProfileBloc(
      doctorProfileController: sl(),
    ),
  );

  //! Features - Doctor Edit Profile
  sl.registerFactory(
    () => DoctorProfileUpdateBloc(
      doctorProfileController: sl(),
    ),
  );

// ----------------------------------------------------------------------------------

  //! Features - Doctor Forum Badges
  sl.registerFactory(
    () => DoctorForumBadgeBloc(),
  );

// ----------------------------------------------------------------------------------

  //! Features - Doctor Consultation Fee Setup
  sl.registerFactory(
    () => DoctorConsultationFeeBloc(
      doctorConsultationFeeController: sl(),
    ),
  );

  sl.registerFactory(() => DoctorConsultationFeeController());

// ----------------------------------------------------------------------------------

  //! Features - Doctor View Patients
  sl.registerFactory(
    () => DoctorViewPatientsBloc(),
  );

// ----------------------------------------------------------------------------------

  //! Features - Doctor View Patient Details
  sl.registerFactory(
    () => DoctorViewPatientDetailsBloc(),
  );

// ----------------------------------------------------------------------------------

  //! Features - Doctor Emergency Announcements
  sl.registerFactory(
    () => DoctorEmergencyAnnouncementsBloc(
      doctorEmergencyAnnouncementsController: sl(),
    ),
  );

  sl.registerFactory(() => DoctorEmergencyAnnouncementsController());

// ----------------------------------------------------------------------------------

  //! Features - Doctor Schedule Management
  sl.registerFactory(
    () => DoctorScheduleManagementBloc(
      doctorProfileController: sl(),
      doctorScheduleController: sl(),
    ),
  );

  sl.registerFactory(() => DoctorScheduleController());

// ----------------------------------------------------------------------------------

  //! Features - Doctor Create Schedule
  sl.registerFactory(
    () => CreateDoctorScheduleBloc(
      scheduleController: sl(),
    ),
  );

  sl.registerFactory(() => CreateDoctorScheduleController());

// ----------------------------------------------------------------------------------

  //! Features - Doctor Consultation Screen
  sl.registerFactory(
    () => DoctorConsultationBloc(),
  );

// ----------------------------------------------------------------------------------
}
