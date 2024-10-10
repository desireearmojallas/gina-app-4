import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/bloc/profile_bloc.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/screens/view_states/edit_profile_screen.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/screens/view_states/profile_screen_loaded.dart';

class ProfileScreenProvider extends StatelessWidget {
  const ProfileScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) {
        final profileBloc = sl<ProfileBloc>();
        profileBloc.add(GetProfileEvent());
        return profileBloc;
      },
      child: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileBloc = context.read<ProfileBloc>();
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          appBar: GinaPatientAppBar(
            title: (state is NavigateToEditProfileState)
                ? 'Edit Profile'
                : 'Profile',
            leading: (state is NavigateToEditProfileState)
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      profileBloc.add(
                        GetProfileEvent(),
                      );
                    },
                  )
                : null,
          ),
          body: BlocConsumer<ProfileBloc, ProfileState>(
            listenWhen: (previous, current) => current is ProfileActionState,
            buildWhen: (previous, current) => current is! ProfileActionState,
            listener: (context, state) {
              //TODO: Implement listener
            },
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CustomLoadingIndicator());
              } else if (state is ProfileLoaded) {
                final patientData = state.patientData;
                return ProfileScreenLoaded(
                  patientData: patientData,
                );
              } else if (state is NavigateToEditProfileState) {
                final patientData = state.patientData;
                return EditProfileScreen(
                  patientData: patientData,
                );
              }
              return const SizedBox();
            },
          ),
        );
      },
    );
  }
}
