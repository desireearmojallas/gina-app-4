import 'package:flutter/material.dart';
import 'package:gina_app_4/core/reusable_widgets/about_us/about_us.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/screens/admin_dashboard_screen.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/screens/admin_doctor_verification_screen.dart';
import 'package:gina_app_4/features/admin_features/admin_login/2_views/screens/admin_login_screen.dart';
import 'package:gina_app_4/features/admin_features/admin_navigation_drawer/2_views/screens/admin_navigation_drawer_screen.dart';
import 'package:gina_app_4/features/auth/2_views/screens/forgot_password/2_views/forgot_password_screen.dart';
import 'package:gina_app_4/features/auth/2_views/screens/login/login_screen.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_office_address/doctor_add_office_address.dart';
import 'package:gina_app_4/features/doctor_features/create_doctor_schedule/2_views/screens/doctor_create_schedule_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/widgets/view_patient_data/view_patient_data.dart';
import 'package:gina_app_4/features/doctor_features/doctor_bottom_navigation/screens/doctor_bottom_navigation_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/screens/doctor_consultation_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/doctor_consultation_fee_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/screens/doctor_econsult_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/screens/doctor_emergency_announcement_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forum_badge/2_views/doctor_forum_badge_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/screens/doctor_forums_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/screens/view_states/doctor_create_post_screen_state.dart';
import 'package:gina_app_4/features/doctor_features/doctor_my_forums/screens/doctor_my_forums_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_schedule_management/2_views/screens/doctor_schedule_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_schedule_management/2_views/screens/view_states/doctor_review_schedule_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patient_details/2_views/screens/doctor_view_patient_details_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patients/2_views/screens/doctor_view_patients_screen.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/screens/appointment_screen.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/screens/book_appointment_screen.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/screen/bottom_navigation_screen.dart';
import 'package:gina_app_4/features/patient_features/consultation_fee_details/2_views/screens/consultation_fee_details_screen.dart';
import 'package:gina_app_4/features/patient_features/doctor_details/2_views/screens/doctor_details_screen.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/screens/forum_screen.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/screens/view_states/create_post_screen_state.dart';
import 'package:gina_app_4/features/patient_features/my_forums/2_views/screens/my_forums_post_screen.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/period_tracker_screen.dart';
import 'package:gina_app_4/features/splash/screens/splash_screen.dart';

Map<String, WidgetBuilder> ginaAppRoutes() {
  return {
    // Auth Routes
    '/splash': (context) => const SplashScreen(),
    '/login': (context) => const LoginScreenProvider(),
    '/forgotPassword': (context) => ForgotPasswordScreen(),

    // General Routes
    '/aboutUs': (context) => const AboutUsPage(),

    // Admin Routes
    '/adminLogin': (context) => const AdminLoginScreenProvider(),
    '/adminNavigationDrawer': (context) =>
        const AdminNavigationDrawerProvider(),
    '/adminDashboard': (context) => const AdminDashboardScreenProvider(),
    '/adminDoctorVerification': (context) =>
        const AdminVerifyDoctorScreenProvider(),

    // Patient Routes
    '/doctorAddressMap': (context) => const DoctorAddOfficeAddressProvider(),
    '/bottomNavigation': (context) => const BottomNavigationProvider(),
    '/bookAppointment': (context) => const BookAppointmentScreenProvider(),
    '/consultationFeeDetails': (context) =>
        const ConsultationFeeDetailsScreenProvider(),
    '/doctorDetails': (context) => const DoctorDetailsScreenProvider(),
    '/forums': (context) => const ForumScreenProvider(),
    '/forumsCreatePost': (context) => CreatePostScreenState(),
    '/myForumsPost': (context) => const MyForumsScreenProvider(),
    '/appointments': (context) => const AppointmentScreenProvider(),
    '/periodTracker': (context) => const PeriodTrackerScreenProvider(),

    // Doctor Routes
    '/doctorBottomNavigation': (context) =>
        const DoctorBottomNavigationProvider(),
    // '/viewPatientData': (context) => const ViewPatientDataScreen(),
    '/doctorForumsCreatePost': (context) => CreateDoctorPostScreenState(),
    '/doctorForumBadge': (context) => const DoctorForumBadgeScreenProvider(),
    '/doctorForumsPost': (context) => const DoctorForumsScreenProvider(),
    '/dotorMyForumPosts': (context) => const DoctorMyForumsScreenProvider(),
    '/reviewCreatedSchedule': (context) => const DoctorReviewScheduleScreen(),
    '/doctorConsultationFee': (context) =>
        const DoctorConsultationFeeScreenProvider(),
    '/doctorPatientsList': (context) =>
        const DoctorViewPatientsScreenProvider(),
    '/doctorPatientDetails': (context) =>
        const DoctorViewPatientDetailsScreenProvider(),
    '/doctorEmergencyAnnouncements': (context) =>
        const DoctorEmergencyAnnouncementScreenProvider(),
    '/doctorScheduleManagement': (context) =>
        const DoctorScheduleManagementScreenProvider(),
    '/doctorCreateSchedule': (context) =>
        const DoctorCreateScheduleScreenProvider(),
    '/doctorEConsult': (context) => const DoctorEConsultScreenProvider(),
    '/doctorOnlineConsultChat': (context) =>
        const DoctorConsultationScreenProvider(),
  };
}
