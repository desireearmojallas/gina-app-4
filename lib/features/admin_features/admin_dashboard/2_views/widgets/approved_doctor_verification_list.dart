import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/bloc/admin_dashboard_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/bloc/admin_doctor_verification_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/screens/view_states/admin_doctor_details_approved_state.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:intl/intl.dart';

class ApprovedDoctorVerificationList extends StatelessWidget {
  final List<DoctorModel> approvedDoctorList;
  double? nameWidth;
  bool? isDashboardView;
  ApprovedDoctorVerificationList({
    super.key,
    this.nameWidth = 0.17,
    this.isDashboardView = true,
    required this.approvedDoctorList,
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
        itemCount: approvedDoctorList.length,
        itemBuilder: (context, index) {
          final approvedDoctor = approvedDoctorList[index];

          return InkWell(
            onTap: () {
              if (isFromAdminDashboard) {
                adminDashboardBloc.add(NavigateToDoctorDetailsApprovedEvent(
                  approvedDoctorDetails: approvedDoctor,
                ));
              } else {
                adminDoctorVerificationBloc
                    .add(NavigateToAdminDoctorDetailsApprovedEvent(
                  approvedDoctorDetails: approvedDoctor,
                ));
              }
            },
            child: Row(
              children: [
                SizedBox(
                  height: size.height * 0.05,
                  child: Container(
                    width: 5,
                    color: GinaAppTheme.approvedTextColor,
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
                        backgroundColor: GinaAppTheme.approvedTextColor,
                        foregroundImage: AssetImage(
                          Images.doctorProfileIcon1,
                        ),
                      ),
                    ),
                    const Gap(15),
                    SizedBox(
                      width: size.width * nameWidth!,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Dr. ${approvedDoctor.name}',
                              style: ginaTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          const Gap(5),
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                    const Gap(15),
                    SizedBox(
                      width: size.width * 0.112,
                      child: Text(
                        approvedDoctor.email,
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.12,
                      child: Text(
                        approvedDoctor.medicalSpecialty,
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.17,
                      child: Text(
                        approvedDoctor.officeAddress,
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.102,
                      child: Text(
                        approvedDoctor.officePhoneNumber,
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.07,
                      child: Text(
                        DateFormat('MMM d, yyyy')
                            .format(approvedDoctor.created!.toDate()),
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    approvedDoctor.verifiedDate == null
                        ? const SizedBox()
                        : SizedBox(
                            width: size.width * 0.06,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: GinaAppTheme.approvedTextColor
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    DateFormat('MMM d, yyyy').format(
                                        approvedDoctor.verifiedDate!.toDate()),
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
