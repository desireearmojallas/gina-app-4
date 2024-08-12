import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/features/auth/2_views/bloc/auth_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/styled_form_field_widget.dart';

final GlobalKey<FormState> doctorRegistrationStepThreeFormKey =
    GlobalKey<FormState>();

TextEditingController medicalSchoolController = TextEditingController();
TextEditingController medicalSchoolStartDateController =
    TextEditingController();
TextEditingController medicalSchoolEndDateController = TextEditingController();
TextEditingController residencyProgramController = TextEditingController();
TextEditingController residencyProgramStartDateController =
    TextEditingController();
TextEditingController residencyProgramGraduationYearController =
    TextEditingController();

class DoctorRegistrationStepThree extends StatelessWidget {
  const DoctorRegistrationStepThree({super.key});

  final int currentStep = 3;

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return Form(
      key: doctorRegistrationStepThreeFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPageIndicator(),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Step 3',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SF UI Display',
                  ),
                  textAlign: TextAlign.left,
                ),
                const Gap(10),
                const Text(
                  'Education Experience',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF UI Display',
                  ),
                ),
                const Gap(5),
                const Text(
                  'Medical School',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF UI Display',
                  ),
                ),
                const Gap(10),
                styledFormField(
                  context,
                  'Name of the medical school attended',
                  medicalSchoolController,
                  false,
                ),
                const Gap(10),
                styledFormField(
                  context,
                  'Start Date',
                  medicalSchoolStartDateController,
                  false,
                  icon: Icons.calendar_today,
                  onTap: () => authBloc.selectDate(
                    context,
                    medicalSchoolStartDateController,
                  ),
                  readOnly: true,
                ),
                const Gap(10),
                styledFormField(
                  context,
                  'End Date',
                  medicalSchoolEndDateController,
                  false,
                  icon: Icons.calendar_today,
                  onTap: () => authBloc.selectDate(
                    context,
                    medicalSchoolEndDateController,
                  ),
                  readOnly: true,
                ),
                const Gap(10),
                const Text(
                  'Residency Program',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF UI Display',
                  ),
                ),
                const Gap(10),
                styledFormField(
                  context,
                  'Name of the residency program',
                  residencyProgramController,
                  false,
                ),
                const Gap(10),
                styledFormField(
                  context,
                  'Start Date',
                  residencyProgramStartDateController,
                  false,
                  icon: Icons.calendar_today,
                  onTap: () => authBloc.selectDate(
                    context,
                    residencyProgramStartDateController,
                  ),
                  readOnly: true,
                ),
                const Gap(10),
                styledFormField(
                  context,
                  'End Date',
                  residencyProgramGraduationYearController,
                  false,
                  icon: Icons.calendar_today,
                  onTap: () => authBloc.selectDate(
                    context,
                    residencyProgramGraduationYearController,
                  ),
                  readOnly: true,
                ),
              ],
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
        color: isActive ? const Color(0xFFFFC0CB) : Colors.grey,
      ),
    );
  }
}
