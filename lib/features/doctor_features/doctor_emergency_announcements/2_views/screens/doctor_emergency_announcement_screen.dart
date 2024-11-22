import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/bloc/doctor_emergency_announcements_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/screens/view_states/doctor_emergency_announcement_create_announcement.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/screens/view_states/doctor_emergency_announcements_loaded.dart';

class DoctorEmergencyAnnouncementScreenProvider extends StatelessWidget {
  const DoctorEmergencyAnnouncementScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorEmergencyAnnouncementsBloc>(
      create: (context) => sl<DoctorEmergencyAnnouncementsBloc>(),
      child: const DoctorEmergencyAnnouncementScreen(),
    );
  }
}

class DoctorEmergencyAnnouncementScreen extends StatelessWidget {
  const DoctorEmergencyAnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Announcements'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: FloatingActionButton(
          onPressed: () {
            //! temporary route
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DoctorEmergencyAnnouncementCreateAnnouncementScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: const DoctorEmergencyAnnouncementsLoaded(),
    );
  }
}
