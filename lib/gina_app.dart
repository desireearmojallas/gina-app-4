import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/provider/bloc_providers.dart';
import 'package:gina_app_4/core/route/gina_app_routes.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
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
        home: const SplashScreenProvider(),
      ),
    );
  }
}
