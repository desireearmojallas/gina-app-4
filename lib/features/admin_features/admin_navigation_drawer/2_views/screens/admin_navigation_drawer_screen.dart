import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_login/1_controllers/admin_login_controllers.dart';
import 'package:gina_app_4/features/admin_features/admin_navigation_drawer/2_views/bloc/admin_navigation_drawer_bloc.dart';

class AdminNavigationDrawerProvider extends StatelessWidget {
  const AdminNavigationDrawerProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminNavigationDrawerBloc>(
      create: (context) => AdminNavigationDrawerBloc(),
      child: const AdminNavigationDrawer(),
    );
  }
}

class AdminNavigationDrawer extends StatelessWidget {
  const AdminNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminLoginControllers adminLoginControllers = AdminLoginControllers();
    return Scaffold(body:
        BlocBuilder<AdminNavigationDrawerBloc, AdminNavigationDrawerState>(
      builder: (context, state) {
        return Center(
          child: FilledButton(
            onPressed: () async {
              adminLoginControllers.adminLogout();
              Navigator.pushReplacementNamed(context, '/adminLogin');
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    ));
  }
}
