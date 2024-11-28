// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/bloc/admin_dashboard_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/bloc/admin_doctor_verification_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/screens/view_states/admin_doctor_details_pending_state.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:intl/intl.dart';

class PendingDoctorVerificationList extends StatelessWidget {
  final List<DoctorModel> pendingDoctorList;
  final BuildContext context;
  double? nameWidth;
  bool? isDashboardView;
  PendingDoctorVerificationList({
    super.key,
    this.nameWidth = 0.16,
    this.isDashboardView = true,
    required this.pendingDoctorList,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final adminDoctorVerificationBloc =
        context.read<AdminDoctorVerificationBloc>();
    final adminDashboardBloc = context.read<AdminDashboardBloc>();

    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: GinaAppTheme.lightScrim,
          thickness: 0.1,
          height: 11,
        ),
        // itemCount: isDashboardView! ? 10 : 50,
        itemCount: pendingDoctorList.length,
        itemBuilder: (context, index) {
          final pendingDoctor = pendingDoctorList[index];

          return InkWell(
            onTap: () {
              if (isFromAdminDashboard) {
                adminDashboardBloc.add(NavigateToDoctorDetailsPendingEvent(
                  pendingDoctorDetails: pendingDoctor,
                ));
              } else {
                adminDoctorVerificationBloc
                    .add(NavigateToAdminDoctorDetailsPendingEvent(
                  pendingDoctorDetails: pendingDoctor,
                ));
              }
              // adminDashboardBloc.add(NavigateToDoctorDetailsPendingEvent(
              //   pendingDoctorDetails: pendingDoctor,
              // ));
            },
            child: Row(
              children: [
                SizedBox(
                  height: size.height * 0.05,
                  child: Container(
                    width: 5,
                    color: GinaAppTheme.pendingTextColor,
                  ),
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: GinaAppTheme.pendingTextColor,
                        foregroundImage: AssetImage(
                          Images.doctorProfileIcon1,
                        ),
                      ),
                    ),
                    const Gap(15),
                    SizedBox(
                      // width: size.width * 0.175,
                      width: size.width * nameWidth!,
                      child: Text(
                        'Dr. ${pendingDoctor.name}',
                        style: ginaTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Gap(15),
                    SizedBox(
                      width: size.width * 0.112,
                      child: Text(
                        pendingDoctor.email,
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.12,
                      child: Text(
                        pendingDoctor.medicalSpecialty,
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.17,
                      child: Text(
                        pendingDoctor.officeAddress,
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.102,
                      child: Text(
                        pendingDoctor.officePhoneNumber,
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.07,
                      child: Text(
                        DateFormat('MMM d, yyyy')
                            .format(pendingDoctor.created!.toDate()),
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    pendingDoctor.verifiedDate == null
                        ? const SizedBox()
                        : SizedBox(
                            width: size.width * 0.06,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: GinaAppTheme.pendingTextColor
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    DateFormat('MMM d, yyyy').format(
                                        pendingDoctor.verifiedDate!.toDate()),
                                    style: ginaTheme.labelMedium,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
