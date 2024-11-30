import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/bloc/admin_dashboard_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/screens/view_states/admin_dashboard_initial_state.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/total_appointments_booked/total_appointments_booked_list.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/screens/view_states/admin_doctor_details_approved_state.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/screens/view_states/admin_doctor_details_declined_state.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/screens/view_states/admin_doctor_details_pending_state.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/approved_confirmation_dialog.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/decline_confirmation_dialog.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/screens/view_states/admin_patient_list_loaded_state.dart';

class AdminDashboardScreenProvider extends StatelessWidget {
  const AdminDashboardScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminDashboardBloc>(
      create: (context) {
        final adminDashboardBloc = sl<AdminDashboardBloc>();
        isFromAdminDashboard = true;
        adminDashboardBloc.add(AdminDashboardGetRequestedEvent());

        return adminDashboardBloc;
      },
      child: const AdminDashboardScreen(),
    );
  }
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminDashboardBloc = context.read<AdminDashboardBloc>();
    return Scaffold(
      body: BlocConsumer<AdminDashboardBloc, AdminDashboardState>(
        listenWhen: (previous, current) => current is AdminDashboardActionState,
        buildWhen: (previous, current) => current is! AdminDashboardActionState,
        listener: (context, state) {
          if (state is AdminDashboardApproveSuccessState) {
            approvedConfirmationDialog(
              context,
            ).then((value) =>
                adminDashboardBloc.add(AdminDashboardGetRequestedEvent()));
          } else if (state is AdminDashboardApproveErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AdminDashboardDeclineSuccessState) {
            declineConfirmationDialog(
              context,
            ).then((value) =>
                adminDashboardBloc.add(AdminDashboardGetRequestedEvent()));
          } else if (state is AdminDashboardDeclineErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminDashboardLoaded) {
            return AdminDashboardInitialState(
              doctors: state.doctors,
              patients: state.patients,
            );
          } else if (state is NavigateToDoctorDetailsPendingState) {
            return AdminDoctorDetailsPendingState(
              pendingDoctorDetails: state.pendingDoctorDetails,
              doctorVerification: state.doctorVerification,
            );
          } else if (state is NavigateToDoctorDetailsApprovedState) {
            return AdminDoctorDetailsApprovedState(
              approvedDoctorDetails: state.approvedDoctorDetails,
              doctorVerification: state.doctorVerification,
            );
          } else if (state is NavigateToDoctorDetailsDeclinedState) {
            return AdminDoctorDetailsDeclinedState(
              declinedDoctorDetails: state.declinedDoctorDetails,
              declinedDoctorVerification: state.doctorVerification,
            );
          } else if (state is NavigateToAppointmentsBookedList) {
            return const AdminDashboardTotalAppointmentsBooked();
          } else if (state is NavigateToPatientsList) {
            return AdminPatientListLoaded(
              patientList: state.patients,
            );
          }
          return AdminDashboardInitialState(
            doctors: doctorList,
            patients: patientList,
          );
        },
      ),
    );
  }
}
