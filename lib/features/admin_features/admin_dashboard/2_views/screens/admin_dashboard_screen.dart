import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/bloc/admin_dashboard_bloc.dart';

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
    return Scaffold(
      appBar: AppBar(
        notificationPredicate: (notification) => false,
        automaticallyImplyLeading: false,
        title: const Text(''),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Overview',
            ),
          ),

          // 4 Clickable cards
          Row(
            children: [],
          ),

          // Table
        ],
      ),
    );
  }
}
