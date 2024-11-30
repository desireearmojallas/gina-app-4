import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/bloc/admin_doctor_verification_bloc.dart';

class AdminVerificationPendingApprovedDeclinedActionState
    extends StatelessWidget {
  final AdminDoctorVerificationBloc adminDoctorVerificationBloc;
  const AdminVerificationPendingApprovedDeclinedActionState({
    super.key,
    required this.adminDoctorVerificationBloc,
  });

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;

    return BlocBuilder<AdminDoctorVerificationBloc,
        AdminDoctorVerificationState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              const Gap(15),
              const Text(
                'Doctor Verification',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  adminDoctorVerificationBloc.add(
                      AdminVerificationPendingDoctorVerificationListEvent());
                },
                child: Text(
                  'Pending',
                  style: state
                          is AdminVerificationPendingDoctorVerificationListState
                      ? ginaTheme.labelMedium?.copyWith(
                          color: GinaAppTheme.pendingTextColor,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.solid,
                          decorationColor: GinaAppTheme.pendingTextColor,
                          fontWeight: FontWeight.bold,
                        )
                      : ginaTheme.labelMedium?.copyWith(
                          color: GinaAppTheme.lightOutline,
                        ),
                ),
              ),
              const Gap(10),
              TextButton(
                onPressed: () {
                  adminDoctorVerificationBloc.add(
                      AdminVerificationApprovedDoctorVerificationListEvent());
                },
                child: Text(
                  'Approved',
                  style: state
                          is AdminVerificationApprovedDoctorVerificationListState
                      ? ginaTheme.labelMedium?.copyWith(
                          color: GinaAppTheme.approvedTextColor,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.solid,
                          decorationColor: GinaAppTheme.approvedTextColor,
                          fontWeight: FontWeight.bold,
                        )
                      : ginaTheme.labelMedium?.copyWith(
                          color: GinaAppTheme.lightOutline,
                        ),
                ),
              ),
              const Gap(10),
              TextButton(
                onPressed: () {
                  adminDoctorVerificationBloc.add(
                      AdminVerificationDeclinedDoctorVerificationListEvent());
                },
                child: Text(
                  'Declined',
                  style: state
                          is AdminVerificationDeclinedDoctorVerificationListState
                      ? ginaTheme.labelMedium?.copyWith(
                          color: GinaAppTheme.declinedTextColor,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.solid,
                          decorationColor: GinaAppTheme.declinedTextColor,
                          fontWeight: FontWeight.bold,
                        )
                      : ginaTheme.labelMedium?.copyWith(
                          color: GinaAppTheme.lightOutline,
                        ),
                ),
              ),
              const Gap(10),
            ],
          ),
        );
      },
    );
  }
}
