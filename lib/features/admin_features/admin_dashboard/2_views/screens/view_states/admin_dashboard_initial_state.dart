import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/bloc/admin_dashboard_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/approved_doctor_verification_list.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/dashboard_summary_containers.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/declined_doctor_verification_list.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/pending_approved_decline_action_state.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/pending_doctor_verification_list.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/table_label_container.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';

class AdminDashboardInitialState extends StatelessWidget {
  final List<DoctorModel> doctors;
  final List<UserModel> patients;

  const AdminDashboardInitialState({
    super.key,
    required this.doctors,
    required this.patients,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final adminDashboardBloc = context.read<AdminDashboardBloc>();

    final pendingDoctorList = doctors
        .where((element) =>
            element.doctorVerificationStatus ==
            DoctorVerificationStatus.pending.index)
        .toList();

    final approvedDoctorList = doctors
        .where((element) =>
            element.doctorVerificationStatus ==
            DoctorVerificationStatus.approved.index)
        .toList();

    final declinedDoctorList = doctors
        .where((element) =>
            element.doctorVerificationStatus ==
            DoctorVerificationStatus.declined.index)
        .toList();

    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Gap(15),
            const DashboardSummaryContainers(),
            const Gap(30),

            // Table
            Container(
              height: size.height * 0.77,
              width: size.width / 1.17,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),

              //! TO BE CONTINUEDDDD.......
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: PendingApprovedDeclineActionState(
                      adminDashboardBloc: adminDashboardBloc,
                    ),
                  ),
                  const TableLabelContainer(),
                  BlocConsumer<AdminDashboardBloc, AdminDashboardState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is PendingDoctorVerificationListState) {
                        return PendingDoctorVerificationList(
                          // context: context,
                          pendingDoctorList: pendingDoctorList,
                          nameWidth: 0.155,
                          isDashboardView: true,
                        );
                      } else if (state is ApprovedDoctorVerificationListState) {
                        return ApprovedDoctorVerificationList(
                          approvedDoctorList: approvedDoctorList,
                          nameWidth: 0.155,
                          isDashboardView: true,
                        );
                      } else if (state is DeclinedDoctorVerificationListState) {
                        return DeclinedDoctorVerificationList(
                          declinedDoctorList: declinedDoctorList,
                          nameWidth: 0.145,
                          isDashboardView: true,
                        );
                      }
                      return PendingDoctorVerificationList(
                        pendingDoctorList: pendingDoctorList,
                        // context: context,
                        nameWidth: 0.145,
                        isDashboardView: true,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
