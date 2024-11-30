import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/bloc/admin_dashboard_bloc.dart';

class TableLabelContainer extends StatelessWidget {
  const TableLabelContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    return Container(
      height: size.height * 0.035,
      width: double.infinity,
      color: GinaAppTheme.lightPrimaryColor,
      child: Row(
        children: [
          const Gap(65),
          SizedBox(
            width: size.width * 0.175,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'NAME',
                style: ginaTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.112,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'EMAIL ADDRESS',
                style: ginaTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.12,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'MEDICAL SPECIALTY',
                style: ginaTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.17,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'OFFICE ADDRESS',
                style: ginaTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.09,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'CONTACT NUMBER',
                style: ginaTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.08,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'DATE REGISTERED',
                style: ginaTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
            builder: (context, state) {
              return SizedBox(
                width: size.width * 0.06,
                child: state is PendingDoctorVerificationListState
                    ? Align(
                        alignment: Alignment.center,
                        child: Text(
                          'DATE SUBMITTED',
                          style: ginaTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : state is ApprovedDoctorVerificationListState
                        ? Align(
                            alignment: Alignment.center,
                            child: Text(
                              'DATE VERIFIED',
                              style: ginaTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : state is DeclinedDoctorVerificationListState
                            ? Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'DATE DECLINED',
                                  style: ginaTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))
                            : Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'DATE SUBMITTED',
                                  style: ginaTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
              );
            },
          ),
        ],
      ),
    );
  }
}
