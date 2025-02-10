import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/widgets/doctor_name_widget.dart';
import 'package:gina_app_4/features/patient_features/consultation_fee_details/2_views/screens/view_states/consultation_fee_no_pricing_screen.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';

class ConsultationFeeDetailsInitialScreen extends StatelessWidget {
  final bool isPricingShown;
  final DoctorModel doctor;
  const ConsultationFeeDetailsInitialScreen(
      {super.key, required this.isPricingShown, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    return doctorDetails!.f2fInitialConsultationPrice == null
        ? ConsultationFeeNoPricingScreen(
            doctor: doctor,
          )
        : isPricingShown == false
            ? ConsultationFeeNoPricingScreen(
                doctor: doctor,
              )
            : Column(
                children: [
                  doctorNameWidget(size, ginaTheme, doctor),
                  Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10.0),
                            child: Text(
                              'Face-to-face Consultation'.toUpperCase(),
                              style: ginaTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Container(
                            height: size.height * 0.15,
                            width: size.width * 0.92,
                            padding: const EdgeInsets.all(30.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween, //space evenly
                                  children: [
                                    Text(
                                      'Initial consultation',
                                      style: ginaTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: GinaAppTheme.lightOutline,
                                      ),
                                    ),
                                    Text(
                                      doctor.f2fInitialConsultationPrice != null
                                          ? '₱${doctor.f2fInitialConsultationPrice?.toStringAsFixed(2)}'
                                          : '₱0.00',
                                      style: ginaTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(10),
                                const Divider(
                                  thickness: 0.5,
                                  color: GinaAppTheme.lightOutline,
                                ),
                                const Gap(10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween, //space evenly
                                  children: [
                                    Text(
                                      'Follow-up consultation',
                                      style: ginaTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: GinaAppTheme.lightOutline,
                                      ),
                                    ),
                                    Text(
                                      doctor.f2fFollowUpConsultationPrice !=
                                              null
                                          ? '₱${doctor.f2fFollowUpConsultationPrice?.toStringAsFixed(2)}'
                                          : '₱0.00',
                                      style: ginaTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10.0),
                            child: Text(
                              'Online Consultation'.toUpperCase(),
                              style: ginaTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Container(
                            height: size.height * 0.15,
                            width: size.width * 0.92,
                            padding: const EdgeInsets.all(30.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween, //space evenly
                                  children: [
                                    Text(
                                      'Initial consultation',
                                      style: ginaTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: GinaAppTheme.lightOutline,
                                      ),
                                    ),
                                    Text(
                                      doctor.olInitialConsultationPrice != null
                                          ? '₱${doctor.olInitialConsultationPrice?.toStringAsFixed(2)}'
                                          : '₱0.00',
                                      style: ginaTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(10),
                                const Divider(
                                  thickness: 0.5,
                                  color: GinaAppTheme.lightOutline,
                                ),
                                const Gap(10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween, //space evenly
                                  children: [
                                    Text(
                                      'Follow-up consultation',
                                      style: ginaTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: GinaAppTheme.lightOutline,
                                      ),
                                    ),
                                    Text(
                                      doctor.olFollowUpConsultationPrice != null
                                          ? '₱${doctor.olFollowUpConsultationPrice?.toStringAsFixed(2)}'
                                          : '₱0.00',
                                      style: ginaTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(5),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 35.0),
                        child: Text(
                          'Please note that the price list is for information only and there will be no payment handling inside the app.',
                          textAlign: TextAlign.center,
                          style: ginaTheme.bodySmall?.copyWith(
                            color: GinaAppTheme.lightOutline,
                          ),
                        ),
                      ),
                      const Gap(10),
                    ],
                  ),
                  const Gap(100),
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
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/bookAppointment',
                          arguments: doctor,
                        );
                      },
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
              );
  }
}
