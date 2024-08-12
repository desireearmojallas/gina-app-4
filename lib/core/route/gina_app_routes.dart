import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/2_views/screens/login/login_screen.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/screen/bottom_navigation_screen.dart';
import 'package:gina_app_4/features/splash/screens/splash_screen.dart';

Map<String, WidgetBuilder> ginaAppRoutes() {
  return {
    // Auth Routes
    '/splash': (context) => const SplashScreen(),
    '/login': (context) => const LoginScreenProvider(),

    // Admin Routes

    // Patient Routes
    '/bottomNavigation': (context) => const BottomNavigationProvider(),
  };
}
