import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class DeclinedDoctorVerificationList extends StatelessWidget {
  const DeclinedDoctorVerificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: GinaAppTheme.lightScrim,
          thickness: 0.1,
          height: 11,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: Row(
              children: [
                SizedBox(
                  height: size.height * 0.05,
                  child: Container(
                    width: 5,
                    color: GinaAppTheme.declinedTextColor,
                  ),
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: GinaAppTheme.declinedTextColor,
                      foregroundImage: AssetImage(
                        Images.doctorProfileIcon1,
                      ),
                    ),
                    const Gap(15),
                    SizedBox(
                      width: size.width * 0.175,
                      child: Text(
                        'Dr. Desiree Armojallas, MD FPOGS, FPSUOG',
                        style: ginaTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.112,
                      child: Text(
                        'desireearmojallas@gina.com',
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.12,
                      child: Text(
                        'Obstretrics & Gynecology',
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.17,
                      child: Text(
                        'Dr. Desiree Armojallas Clinic, 1234 Main St., Looc, Lapu-Lapu City, Cebu, PH 6015',
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.102,
                      child: Text(
                        '+63 123 456 7890',
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.07,
                      child: Text(
                        '11/12/2021',
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.06,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                GinaAppTheme.declinedTextColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              '11/12/2021',
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
