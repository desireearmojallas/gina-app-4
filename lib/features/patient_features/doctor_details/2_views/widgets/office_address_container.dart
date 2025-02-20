// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/patient_features/doctor_details/2_views/bloc/doctor_details_bloc.dart';

class OfficeAddressContainer extends StatelessWidget {
  final DoctorModel doctor;

  const OfficeAddressContainer({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    final doctorDetailsBloc = context.read<DoctorDetailsBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Office Address'.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(10),
        GestureDetector(
          onTap: () {
            debugPrint('Office Address Container Tapped');
            doctorDetailsBloc.add(NavigateToDoctorOfficeAddressMapViewEvent());
          },
          child: IntrinsicHeight(
            child: Container(
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Image.asset(
                            Images.officeAddressLogo,
                            width: 20,
                          ),
                          const Gap(20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.65,
                                child: Text(
                                  doctor.officeAddress,
                                  style: ginaTheme.bodyMedium?.copyWith(
                                    color: GinaAppTheme.lightOnPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.65,
                                child: Text(
                                  doctor.officeMapsLocationAddress,
                                  style: ginaTheme.bodySmall,
                                ),
                              ),
                              const Gap(5),
                              Text(
                                doctor.officePhoneNumber,
                                style: ginaTheme.bodySmall?.copyWith(
                                  color: GinaAppTheme.lightOutline,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
