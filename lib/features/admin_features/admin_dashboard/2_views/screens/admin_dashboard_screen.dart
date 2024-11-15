import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/bloc/admin_dashboard_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/screens/view_states/admin_dashboard_initial.dart';

class AdminDashboardScreenProvider extends StatelessWidget {
  const AdminDashboardScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminDashboardBloc>(
      create: (context) => sl<AdminDashboardBloc>(),
      child: const AdminDashboardScreen(),
    );
  }
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: AppBar(
      //   notificationPredicate: (notification) => false,
      //   automaticallyImplyLeading: false,
      //   title: const Text(''),
      // ),
      body: AdminDashboardInitialState(),
    );
  }
}
