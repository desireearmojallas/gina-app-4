import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/approved_doctor_verification_list.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/dashboard_summary_containers.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/declined_doctor_verification_list.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/pending_approved_decline_action_state.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/pending_doctor_verification_list.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/table_label_container.dart';

class AdminDashboardInitialState extends StatelessWidget {
  const AdminDashboardInitialState({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            // 4 Clickable cards
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
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: PendingApprovedDeclineActionState(),
                  ),
                  TableLabelContainer(),
                  // PendingDoctorVerificationList(),
                  // ApprovedDoctorVerificationList(),
                  DeclinedDoctorVerificationList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
