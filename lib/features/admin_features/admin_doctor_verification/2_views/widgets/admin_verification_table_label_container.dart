import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/bloc/admin_doctor_verification_bloc.dart';

class AdminVerificationTableLabelContainer extends StatelessWidget {
  const AdminVerificationTableLabelContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    return Container(
      height: size.height * 0.035,
      width: size.width * 0.9,
      color: GinaAppTheme.lightPrimaryColor,
      child: Row(
        children: [
          const Gap(65),
          SizedBox(
            width: size.width * 0.15,
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
          BlocBuilder<AdminDoctorVerificationBloc,
              AdminDoctorVerificationState>(
            builder: (context, state) {
              return SizedBox(
                  width: size.width * 0.06,
                  child: state
                          is AdminVerificationPendingDoctorVerificationListState
                      ? Align(
                          alignment: Alignment.center,
                          child: Text(
                            'DATE SUBMITTED',
                            style: ginaTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : state is AdminVerificationApprovedDoctorVerificationListState
                          ? Align(
                              alignment: Alignment.center,
                              child: Text(
                                'DATE VERIFIED',
                                style: ginaTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : state is AdminVerificationDeclinedDoctorVerificationListState
                              ? Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'DATE DECLINED',
                                    style: ginaTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'DATE SUBMITTED',
                                    style: ginaTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ));
            },
          ),
        ],
      ),
    );
  }
}
