import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/admin_features/admin_settings/2_views/bloc/admin_settings_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_settings/2_views/screens/view_states/admin_settings_screen_loaded.dart';

class AdminSettingsScreenProvider extends StatelessWidget {
  const AdminSettingsScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminSettingsBloc>(
      create: (context) {
        final adminSettingsBloc = sl<AdminSettingsBloc>();
        // adminSettingsBloc.add(AdminSettingsGetRequestedEvent());
        return adminSettingsBloc;
      },
      child: const AdminSettingsScreen(),
    );
  }
}

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AdminSettingsBloc, AdminSettingsState>(
        listener: (context, state) {
          if (state is AdminSettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return const AdminSettingsScreenLoaded();
        },
      ),
    );
  }
}
