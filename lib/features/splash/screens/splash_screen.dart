import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/splash/bloc/splash_bloc.dart';
import 'package:gina_app_4/features/splash/screens/view_states/splash_screen_loaded.dart';

class SplashScreenProvider extends StatelessWidget {
  const SplashScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (context) {
        final splashBloc = sl<SplashBloc>();

        Future.delayed(const Duration(seconds: 3), () {
          splashBloc.add(SplashCheckLoginStatusEvent());
        });

        return splashBloc;
      },
      child: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
      listenWhen: (previous, current) => current is SplashActionState,
      buildWhen: (previous, current) => current is! SplashActionState,
      listener: (context, state) {
        if (state is SplashNavigateToHomeState) {
          Navigator.of(context).pushReplacementNamed(
            '/bottomNavigation',
          );
        } else if (state is SplashNavigateToDoctorHomeState) {
          // TODO: SPLASH NAVIGATE TO DOCTOR HOME STATE
        } else if (state is SplashNavigateToLoginState) {
          Navigator.of(context).pushReplacementNamed(
            '/login',
          );
        } else if (state is SplashNavigateToAdminLoginState) {
          // TODO: SPLASH NAVIGATE TO ADMIN LOGIN STATE
        } else if (state is SplashNavigateToAdminHomeState) {
          // TODO: SPLASH NAVIGATE TO ADMIN HOME STATE
        }
      },
      builder: (context, state) {
        if (state is SplashInitial) {
          return const SplashScreenInitial();
        } else {
          return const SplashScreenInitial();
        }
      },
    );
  }
}
