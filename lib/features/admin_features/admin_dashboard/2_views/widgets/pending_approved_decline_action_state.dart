import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/bloc/admin_dashboard_bloc.dart';

class PendingApprovedDeclineActionState extends StatelessWidget {
  final AdminDashboardBloc adminDashboardBloc;
  const PendingApprovedDeclineActionState(
      {super.key, required this.adminDashboardBloc});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;

    return BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              const Gap(15),
              Text(
                state is PendingDoctorVerificationListState
                    ? 'Pending Doctor Verification'
                    : state is ApprovedDoctorVerificationListState
                        ? 'Approved Doctor Verification'
                        : 'Declined Doctor Verification',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  adminDashboardBloc.add(
                    PendingDoctorVerificationListEvent(),
                  );
                },
                child: Text(
                  'Pending',
                  style: state is PendingDoctorVerificationListState
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
                  adminDashboardBloc.add(
                    ApprovedDoctorVerificationListEvent(),
                  );
                },
                child: Text(
                  'Approved',
                  style: state is ApprovedDoctorVerificationListState
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
                  adminDashboardBloc.add(
                    DeclinedDoctorVerificationListEvent(),
                  );
                },
                child: Text(
                  'Declined',
                  style: state is DeclinedDoctorVerificationListState
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
