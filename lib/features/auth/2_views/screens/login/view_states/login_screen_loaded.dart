import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/features/auth/2_views/bloc/auth_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/gina_header.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/login_button.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/login_fields.dart';

class LoginScreenLoaded extends StatefulWidget {
  const LoginScreenLoaded({super.key});

  @override
  State<LoginScreenLoaded> createState() => _LoginScreenLoadedState();
}

class _LoginScreenLoadedState extends State<LoginScreenLoaded> {
  String selectedType = 'Patient';
  bool obscurePassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    double screenWidth = MediaQuery.of(context).size.width;
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Center(
                child: GestureDetector(
                  onDoubleTap: () {
                    authBloc.add(NavigateToAdminLoginScreenEvent());
                  },
                  child: SvgPicture.asset(
                    Images.appLogo,
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          const GinaHeader(
            size: 60,
          ),
          const Gap(20),
          Container(
            width: 250,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(23),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedType = 'Patient';
                    });
                  },
                  child: buildPositionedOption(
                    'Patient',
                    38,
                    isSelected: selectedType == 'Patient',
                    screenWidth: screenWidth,
                  ),
                ),
                const SizedBox(width: 0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedType = 'Doctor';
                    });
                  },
                  child: buildPositionedOption(
                    'Doctor',
                    38,
                    isSelected: selectedType == 'Doctor',
                    screenWidth: screenWidth,
                  ),
                ),
              ],
            ),
          ),
          const Gap(30),
          loginFields(
            emailController: emailController,
            passwordController: passwordController,
            obscurePassword: obscurePassword,
            togglePasswordVisibility: _togglePasswordVisibility,
            context: context,
          ),
          const Gap(30),
          loginButton(
            selectedType: selectedType,
            emailController: emailController,
            passwordController: passwordController,
            formKey: formKey,
            context: context,
          ),
          const Gap(10),
          signUpButton(context),
          const Spacer(),
        ],
      ),
    );
  }

  AnimatedContainer buildPositionedOption(String label, double height,
      {required bool isSelected, required double screenWidth}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 125,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 100,
        height: height,
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFFFFC0CB) : const Color(0xFFF3F3F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(23),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF36344E)
                  : const Color(0XFF9493A0),
              fontSize: 12,
              fontFamily: 'SF UI Display',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }
}
