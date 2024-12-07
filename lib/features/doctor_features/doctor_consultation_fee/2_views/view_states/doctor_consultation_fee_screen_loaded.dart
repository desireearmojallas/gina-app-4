import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/bloc/doctor_consultation_fee_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/widgets/doctor_name_widget.dart';

class ToggleValue extends ValueNotifier<bool> {
  ToggleValue(super.value);

  void toggle() {
    value = !value;
  }
}

class DoctorConsultationFeeScreenLoaded extends StatelessWidget {
  final DoctorModel doctorData;
  const DoctorConsultationFeeScreenLoaded({
    super.key,
    required this.doctorData,
  });

  @override
  Widget build(BuildContext context) {
    ToggleValue toggleValue = ToggleValue(doctorData.showConsultationPrice!);

    final ginaTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    final doctorConsultationBloc = context.read<DoctorConsultationFeeBloc>();

    return SingleChildScrollView(
      child: Column(
        children: [
          doctorNameWidget(size, ginaTheme, doctorData),
          const Gap(5),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            height: size.height * 0.06,
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder(
                  valueListenable: toggleValue,
                  builder: (context, value, child) {
                    return value
                        ? Text(
                            'Hide Pricing',
                            style: ginaTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : Text(
                            'Show Pricing',
                            style: ginaTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          );
                  },
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: toggleValue,
                  builder: (context, value, child) {
                    return Switch(
                      thumbColor: MaterialStateProperty.all<Color>(
                        GinaAppTheme.appbarColorLight,
                      ),
                      value: value,
                      onChanged: (newValue) {
                        doctorConsultationBloc
                            .add(ToggleDoctorConsultationFeeEvent());
                        toggleValue.toggle();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const Gap(10),
          ValueListenableBuilder<bool>(
            valueListenable: toggleValue,
            builder: ((context, value, child) {
              return value
                  ? Column(
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
                                        doctorData.f2fInitialConsultationPrice !=
                                                null
                                            ? '₱${doctorData.f2fInitialConsultationPrice?.toStringAsFixed(2)}'
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
                                        doctorData.f2fFollowUpConsultationPrice !=
                                                null
                                            ? '₱${doctorData.f2fFollowUpConsultationPrice?.toStringAsFixed(2)}'
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
                                        doctorData.olInitialConsultationPrice !=
                                                null
                                            ? '₱${doctorData.olInitialConsultationPrice?.toStringAsFixed(2)}'
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
                                        doctorData.olFollowUpConsultationPrice !=
                                                null
                                            ? '₱${doctorData.olFollowUpConsultationPrice?.toStringAsFixed(2)}'
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
                    )
                  : Column(
                      children: [
                        Image.asset(
                          Images.hiddenConsultationFeeIllustration,
                          width: size.width * 0.65,
                        ),
                        const Gap(20),
                        Text(
                          'Your pricing is now hidden.',
                          style: ginaTheme.headlineSmall,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 35.0),
                          child: Text(
                            'We understand the importance of price transparency and encourage you to share your pricing details during your consultation.',
                            textAlign: TextAlign.center,
                            style: ginaTheme.bodySmall?.copyWith(
                              color: GinaAppTheme.lightOutline,
                            ),
                          ),
                        ),
                        const Gap(55),
                      ],
                    );
            }),
          ),
          SizedBox(
            height: size.height * 0.06,
            width: size.width * 0.9,
            child: FilledButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                doctorConsultationBloc
                    .add(NavigateToEditDoctorConsultationFeeEvent());
              },
              child: Text(
                'Edit consultation fees',
                style: ginaTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
