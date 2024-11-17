import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/doctor_verification_status_chip.dart';

class SubmissionsDataList extends StatelessWidget {
  const SubmissionsDataList({super.key});

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
        itemCount: 10,
        itemBuilder: (context, index) {
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
                      'Dr. Desiree Armojallas, MD FPOGS, FSOUG',
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
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'desireearmojallas@gina.com',
                      style: textStyle,
                      softWrap: true,
                    ),
                  ),
                ),
                const Gap(10),
                SizedBox(
                  width: size.width * 0.12,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'MD-1234567890',
                      style: textStyle,
                      softWrap: true,
                    ),
                  ),
                ),
                const Gap(10),
                InkWell(
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
                                  image: AssetImage(
                                    Images.doctorProfileIcon1,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: SizedBox(
                    width: size.width * 0.12,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'medical_license.png',
                        style: textStyle.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: GinaAppTheme.lightTertiaryContainer,
                          color: GinaAppTheme.lightTertiaryContainer,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                SizedBox(
                  width: size.width * 0.1,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Dec 14, 2023',
                      style: textStyle,
                    ),
                  ),
                ),
                const Gap(10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: size.width * 0.09,
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: DoctorVerificationStatusChip(
                        verificationStatus: 0,
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
