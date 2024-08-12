import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/floating_menu_bar/2_views/bloc/floating_menu_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/auth/2_views/bloc/auth_bloc.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/bloc/bottom_navigation_bloc.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/bloc/home_bloc.dart';
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

    // Admin Blocs

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
  ];
}
