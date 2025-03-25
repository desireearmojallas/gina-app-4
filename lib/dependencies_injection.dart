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
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/1_controllers/doctor_appointment_request_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/bloc/doctor_appointment_request_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/screens/bloc/doctor_appointment_request_screen_loaded_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/approved_state/bloc/approved_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/cancelled_state/bloc/cancelled_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/completed_state/bloc/completed_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/declined_state/bloc/declined_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/missed_state/bloc/missed_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/bloc/pending_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_bottom_navigation/bloc/doctor_bottom_navigation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_bottom_navigation/widgets/doctor_floating_container_for_ongoing_appt/bloc/doctor_floating_container_for_ongoing_appt_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/1_controllers/doctor_chat_message_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/1_controllers/doctor_consultation_fee_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/bloc/doctor_consultation_fee_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/1_controllers/doctor_e_consult_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/1_controller/doctor_emergency_announcements_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/bloc/doctor_emergency_announcements_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forum_badge/1_controller/doctor_forum_badge_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forum_badge/2_views/bloc/doctor_forum_badge_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/1_controllers/doctor_forums_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/bloc/doctor_forums_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_my_forums/bloc/doctor_my_forums_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/1_controllers/doctor_profile_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/bloc/doctor_profile_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/widgets/doctor_profile_update_dialog/bloc/doctor_profile_update_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_schedule_management/1_controllers/doctor_schedule_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_schedule_management/2_views/bloc/doctor_schedule_management_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_upcoming_appointments/2_views/1_controllers/doctor_upcoming_appointments_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_upcoming_appointments/2_views/bloc/doctor_upcoming_appointments_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patient_details/2_views/bloc/doctor_view_patient_details_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patients/1_controllers/doctor_view_patients_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patients/2_views/bloc/doctor_view_patients_bloc.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/1_controllers/doctor_home_dashboard_controllers.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/bloc/home_dashboard_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/bloc/appointment_details_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/1_controllers/appointment_controller.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/bloc/bottom_navigation_bloc.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/widgets/floating_container_for_ongoing_appt/bloc/floating_container_for_ongoing_appt_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation/1_controllers/appointment_chat_controller.dart';
import 'package:gina_app_4/features/patient_features/consultation/1_controllers/chat_message_controllers.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation_fee_details/1_controller/consultation_fee_details_controller.dart';
import 'package:gina_app_4/features/patient_features/consultation_fee_details/2_views/bloc/consultation_fee_details_bloc.dart';
import 'package:gina_app_4/features/patient_features/cycle_history/1_controllers/cycle_history_controller.dart';
import 'package:gina_app_4/features/patient_features/cycle_history/2_views/bloc/cycle_history_bloc.dart';
import 'package:gina_app_4/features/patient_features/doctor_availability/1_controller/doctor_availability_controller.dart';
import 'package:gina_app_4/features/patient_features/doctor_availability/2_views/bloc/doctor_availability_bloc.dart';
import 'package:gina_app_4/features/patient_features/doctor_details/2_views/bloc/doctor_details_bloc.dart';
import 'package:gina_app_4/features/patient_features/emergency_announcements/1_controllers/emergency_announcement_controllers.dart';
import 'package:gina_app_4/features/patient_features/emergency_announcements/2_views/bloc/emergency_announcements_bloc.dart';
import 'package:gina_app_4/features/patient_features/find/1_controllers/find_controllers.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:gina_app_4/features/patient_features/forums/1_controllers/forums_controller.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/bloc/forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/bloc/home_bloc.dart';
import 'package:gina_app_4/features/patient_features/my_forums/1_controllers/my_forums_controller.dart';
import 'package:gina_app_4/features/patient_features/my_forums/2_views/bloc/my_forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/2_views/bloc/patient_payment_bloc.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/3_services/patient_payment_service.dart';
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

//! Features - Floating Container for Ongoing Appointment
  sl.registerFactory(
    () => FloatingContainerForOngoingApptBloc(
      appointmentController: sl(),
    ),
  );

//------------------------------------------------------------------------------

//! Features - Home
  sl.registerFactory(
    () => HomeBloc(
      profileController: sl(),
      appointmentController: sl(),
      periodTrackerController: sl(),
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
  sl.registerFactory(() => ConsultationBloc(
        appointmentChatController: sl(),
        chatMessageController: sl(),
      ));

  sl.registerFactory(() => ChatMessageController());

//------------------------------------------------------------------------------
  //! Features - Patient Payment
  sl.registerFactory(() => PatientPaymentBloc(
      // paymentService: sl(),
      ));

  sl.registerFactory(() => PaymentService());

//------------------------------------------------------------------------------

  //! Features - Period Tracker
  sl.registerFactory(() => PeriodTrackerController());

  sl.registerFactory(
    () => PeriodTrackerBloc(
      periodTrackerController: sl(),
    ),
  );

  sl.registerFactory(
    () => CycleHistoryBloc(
      cycleHistoryController: sl(),
    ),
  );

  sl.registerFactory(() => CycleHistoryController());

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
  //! Features - Emergency Announcements (Patient)
  sl.registerFactory(
    () => EmergencyAnnouncementsBloc(
      emergencyController: sl(),
      appointmentController: sl(),
    ),
  );

  sl.registerFactory(() => EmergencyAnnouncementsController());

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
    () => DoctorDetailsBloc(
      appointmentController: sl(),
    ),
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

  //! Features - Find / Book Appointment
  sl.registerFactory(
    () => BookAppointmentBloc(
      doctorAvailabilityController: sl(),
      appointmentController: sl(),
      profileController: sl(),
    ),
  );

  sl.registerFactory(() => AppointmentController());

  //------------------------------------------------------------------------------

  //! Features - Appointment
  sl.registerFactory(
    () => AppointmentBloc(
      appointmentController: sl(),
      profileController: sl(),
      findController: sl(),
    ),
  );

  //------------------------------------------------------------------------------

  //! Features - Appointment Details
  sl.registerFactory(
    () => AppointmentDetailsBloc(
      appointmentController: sl(),
      profileController: sl(),
    ),
  );

  //------------------------------------------------------------------------------

  //------------------------------------------------------------------------------

  //------------------------------------------------------------------------------

  // -------DOCTOR FEATURES-------

  //! Features - Doctor Bottom Navigation Bar
  sl.registerFactory(
    () => DoctorBottomNavigationBloc(),
  );

  //! Features - Doctor Floating Container for Ongoing Appointment
  sl.registerFactory(
    () => DoctorFloatingContainerForOngoingApptBloc(
      doctorAppointmentRequestController: sl(),
      chatMessageController: sl(),
    ),
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
      doctorAppointmentRequestController: sl(),
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
    () => PendingRequestStateBloc(
      doctorAppointmentRequestController: sl(),
    ),
  );

  sl.registerFactory(
    () => ApprovedRequestStateBloc(
      doctorAppointmentRequestController: sl(),
    ),
  );

  sl.registerFactory(
    () => DeclinedRequestStateBloc(
      doctorAppointmentRequestController: sl(),
    ),
  );

  sl.registerFactory(
    () => CancelledRequestStateBloc(
      doctorAppointmentRequestController: sl(),
    ),
  );

  sl.registerFactory(
    () => CompletedRequestStateBloc(
      doctorAppointmentRequestController: sl(),
    ),
  );

  sl.registerFactory(
    () => MissedRequestStateBloc(
      doctorAppointmentRequestController: sl(),
    ),
  );

  sl.registerFactory(() => DoctorAppointmentRequestController());

// ----------------------------------------------------------------------------------

  //! Features - Doctor EConsult
  sl.registerFactory(
    () => DoctorEconsultBloc(
      doctorEConsultController: sl(),
      doctorAppointmentRequestController: sl(),
    ),
  );

  sl.registerFactory(() => DoctorEConsultController());

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
    () => DoctorForumBadgeBloc(
      doctorForumBadgeController: sl(),
      doctorConsultationFeeController: sl(),
    ),
  );

  sl.registerFactory(() => DoctorForumBadgeController());

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
    () => DoctorViewPatientsBloc(
      doctorViewPatientsController: sl(),
    ),
  );

  sl.registerFactory(() => DoctorViewPatientsController());

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
    () => DoctorConsultationBloc(
      doctorChatMessageController: sl(),
      appointmentChatController: sl(),
      doctorAppointmentRequestController: sl(),
    ),
  );

  sl.registerFactory(() => AppointmentChatController());
  sl.registerFactory(() => DoctorChatMessageController());

// ----------------------------------------------------------------------------------

  //! Features - Doctor Upcoming Appointments
  sl.registerFactory(
    () => DoctorUpcomingAppointmentsBloc(
      doctorUpcomingAppointmentControllers: sl(),
    ),
  );

  sl.registerFactory(() => DoctorUpcomingAppointmentControllers());

// ----------------------------------------------------------------------------------
}
