import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/doctor_details_state_widgets/detailed_view_icon.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/widgets/doctor_name_widget.dart';
import 'package:gina_app_4/features/patient_features/doctor_details/2_views/screens/widgets/details_container_navigation.dart';
import 'package:gina_app_4/features/patient_features/doctor_details/2_views/screens/widgets/office_address_container.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorDetailsScreenLoaded extends StatelessWidget {
  final DoctorModel doctor;
  const DoctorDetailsScreenLoaded({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    const valueStyle = TextStyle(
      fontSize: 12.0,
    );
    const labelStyle = TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
    );

    return ScrollbarCustom(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            //! will change this currentActiveDoctor once bloc is implemented
            doctorNameWidget(size, ginaTheme, doctor),

            // const Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DetailsContainerNavigation(
                        icon: Icons.monetization_on,
                        containerLabel: 'Consultation Fee\nDetails',
                        onTap: () {},
                      ),
                      DetailsContainerNavigation(
                        icon: Icons.date_range,
                        containerLabel: 'Appointment\nDetails',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const Gap(20),
                  OfficeAddressContainer(
                    doctor: doctor,
                  ),
                  const Gap(20),
                  Text(
                    'Availability'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(10),
                  IntrinsicHeight(
                    child: Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                children: [
                                  const DetailedViewIcon(
                                    icon: Icon(
                                      Icons.calendar_today_rounded,
                                      color: GinaAppTheme.lightOutline,
                                      size: 20,
                                    ),
                                  ),
                                  const Gap(20),
                                  SizedBox(
                                    width: size.width * 0.21,
                                    child: const Text(
                                      'OFFICE DAYS',
                                      style: labelStyle,
                                    ),
                                  ),
                                  const Gap(35),
                                ],
                              ),
                            ),
                            divider(size.width * 0.9),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                children: [
                                  const DetailedViewIcon(
                                    icon: Icon(
                                      MingCute.time_fill,
                                      color: GinaAppTheme.lightOutline,
                                      size: 20,
                                    ),
                                  ),
                                  const Gap(20),
                                  SizedBox(
                                    width: size.width * 0.21,
                                    child: const Text(
                                      'OFFICE HOURS',
                                      style: labelStyle,
                                    ),
                                  ),
                                  const Gap(35),
                                ],
                              ),
                            ),
                            divider(size.width * 0.9),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                children: [
                                  const DetailedViewIcon(
                                    icon: Icon(
                                      Icons.assignment_ind,
                                      color: GinaAppTheme.lightOutline,
                                      size: 20,
                                    ),
                                  ),
                                  const Gap(20),
                                  SizedBox(
                                    width: size.width * 0.21,
                                    child: const Text(
                                      'MODE OF\nAPPOINTMENT',
                                      style: labelStyle,
                                    ),
                                  ),
                                  const Gap(35),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Gap(30),
                  SizedBox(
                    width: size.width * 0.93,
                    height: size.height / 17,
                    child: FilledButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Book Appointment',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget divider(width) {
    return Column(
      children: [
        const Gap(10),
        SizedBox(
          width: width,
          child: const Divider(
            color: GinaAppTheme.lightOutline,
            thickness: 0.3,
          ),
        ),
        const Gap(10),
      ],
    );
  }
}
