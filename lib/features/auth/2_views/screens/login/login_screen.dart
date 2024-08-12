import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/storage/shared_preferences/shared_preferences_manager.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/auth/2_views/bloc/auth_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/screens/login/view_states/login_screen_loaded.dart';

class LoginScreenProvider extends StatelessWidget {
  const LoginScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => sl<AuthBloc>(),
      child: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final sharedPreferencesManager = sl<SharedPreferencesManager>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) => current is AuthActionState,
        buildWhen: (previous, current) => current is! AuthActionState,
        listener: (context, state) async {
          if (state is AuthLoginPatientSuccessState) {
            Navigator.pushReplacementNamed(context, '/bottomNavigation');
            await sharedPreferencesManager.setPatientIsLoggedIn(true);
          } else if (state is AuthLoginPatientFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
            authBloc.add(AuthInitialEvent());
          } else if (state is AuthLoginDoctorSuccessState) {
            // TODO: AUTH LOGIN DOCTOR SUCCESS STATE
          } else if (state is AuthWaitingForApprovalState) {
            // TODO: AUTH WAITING FOR APPROVAL STATE
          } else if (state is AuthVerificationDeclinedState) {
            // TODO: AUTH VERIFICATION DECLINED STATE
          } else if (state is AuthVerificationApprovedState) {
            // TODO: AUTH VERIFICATION APPROVED STATE
          } else if (state is AuthLoginDoctorFailureState) {
            // TODO: AUTH LOGIN DOCTOR FAILURE STATE
          } else if (state is NavigateToAdminLoginScreenState) {
            // TODO: NAVIGATE TO ADMIN LOGIN SCREEN STATE
          }
        },
        builder: (context, state) {
          if (state is AuthInitialState) {
            return const LoginScreenLoaded();
          } else {
            return const LoginScreenLoaded();
          }
        },
      ),
    );
  }
}
