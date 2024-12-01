import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/doctor_verification_status_chip.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_verification_model.dart';
import 'package:intl/intl.dart';

class SubmissionsDataList extends StatelessWidget {
  final List<DoctorVerificationModel> doctorVerification;
  final DoctorModel doctorDetails;
  const SubmissionsDataList(
      {super.key,
      required this.doctorVerification,
      required this.doctorDetails});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const textStyle = TextStyle(
      color: GinaAppTheme.lightOnPrimaryColor,
      fontSize: 12.0,
      fontWeight: FontWeight.w600,
    );
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: GinaAppTheme.lightScrim,
          thickness: 0.2,
          height: 5,
        ),
        itemCount: doctorVerification.length,
        itemBuilder: (context, index) {
          final verification = doctorVerification[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(65),
                SizedBox(
                  width: size.width * 0.19,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Dr. ${doctorDetails.name}',
                      style: textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                    ),
                  ),
                ),
                const Gap(10),
                SizedBox(
                  width: size.width * 0.12,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      doctorDetails.email,
                      style: textStyle,
                      softWrap: true,
                    ),
                  ),
                ),
                const Gap(10),
                SizedBox(
                  width: size.width * 0.12,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      doctorDetails.medicalLicenseNumber,
                      style: textStyle,
                      softWrap: true,
                    ),
                  ),
                ),
                const Gap(10),
                Tooltip(
                  message: 'View Medical License Image',
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: Container(
                              height: size.height * 0.6,
                              width: size.width * 0.6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    verification.medicalLicenseImage,
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: SizedBox(
                      width: size.width * 0.12,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          verification.medicalLicenseImageTitle,
                          style: textStyle.copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor:
                                GinaAppTheme.lightTertiaryContainer,
                            color: GinaAppTheme.lightTertiaryContainer,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                SizedBox(
                  width: size.width * 0.1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      (verification.verificationStatus ==
                              DoctorVerificationStatus.approved.index)
                          ? DateFormat('MMM d, yyyy')
                              .format(verification.dateSubmitted.toDate())
                          : (verification.verificationStatus ==
                                  DoctorVerificationStatus.declined.index)
                              ? DateFormat('MMM d, yyyy')
                                  .format(doctorDetails.verifiedDate!.toDate())
                              : DateFormat('MMM d, yyyy')
                                  .format(doctorDetails.verifiedDate!.toDate()),
                      style: textStyle,
                    ),
                  ),
                ),
                const Gap(10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: size.width * 0.09,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: DoctorVerificationStatusChip(
                        verificationStatus: verification.verificationStatus,
                        declinedReason: verification.declineReason.toString(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
