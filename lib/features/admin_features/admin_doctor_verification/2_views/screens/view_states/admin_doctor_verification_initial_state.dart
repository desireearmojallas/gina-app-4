import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/approved_doctor_verification_list.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/declined_doctor_verification_list.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/pending_doctor_verification_list.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/bloc/admin_doctor_verification_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/admin_verification_pending_approved_declined_action_state.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/admin_verification_table_label_container.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';

class AdminDoctorVerificationInitialState extends StatelessWidget {
  final List<DoctorModel> doctorList;
  const AdminDoctorVerificationInitialState(
      {super.key, required this.doctorList});

  @override
  Widget build(BuildContext context) {
    final adminDoctorVerificationBloc =
        context.read<AdminDoctorVerificationBloc>();

    final pendingDoctorList = doctorList
        .where((element) =>
            element.doctorVerificationStatus ==
            DoctorVerificationStatus.pending.index)
        .toList();
    final approvedDoctorList = doctorList
        .where((element) =>
            element.doctorVerificationStatus ==
            DoctorVerificationStatus.approved.index)
        .toList();

    final declinedDoctorList = doctorList
        .where((element) =>
            element.doctorVerificationStatus ==
            DoctorVerificationStatus.declined.index)
        .toList();
    final size = MediaQuery.of(context).size;

    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 22.0),
        child: Column(
          children: [
            Container(
              height: size.height * 1.02,
              width: size.width / 1.15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: AdminVerificationPendingApprovedDeclinedActionState(
                      adminDoctorVerificationBloc: adminDoctorVerificationBloc,
                    ),
                  ),
                  const AdminVerificationTableLabelContainer(),
                  BlocConsumer<AdminDoctorVerificationBloc,
                      AdminDoctorVerificationState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state
                          is AdminVerificationPendingDoctorVerificationListState) {
                        return PendingDoctorVerificationList(
                          pendingDoctorList: pendingDoctorList,
                          nameWidth: 0.145,
                          isDashboardView: false,
                        );
                      } else if (state
                          is AdminVerificationApprovedDoctorVerificationListState) {
                        return ApprovedDoctorVerificationList(
                          approvedDoctorList: approvedDoctorList,
                          nameWidth: 0.135,
                          isDashboardView: false,
                        );
                      } else if (state
                          is AdminVerificationDeclinedDoctorVerificationListState) {
                        return DeclinedDoctorVerificationList(
                          declinedDoctorList: declinedDoctorList,
                          nameWidth: 0.14,
                          isDashboardView: false,
                        );
                      }
                      return PendingDoctorVerificationList(
                        pendingDoctorList: pendingDoctorList,
                        nameWidth: 0.145,
                        isDashboardView: false,
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
