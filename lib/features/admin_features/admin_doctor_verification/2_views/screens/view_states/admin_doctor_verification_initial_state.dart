import 'package:flutter/material.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/declined_doctor_verification_list.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/pending_doctor_verification_list.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/admin_verificatin_pending_approved_declined_action_state.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/admin_verification_table_label_container.dart';

class AdminDoctorVerificationInitialState extends StatelessWidget {
  const AdminDoctorVerificationInitialState({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 22.0),
        child: Column(
          children: [
            Container(
              height: size.height * 0.96,
              width: size.width / 1.2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child:
                        AdminVerificationPendingApprovedDeclinedActionState(),
                  ),
                  const AdminVerificationTableLabelContainer(),
                  PendingDoctorVerificationList(
                    nameWidth: 0.145,
                    isDashboardView: false,
                  ),

                  // ApprovedDoctorVerificationList(
                  //   nameWidth: 0.135,
                  //   isDashboardView: false,
                  // ),

                  // PendingDoctorVerificationList(
                  //   isDashboardView: false,
                  //   nameWidth: 0.14,
                  // ),

                  // DeclinedDoctorVerificationList(
                  //   nameWidth: 0.14,
                  //   isDashboardView: false,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
