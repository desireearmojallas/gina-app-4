import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/2_views/bloc/auth_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/styled_form_field_widget.dart';

final GlobalKey<FormState> doctorRegistrationStepFourFormKey =
    GlobalKey<FormState>();
TextEditingController fellowShipProgramController = TextEditingController();
TextEditingController fellowShipProgramStartDateController =
    TextEditingController();
TextEditingController fellowShipProgramEndDateController =
    TextEditingController();
TextEditingController officeAddressController = TextEditingController();
TextEditingController mapsLocationAddressController = TextEditingController();
TextEditingController officeLatLngAddressController = TextEditingController();
TextEditingController officePhoneNumberController = TextEditingController();

class DoctorRegistrationStepFour extends StatelessWidget {
  const DoctorRegistrationStepFour({super.key});

  final int currentStep = 4;

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Form(
      key: doctorRegistrationStepFourFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPageIndicator(),
          Align(
            alignment: Alignment.topCenter,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Step 4',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SF UI Display',
                      ),
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
                      'Fellowship',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF UI Display',
                      ),
                    ),
                    const Gap(10),
                    styledFormField(
                      context,
                      'Name of the fellowship program',
                      fellowShipProgramController,
                      false,
                    ),
                    const Gap(10),
                    styledFormField(
                      context,
                      'Start Date (January 2018)',
                      fellowShipProgramStartDateController,
                      false,
                      icon: Icons.calendar_today,
                      onTap: () => authBloc.selectDate(
                        context,
                        fellowShipProgramStartDateController,
                      ),
                    ),
                    const Gap(10),
                    styledFormField(
                      context,
                      'End Date (December 2022)',
                      fellowShipProgramEndDateController,
                      false,
                      icon: Icons.calendar_today,
                      onTap: () => authBloc.selectDate(
                        context,
                        fellowShipProgramEndDateController,
                      ),
                    ),
                    const Gap(15),
                    const Text(
                      'Contacts and Address',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF UI Display',
                      ),
                    ),
                    const Gap(20),
                    mapsLocationAddressController.text.isNotEmpty &&
                            officeAddressController.text.isNotEmpty &&
                            state is DoctorGetFullContactsState
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width / 1.28,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(Images.officeAddressLogo),
                                const Gap(10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            mapsLocationAddressController.text,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            officeAddressController.text,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          officePhoneNumberController.text,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color:
                                                    GinaAppTheme.lightOutline,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const Gap(10),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/doctorAddressMap');
                                      },
                                      child: const Text(
                                        'Change',
                                        style: TextStyle(
                                          color: GinaAppTheme.lightTertiaryContainer,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width / 1.28,
                            height: 50,
                            child: OutlinedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/doctorAddressMap');
                              },
                              child: const Text(
                                '+ Add Office Address',
                                style: TextStyle(
                                  color: GinaAppTheme.lightOnSecondary,
                                ),
                              ),
                            ),
                          ),
                  ],
                );
              },
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
        color: isActive ? GinaAppTheme.lightTertiaryContainer : Colors.grey,
      ),
    );
  }
}
