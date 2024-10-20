import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/2_views/screens/login/login_screen.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_office_address/doctor_add_office_address.dart';
import 'package:gina_app_4/features/doctor_features/doctor_bottom_navigation/screens/doctor_bottom_navigation_screen.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/screens/appointment_screen.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/screen/bottom_navigation_screen.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/screens/find_screen.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/screens/forum_screen.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/screens/view_states/create_post_screen_state.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/period_tracker_screen.dart';
import 'package:gina_app_4/features/splash/screens/splash_screen.dart';

Map<String, WidgetBuilder> ginaAppRoutes() {
  return {
    // Auth Routes
    '/splash': (context) => const SplashScreen(),
    '/login': (context) => const LoginScreenProvider(),

    // Admin Routes

    // Patient Routes
    '/doctorAddressMap': (context) => const DoctorAddOfficeAddressProvider(),
    '/bottomNavigation': (context) => const BottomNavigationProvider(),
    '/forums': (context) => const ForumScreenProvider(),
    '/forumsCreatePost': (context) => CreatePostScreenState(),
    '/bookAppointment': (context) => const FindScreenProvider(),
    '/appointments': (context) => const AppointmentScreenProvider(),
    '/periodTracker': (context) => const PeriodTrackerScreenProvider(),

    // Doctor Routes
    '/doctorBottomNavigation': (context) =>
        const DoctorBottomNavigationProvider(),
  };
}
