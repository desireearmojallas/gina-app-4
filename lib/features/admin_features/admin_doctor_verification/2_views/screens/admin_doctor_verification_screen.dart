import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/bloc/admin_dashboard_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/bloc/admin_doctor_verification_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/screens/view_states/admin_doctor_details_approved_state.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/screens/view_states/admin_doctor_details_declined_state.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/screens/view_states/admin_doctor_details_pending_state.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/screens/view_states/admin_doctor_verification_initial_state.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/approved_confirmation_dialog.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/decline_confirmation_dialog.dart';

class AdminVerifyDoctorScreenProvider extends StatelessWidget {
  const AdminVerifyDoctorScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminDoctorVerificationBloc>(
      create: (context) {
        final adminDoctorVerificationBloc = sl<AdminDoctorVerificationBloc>();
        isFromAdminDashboard = false;
        adminDoctorVerificationBloc
            .add(AdminVerificationPendingDoctorVerificationListEvent());
        return adminDoctorVerificationBloc;
      },
      child: const AdminDoctorVerifyScreen(),
    );
  }
}

class AdminDoctorVerifyScreen extends StatelessWidget {
  const AdminDoctorVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminDoctorVerificationBloc =
        context.read<AdminDoctorVerificationBloc>();
    return Scaffold(
      body: BlocConsumer<AdminDoctorVerificationBloc,
          AdminDoctorVerificationState>(
        listenWhen: (previous, current) =>
            current is AdminDoctorVerificationActionState,
        buildWhen: (previous, current) =>
            current is! AdminDoctorVerificationActionState,
        listener: (context, state) {
          if (state is AdminDoctorVerificationApproveState) {
            approvedConfirmationDialog(
              context,
            ).then((value) => adminDoctorVerificationBloc
                .add(AdminDoctorVerificationGetRequestedEvent()));
          } else if (state is AdminDoctorVerificationApproveError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AdminDoctorVerificationDeclineSuccess) {
            declineConfirmationDialog(
              context,
            ).then((value) => adminDoctorVerificationBloc
                .add(AdminDoctorVerificationGetRequestedEvent()));
          } else if (state is AdminDoctorVerificationDeclineError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminDoctorVerificationLoaded) {
            return AdminDoctorVerificationInitialState(
                doctorList: state.doctors);
          } else if (state is NavigateToAdminDoctorDetailsPendingState) {
            return AdminDoctorDetailsPendingState(
              pendingDoctorDetails: state.pendingDoctorDetails,
              doctorVerification: state.doctorVerification,
            );
          } else if (state is NavigateToAdminDoctorDetailsApprovedState) {
            return AdminDoctorDetailsApprovedState(
                // approvedDoctorDetails: state.approvedDoctorDetails,
                // doctorVerification: state.doctorVerification,
                );
          } else if (state is NavigateToAdminDoctorDetailsDeclinedState) {
            return AdminDoctorDetailsDeclinedState(
                // declinedDoctorDetails: state.declinedDoctorDetails,
                // doctorVerification: state.doctorVerification,
                );
          }
          return AdminDoctorVerificationInitialState(doctorList: doctorList);
        },
      ),
    );
  }
}
