import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/bloc/doctor_profile_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/screens/view_states/doctor_profile_screen_loaded.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/screens/view_states/edit_doctor_profile_screen.dart';

class DoctorProfileScreenProvider extends StatelessWidget {
  const DoctorProfileScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorProfileBloc>(
      create: (context) {
        final profileBloc = sl<DoctorProfileBloc>();
        profileBloc.add(GetDoctorProfileEvent());
        return profileBloc;
      },
      child: const DoctorProfileScreen(),
    );
  }
}

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileBloc = context.read<DoctorProfileBloc>();
    return BlocBuilder<DoctorProfileBloc, DoctorProfileState>(
      builder: (context, state) {
        return Scaffold(
          appBar: GinaDoctorAppBar(
            title: state is NavigateToEditDoctorProfileState
                ? 'Edit Profile'
                : 'Profile',
          ),
          backgroundColor:
              state is NavigateToEditDoctorProfileState ? Colors.white : null,
          resizeToAvoidBottomInset: true,
          body: BlocConsumer<DoctorProfileBloc, DoctorProfileState>(
            listenWhen: (previous, current) =>
                current is DoctorProfileActionState,
            buildWhen: (previous, current) =>
                current is! DoctorProfileActionState,
            listener: (context, state) {
              if (state is DoctorProfileNavigateToMyForumsPostState) {
                Navigator.pushNamed(context, '/doctorMyForumPosts')
                    .then((value) => profileBloc.add(GetDoctorProfileEvent()));
              }
            },
            builder: (context, state) {
              if (state is DoctorProfileLoading) {
                return const Center(
                  child: CustomLoadingIndicator(),
                );
              } else if (state is DoctorProfileLoaded) {
                final doctorData = state.doctorData;
                return DoctorProfileScreenLoaded(
                  doctorData: doctorData,
                );
              } else if (state is NavigateToEditDoctorProfileState) {
                final doctorData = state.doctorData;
                return EditDoctorProfileScreen(
                  doctorData: doctorData,
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
