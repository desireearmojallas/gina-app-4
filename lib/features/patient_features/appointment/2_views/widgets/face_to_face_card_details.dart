import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';

class FaceToFaceCardDetails extends StatelessWidget {
  const FaceToFaceCardDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      child: Container(
        width: size.width * 1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: size.height * 0.065,
              width: size.width * 1,
              decoration: const BoxDecoration(
                color: Color(0xFFFB6C85),
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Center(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 30,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.9),
                                    width: 2.0,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 17,
                                  backgroundColor: Colors.transparent,
                                  foregroundImage:
                                      AssetImage(Images.patientProfileIcon),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.9),
                                  width: 2.0,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 17,
                                backgroundColor: Colors.transparent,
                                foregroundImage:
                                    AssetImage(Images.doctorProfileIcon1),
                              ),
                            ),
                          ],
                        ),
                        const Gap(40),
                        Text(
                          'Ongoing Appointment Details',
                          style: ginaTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            IntrinsicHeight(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
                //! continue here with the card from appointment_details_card.dart
              ),
            ),
          ],
        ),
      ),
    );
  }
}
