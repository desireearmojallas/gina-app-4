import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/storage/shared_preferences/shared_preferences_manager.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/admin_features/admin_login/2_views/bloc/admin_login_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_login/2_views/screens/view_states/admin_login_initial_state.dart';

class AdminLoginScreenProvider extends StatelessWidget {
  const AdminLoginScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminLoginBloc>(
      create: (context) => sl<AdminLoginBloc>(),
      child: const AdminLoginScreen(),
    );
  }
}

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedPreferencesManager = sl<SharedPreferencesManager>();
    return Scaffold(
      body: BlocConsumer<AdminLoginBloc, AdminLoginState>(
        listenWhen: (previous, current) => current is AdminLoginActionState,
        buildWhen: (previous, current) => current is! AdminLoginActionState,
        listener: (context, state) async {
          if (state is AdminLoginSuccessState) {
            debugPrint('AdminLoginSuccessState');
            Navigator.pushReplacementNamed(context, '/adminNavigationDrawer');
            await sharedPreferencesManager.setAdminIsLoggedIn(true);
          } else if (state is AdminLoginFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminLoginInitial) {
            return const AdminLoginInitialState();
          }
          return const AdminLoginInitialState();
        },
      ),
    );
  }
}
