import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/storage/shared_preferences/shared_preferences_manager.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/auth/2_views/bloc/auth_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/screens/login/view_states/login_screen_loaded.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_account_verification_status/doctor_approved_verification_state.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_account_verification_status/doctor_declined_verification_state.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_account_verification_status/doctor_waiting_for_approval_state.dart';

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
            Navigator.pushReplacementNamed(context, '/doctorBottomNavigation');
            await sharedPreferencesManager.setDoctorIsLoggedIn(true);
          } else if (state is AuthWaitingForApprovalState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DoctorWaitingForApprovalState(),
              ),
            );
          } else if (state is AuthVerificationDeclinedState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorDeclinedVerificationState(
                  declineReason: state.declineReason,
                ),
              ),
            );
          } else if (state is AuthVerificationApprovedState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DoctorApprovedVerificationState(),
              ),
            );
          } else if (state is AuthLoginDoctorFailureState) {
            // TODO: AUTH LOGIN DOCTOR FAILURE STATE
          } else if (state is NavigateToAdminLoginScreenState) {
            // TODO: NAVIGATE TO ADMIN LOGIN SCREEN STATE
            if (kIsWeb) {
              // TODO: NAVIGATE TO ADMIN LOGIN SCREEN STATE
            }
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
