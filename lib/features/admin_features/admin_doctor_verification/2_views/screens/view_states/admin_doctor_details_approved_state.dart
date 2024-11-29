import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/square_avatar.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/bloc/admin_dashboard_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/bloc/admin_doctor_verification_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/doctor_details_state_widgets/detailed_view_icon.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/doctor_details_state_widgets/submitted_requirements_table_label.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_verification_model.dart';
import 'package:icons_plus/icons_plus.dart';

class AdminDoctorDetailsApprovedState extends StatelessWidget {
  final DoctorModel approvedDoctorDetails;
  final List<DoctorVerificationModel> doctorVerification;
  const AdminDoctorDetailsApprovedState(
      {super.key,
      required this.approvedDoctorDetails,
      required this.doctorVerification});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    const headingText = TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    );
    const labelText = TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
      color: GinaAppTheme.lightOutline,
    );
    const valueText = TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
    );

    final adminDoctorVerificationBloc =
        context.read<AdminDoctorVerificationBloc>();
    final adminDashboardBloc = context.read<AdminDashboardBloc>();

    String extractCountry(String address) {
      final countryRegex = RegExp(r'\b[A-Za-z\s]+$');
      final match = countryRegex.firstMatch(address);
      return match?.group(0) ?? address;
    }

    final countryOrAddress =
        extractCountry(approvedDoctorDetails.officeMapsLocationAddress);

    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 22.0),
        child: Container(
          height: size.height * 1.02,
          width: size.width / 1.15,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: IconButton(
                  onPressed: () {
                    if (isFromAdminDashboard) {
                      adminDashboardBloc.add(AdminDashboardGetRequestedEvent());
                    } else {
                      adminDoctorVerificationBloc
                          .add(AdminDoctorVerificationGetRequestedEvent());
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: GinaAppTheme.lightOutline,
                  ),
                ),
              ),

              // Doctor Primary Details
              Padding(
                padding: const EdgeInsets.only(left: 60.0, right: 40.0),
                child: Row(
                  children: [
                    SquareAvatar(
                      image: AssetImage(
                        Images.doctorProfileIcon1,
                      ),
                    ),
                    const Gap(40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.4,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Dr. ${approvedDoctorDetails.name}',
                                      style: const TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  const Gap(8),
                                  const Icon(
                                    Icons.verified,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                  const Gap(10),
                                  Row(
                                    children: [
                                      const Icon(
                                        MingCute.location_fill,
                                        color:
                                            GinaAppTheme.lightTertiaryContainer,
                                      ),
                                      const Gap(5),
                                      SizedBox(
                                        width: size.width * 0.1,
                                        child: Text(
                                          countryOrAddress,
                                          style: const TextStyle(
                                            color: GinaAppTheme
                                                .lightTertiaryContainer,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // const Gap(230),
                            // const DoctorVerificationStatusChip(
                            //   verificationStatus: 1,
                            //   scale: 2.0,
                            // ),
                          ],
                        ),
                        const Gap(10),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffF2F2F2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 5.0,
                            ),
                            child: Text(
                              approvedDoctorDetails.medicalSpecialty
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0,
                              ),
                            ),
                          ),
                        ),
                        const Gap(20),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'License number:',
                                      style: labelText,
                                    ),
                                    Gap(20),
                                    Text(
                                      approvedDoctorDetails
                                          .medicalLicenseNumber,
                                      style: valueText,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                const Gap(12),
                                Row(
                                  children: [
                                    const Text(
                                      'E-mail address:',
                                      style: labelText,
                                    ),
                                    const Gap(20),
                                    Text(
                                      approvedDoctorDetails.email,
                                      style: valueText.copyWith(
                                        color:
                                            GinaAppTheme.lightTertiaryContainer,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                const Gap(12),
                                Row(
                                  children: [
                                    const Text(
                                      'Contact number:',
                                      style: labelText,
                                    ),
                                    const Gap(20),
                                    Text(
                                      approvedDoctorDetails.officePhoneNumber,
                                      style: valueText.copyWith(
                                        color:
                                            GinaAppTheme.lightTertiaryContainer,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                const Gap(12),
                                Row(
                                  children: [
                                    Text(
                                      'Office address:',
                                      style: labelText,
                                    ),
                                    Gap(20),
                                    Text(
                                      approvedDoctorDetails.officeLatLngAddress,
                                      style: valueText,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Gap(450),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Gap(5),
                                    const DetailedViewIcon(
                                      icon: Icon(
                                        Icons.calendar_today_rounded,
                                        color: GinaAppTheme.lightOutline,
                                        size: 20,
                                      ),
                                    ),
                                    const Gap(18),
                                    Text(
                                      'DATE REGISTERED',
                                      style: labelText.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Gap(33),
                                    const Text(
                                      'December 12, 2021',
                                      style: valueText,
                                    ),
                                  ],
                                ),
                                const Gap(5),
                                divider(size.width * 0.18),
                                const Gap(5),
                                Row(
                                  children: [
                                    const Gap(5),
                                    const DetailedViewIcon(
                                      icon: Icon(
                                        Icons.verified_rounded,
                                        color: GinaAppTheme.lightOutline,
                                        size: 20,
                                      ),
                                    ),
                                    const Gap(18),
                                    Text(
                                      'DATE SUBMITTED',
                                      style: labelText.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Gap(33),
                                    const Text(
                                      'December 12, 2021',
                                      style: valueText,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  const Gap(300),
                  divider(size.width * 0.65),
                ],
              ),

              // Education Experience
              // const Gap(25),
              Padding(
                padding: const EdgeInsets.only(left: 60.0, right: 40.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Board Certification',
                          style: headingText,
                        ),
                        const Gap(19),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.105,
                              child: const Text(
                                'Name of the Board\nCertification Organization:',
                                style: labelText,
                              ),
                            ),
                            const Gap(49),
                            SizedBox(
                              width: size.width * 0.2,
                              child: const Text(
                                'Philippine Board of Obstetric and Gynecology',
                                style: valueText,
                              ),
                            ),
                          ],
                        ),
                        const Gap(12),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.105,
                              child: const Text(
                                'Date of certification:',
                                style: labelText,
                              ),
                            ),
                            const Gap(49),
                            const Text(
                              'December 5, 2010',
                              style: valueText,
                            ),
                          ],
                        ),
                        const Gap(18),
                        divider(size.width * 0.35),
                        const Gap(12),
                        Text(
                          'Education Experience',
                          style: headingText.copyWith(
                            fontSize: 18.0,
                          ),
                        ),
                        const Gap(11),
                        const Text(
                          'Medical School',
                          style: headingText,
                        ),
                        const Gap(19),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.105,
                              child: const Text(
                                'Name of the Medical\nSchool Attended:',
                                style: labelText,
                              ),
                            ),
                            const Gap(49),
                            SizedBox(
                              width: size.width * 0.2,
                              child: const Text(
                                'Manila Central University College of Medicine',
                                style: valueText,
                              ),
                            ),
                          ],
                        ),
                        const Gap(12),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.105,
                              child: const Text(
                                'Start date:',
                                style: labelText,
                              ),
                            ),
                            const Gap(49),
                            const Text(
                              'December 15, 2005',
                              style: valueText,
                            ),
                          ],
                        ),
                        const Gap(12),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.105,
                              child: const Text(
                                'End date:',
                                style: labelText,
                              ),
                            ),
                            const Gap(49),
                            const Text(
                              'March 15, 2010',
                              style: valueText,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(44),
                    SizedBox(
                      height: size.height * 0.4,
                      child: const VerticalDivider(
                        color: GinaAppTheme.lightOutline,
                        thickness: 0.3,
                      ),
                    ),
                    const Gap(44),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Residency Program',
                          style: headingText,
                        ),
                        const Gap(19),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.105,
                              child: const Text(
                                'Name of the Medical\nSchool Attended:',
                                style: labelText,
                              ),
                            ),
                            const Gap(49),
                            SizedBox(
                              width: size.width * 0.2,
                              child: const Text(
                                'Philippine General Hospital - Obstetrics and Gynecology Residency Program',
                                style: valueText,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        const Gap(12),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.105,
                              child: const Text(
                                'Start date:',
                                style: labelText,
                              ),
                            ),
                            const Gap(49),
                            const Text(
                              'December 15, 2005',
                              style: valueText,
                            ),
                          ],
                        ),
                        const Gap(12),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.105,
                              child: const Text(
                                'End date:',
                                style: labelText,
                              ),
                            ),
                            const Gap(49),
                            const Text(
                              'March 15, 2010',
                              style: valueText,
                            ),
                          ],
                        ),
                        const Gap(18),
                        divider(size.width * 0.35),
                        const Gap(12),
                        const Text(
                          'Fellowship',
                          style: headingText,
                        ),
                        const Gap(19),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.105,
                              child: const Text(
                                'Name of the Medical\nSchool Attended:',
                                style: labelText,
                              ),
                            ),
                            const Gap(49),
                            SizedBox(
                              width: size.width * 0.2,
                              child: const Text(
                                'Reproductive Endocrinology and Infertility Fellowship',
                                style: valueText,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        const Gap(12),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.105,
                              child: const Text(
                                'End date:',
                                style: labelText,
                              ),
                            ),
                            const Gap(49),
                            const Text(
                              'March 15, 2010',
                              style: valueText,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              divider(size.width * 1),
              const Gap(20),
              const Padding(
                padding: EdgeInsets.only(left: 60.0, right: 40.0),
                child: Text(
                  'Submitted Requirements (10)',
                  style: headingText,
                ),
              ),
              const Gap(20),
              submittedRequirementsTableLabel(size, ginaTheme),
              // const SubmissionsDataList(
              //   verificationStatus: 1,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget divider(width) {
    return SizedBox(
      width: width,
      child: const Divider(
        color: GinaAppTheme.lightOutline,
        thickness: 0.3,
      ),
    );
  }
}
