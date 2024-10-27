import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/2_views/bloc/auth_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/screens/sign_up/signup_screen.dart';

SizedBox loginButton({
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required GlobalKey<FormState> formKey,
  required String selectedType,
  required BuildContext context,
}) {
  final authBloc = context.read<AuthBloc>();

  return SizedBox(
    width: MediaQuery.of(context).size.width / 1.45,
    height: 49,
    child: buildButton(
      label: 'Login',
      onPressed: () {
        if (formKey.currentState?.validate() ?? false) {
          if (selectedType == 'Doctor') {
            authBloc.add(
              AuthLoginDoctorEvent(
                email: emailController.text,
                password: passwordController.text,
              ),
            );
          } else {
            authBloc.add(
              AuthLoginPatientEvent(
                email: emailController.text,
                password: passwordController.text,
              ),
            );
          }
        }
        // TODO: FOCUS SCOPE
        FocusScope.of(context).unfocus();
      },
      backgroundColor: GinaAppTheme.lightTertiaryContainer,
      isLoading: authBloc.state is AuthLoginLoadingState,
    ),
  );
}

SizedBox signUpButton({
  required BuildContext context,
  required String selectedType,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 1.45,
    height: 49,
    child: buildButton(
      label: 'Sign Up',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SignupPage(
                    isDoctor: selectedType == 'Doctor',
                  )),
        );
      },
      backgroundColor: const Color(0xFFF3F3F3),
      isLoading: false,
      isSignUpButton: true,
    ),
  );
}

Widget buildButton({
  required label,
  required void Function() onPressed,
  required Color backgroundColor,
  required bool isLoading,
  bool isSignUpButton = false,
}) {
  return BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) {
      return SizedBox(
        width: double.infinity,
        height: 49,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CustomLoadingIndicator(
                    colors: [
                      GinaAppTheme.appbarColorLight,
                    ],
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    color: isSignUpButton
                        ? GinaAppTheme.lightOnBackground
                        : GinaAppTheme.lightOnTertiaryContainer,
                    fontSize: 16,
                    fontFamily: 'SF UI Display',
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      );
    },
  );
}
