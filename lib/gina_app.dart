import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/provider/bloc_providers.dart';
import 'package:gina_app_4/core/route/gina_app_routes.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/bloc/bottom_navigation_bloc.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/screen/bottom_navigation_screen.dart';
import 'package:gina_app_4/features/splash/screens/splash_screen.dart';

class GinaApp extends StatelessWidget {
  const GinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: getBlocProviders(),
      child: MaterialApp(
        title: 'Gina',
        debugShowCheckedModeBanner: false,
        theme: GinaAppTheme.lightTheme,
        routes: ginaAppRoutes(),
        onGenerateRoute: (settings) {
          debugPrint('onGenerateRoute called with name: ${settings.name}');
          if (settings.name == '/bottomNavigation') {
            final args = settings.arguments as Map<String, dynamic>?;
            debugPrint('Route arguments: $args');
            final initialIndex = args?['initialIndex'] ?? 0;
            debugPrint('Initial Index: $initialIndex');
            final appointmentTabIndex = args?['appointmentTabIndex'] ?? 3;

            debugPrint(
                'onGenerateRoute: initialIndex: $initialIndex, appointmentTabIndex: $appointmentTabIndex');

            return MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => BottomNavigationBloc(
                    initialIndex: initialIndex,
                    appointmentTabIndex: appointmentTabIndex),
                child: const BottomNavigation(),
              ),
            );
          }
          return null; // For unhandled routes
        },
        home: const SplashScreenProvider(),
      ),
    );
  }
}
