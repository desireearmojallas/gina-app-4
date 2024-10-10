import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/widgets/profile_update_dialog/bloc/profile_update_bloc.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/widgets/profile_update_dialog/widget_states/profile_update_error_status.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/widgets/profile_update_dialog/widget_states/profile_updated_status.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/widgets/profile_update_dialog/widget_states/profile_updating_status.dart';

Future<void> showProfileUpdateStateDialog({
  required BuildContext context,
}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return BlocBuilder<ProfileUpdateBloc, ProfileUpdateState>(
        builder: (context, state) {
          if (state is ProfileUpdating) {
            return const ProfileUpdatingStatus();
          } else if (state is ProfileUpdateSuccess) {
            return const ProfileUpdatedStatus();
          } else if (state is ProfileUpdateError) {
            return const ProfileUpdateErrorStatus();
          } else {
            return const SizedBox();
          }
        },
      );
    },
  );
}
