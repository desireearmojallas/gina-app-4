import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/floating_doctor_menu_bar/bloc/floating_doctor_menu_bar_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/floating_menu_bar/2_views/bloc/floating_menu_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/bloc/admin_dashboard_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_list/2_views/bloc/admin_doctor_list_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/bloc/admin_doctor_verification_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_login/2_views/bloc/admin_login_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_navigation_drawer/2_views/bloc/admin_navigation_drawer_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/bloc/admin_patient_list_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/bloc/auth_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/screens/forgot_password/2_views/bloc/forgot_password_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/bloc/doctor_appointment_request_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/screens/bloc/doctor_appointment_request_screen_loaded_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/approved_state/bloc/approved_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/cancelled_state/bloc/cancelled_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/declined_state/bloc/declined_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/bloc/pending_request_state_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_bottom_navigation/bloc/doctor_bottom_navigation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/bloc/doctor_consultation_fee_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forum_badge/2_views/bloc/doctor_forum_badge_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/bloc/doctor_forums_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/bloc/doctor_profile_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patient_details/2_views/bloc/doctor_view_patient_details_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patients/2_views/bloc/doctor_view_patients_bloc.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/bloc/home_dashboard_bloc.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/bloc/bottom_navigation_bloc.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/bloc/forums_bloc.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/bloc/home_bloc.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/bloc/period_tracker_bloc.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/bloc/profile_bloc.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/widgets/profile_update_dialog/bloc/profile_update_bloc.dart';
import 'package:gina_app_4/features/splash/bloc/splash_bloc.dart';

List<BlocProvider> getBlocProviders() {
  return [
    // Auth Blocs
    BlocProvider<SplashBloc>(
      create: (context) => sl<SplashBloc>(),
    ),
    BlocProvider<AuthBloc>(
      create: (context) => sl<AuthBloc>(),
    ),
    BlocProvider<ForgotPasswordBloc>(
      create: (context) => sl<ForgotPasswordBloc>(),
    ),

    // Admin Blocs
    BlocProvider<AdminLoginBloc>(
      create: (context) => sl<AdminLoginBloc>(),
    ),

    BlocProvider(
      create: (context) => sl<AdminNavigationDrawerBloc>(),
    ),

    BlocProvider(
      create: (context) => sl<AdminDashboardBloc>(),
    ),

    BlocProvider(
      create: (context) => sl<AdminDoctorVerificationBloc>(),
    ),

    BlocProvider(
      create: (context) => sl<AdminDoctorListBloc>(),
    ),

    BlocProvider(
      create: (context) => sl<AdminPatientListBloc>(),
    ),

    // Patient Blocs
    BlocProvider<BottomNavigationBloc>(
      create: (context) => BottomNavigationBloc(),
    ),
    BlocProvider<HomeBloc>(
      create: (context) => sl<HomeBloc>(),
    ),
    BlocProvider<FloatingMenuBloc>(
      create: (context) => sl<FloatingMenuBloc>(),
    ),
    BlocProvider<ProfileBloc>(
      create: (context) => sl<ProfileBloc>(),
    ),
    BlocProvider<ProfileUpdateBloc>(
      create: (context) => sl<ProfileUpdateBloc>(),
    ),
    BlocProvider<PeriodTrackerBloc>(
      create: (context) => sl<PeriodTrackerBloc>(),
    ),
    BlocProvider<ForumsBloc>(
      create: (context) => sl<ForumsBloc>(),
    ),
    BlocProvider<FindBloc>(
      create: (context) => sl<FindBloc>(),
    ),

    // Doctor Blocs
    BlocProvider<DoctorBottomNavigationBloc>(
      create: (context) => sl<DoctorBottomNavigationBloc>(),
    ),
    BlocProvider<FloatingDoctorMenuBarBloc>(
      create: (context) => sl<FloatingDoctorMenuBarBloc>(),
    ),
    BlocProvider<HomeDashboardBloc>(
      create: (context) => sl<HomeDashboardBloc>(),
    ),
    BlocProvider<DoctorAppointmentRequestBloc>(
      create: (context) => sl<DoctorAppointmentRequestBloc>(),
    ),
    BlocProvider<DoctorAppointmentRequestScreenLoadedBloc>(
      create: (context) => sl<DoctorAppointmentRequestScreenLoadedBloc>(),
    ),
    BlocProvider<PendingRequestStateBloc>(
      create: (context) => sl<PendingRequestStateBloc>(),
    ),
    BlocProvider<ApprovedRequestStateBloc>(
      create: (context) => sl<ApprovedRequestStateBloc>(),
    ),
    BlocProvider<DeclinedRequestStateBloc>(
      create: (context) => sl<DeclinedRequestStateBloc>(),
    ),
    BlocProvider<CancelledRequestStateBloc>(
      create: (context) => sl<CancelledRequestStateBloc>(),
    ),
    BlocProvider<DoctorEconsultBloc>(
      create: (context) => sl<DoctorEconsultBloc>(),
    ),
    BlocProvider<DoctorForumsBloc>(
      create: (context) => sl<DoctorForumsBloc>(),
    ),
    BlocProvider<DoctorProfileBloc>(
      create: (context) => sl<DoctorProfileBloc>(),
    ),
    BlocProvider<DoctorForumBadgeBloc>(
      create: (context) => sl<DoctorForumBadgeBloc>(),
    ),
    BlocProvider<DoctorConsultationFeeBloc>(
      create: (context) => sl<DoctorConsultationFeeBloc>(),
    ),
    BlocProvider<DoctorViewPatientsBloc>(
      create: (context) => sl<DoctorViewPatientsBloc>(),
    ),
    BlocProvider<DoctorViewPatientDetailsBloc>(
      create: (context) => sl<DoctorViewPatientDetailsBloc>(),
    )
  ];
}
