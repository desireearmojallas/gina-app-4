import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/emergency_announcements/2_views/bloc/emergency_announcements_bloc.dart';
import 'package:gina_app_4/features/patient_features/emergency_announcements/2_views/screens/view_states/emergency_announcement_loaded.dart';

class EmergencyAnnouncementScreenProvider extends StatelessWidget {
  const EmergencyAnnouncementScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmergencyAnnouncementsBloc>(
      create: (context) {
        final emergencyAnnouncements = sl<EmergencyAnnouncementsBloc>();
        emergencyAnnouncements.add(GetEmergencyAnnouncements());
        return emergencyAnnouncements;
      },
      child: const EmergencyAnnouncementsScreen(),
    );
  }
}

class EmergencyAnnouncementsScreen extends StatelessWidget {
  const EmergencyAnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Announcements'),
      ),
      body:
          BlocConsumer<EmergencyAnnouncementsBloc, EmergencyAnnouncementsState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is EmergencyAnnouncementsLoaded) {
            return EmergencyAnnouncementScreenLoaded(
              doctorMedicalSpecialty: state.doctorMedicalSpecialty,
              emergencyAnnouncements: state.emergencyAnnouncements,
            );
          } else if (state is EmergencyAnnouncementsError) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is EmergencyAnnouncementsLoading) {
            return const Center(
              child: CustomLoadingIndicator(),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
