import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/2_views/bloc/auth_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/styled_form_field_widget.dart';

final GlobalKey<FormState> doctorRegistrationStepTwoFormKey =
    GlobalKey<FormState>();

TextEditingController medicalSpecialtyController = TextEditingController();
TextEditingController medicalLicenseNumberController = TextEditingController();
TextEditingController boardCertificationOrganizationController =
    TextEditingController();
TextEditingController boardCertificationDateController =
    TextEditingController();

class DoctorRegistrationStepTwo extends StatelessWidget {
  const DoctorRegistrationStepTwo({super.key});

  final int currentStep = 2;

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return Form(
      key: doctorRegistrationStepTwoFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Step 2',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'SF UI Display',
            ),
          ),
          const Gap(10),
          styledFormField(
            context,
            'Medical Specialty (ob-gyne)',
            medicalSpecialtyController,
            false,
          ),
          const Gap(10),
          styledFormField(
            context,
            'License Number',
            medicalLicenseNumberController,
            false,
          ),
          const Gap(15),
          const Text(
            'Board Certication',
            style: TextStyle(
              fontFamily: 'SF UI Display',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(10),
          styledFormField(
            context,
            'Name of the board certificaiton organization',
            boardCertificationOrganizationController,
            false,
          ),
          const Gap(10),
          styledFormField(
            context,
            'Date of board certification',
            boardCertificationDateController,
            false,
            icon: Icons.calendar_today,
            onTap: () => authBloc.selectDate(
              context,
              boardCertificationDateController,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildDot(1),
        buildDot(2),
        buildDot(3),
        buildDot(4),
      ],
    );
  }

  Widget buildDot(int step) {
    final bool isActive = currentStep == step;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? GinaAppTheme.lightPrimaryColor : Colors.grey,
      ),
    );
  }
}
