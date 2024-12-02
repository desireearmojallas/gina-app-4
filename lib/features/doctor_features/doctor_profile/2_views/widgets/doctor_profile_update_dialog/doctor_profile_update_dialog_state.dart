import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/widgets/doctor_profile_update_dialog/bloc/doctor_profile_update_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/widgets/doctor_profile_update_dialog/widget_states/doctor_profile_update_error_status.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/widgets/doctor_profile_update_dialog/widget_states/doctor_profile_updated_status.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/widgets/doctor_profile_update_dialog/widget_states/doctor_profile_updating_status.dart';

Future<void> showDoctorProfileUpdateStateDialog({
  required BuildContext context,
}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return BlocBuilder<DoctorProfileUpdateBloc, DoctorProfileUpdateState>(
        builder: (context, state) {
          if (state is DoctorProfileUpdating) {
            return const DoctorProfileUpdatingStatus();
          } else if (state is DoctorProfileUpdateSuccess) {
            return const DoctorProfileUpdatedStatus();
          } else if (state is DoctorProfileUpdateError) {
            return const DoctorProfileUpdateErrorStatus();
          }
          return const SizedBox();
        },
      );
    },
  );
}
