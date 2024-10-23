// ignore_for_file: must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/2_views/screens/forgot_password/2_views/bloc/forgot_password_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/gina_header.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/validators_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final emailKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final forgotPasswordBloc = context.read<ForgotPasswordBloc>();

    return Scaffold(
      appBar: AppBar(
        title: GinaHeader(size: 45),
      ),
      body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is RequestPasswordResetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Password reset email sent to ${emailController.text}',
                ),
                backgroundColor: GinaAppTheme.lightOnSecondary,
              ),
            );
          }
          if (state is RequestPasswordResetError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: GinaAppTheme.lightError,
              ),
            );
          }
        },
        builder: (context, state) {
          bool isButtonDisabled =
              state is CountdownState && state.countdown > 0;
          String buttonText = 'Send';
          if (state is CountdownState && state.countdown > 0) {
            buttonText = 'Resend in ${state.countdown}';
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 30.0,
                  ),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(10),
                          Text(
                            'Forgot your password?',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const Gap(10),
                          const Text(
                            'Enter the email address associated with your account.',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: GinaAppTheme.lightOutline,
                            ),
                          ),
                          const Gap(10),
                          const Text(
                            'We will email you a link to reset the password of your account.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                      const Gap(50),
                      Form(
                        key: emailKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email-address',
                                hintText: 'Enter your email',
                                hintStyle: const TextStyle(
                                  color: GinaAppTheme.lightOutline,
                                  fontSize: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: validateEmail,
                            ),
                            const Gap(50),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: FilledButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                onPressed: isButtonDisabled
                                    ? null
                                    : () async {
                                        if (emailKey.currentState!.validate()) {
                                          forgotPasswordBloc.add(
                                            RequestPasswordReset(
                                              email: emailController.text,
                                            ),
                                          );
                                        }
                                      },
                                child: BlocBuilder<ForgotPasswordBloc,
                                    ForgotPasswordState>(
                                  builder: (context, state) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 15, 40, 15),
                                      child:
                                          state is RequestPasswordResetLoading
                                              ? const SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child: CustomLoadingIndicator(
                                                    colors: [
                                                      GinaAppTheme
                                                          .lightOnTertiaryContainer,
                                                    ],
                                                  ),
                                                )
                                              : Text(
                                                  buttonText,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(40),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: "Remember your password? ",
                              style: TextStyle(
                                fontSize: 14,
                                color: GinaAppTheme.lightOutline,
                              ),
                            ),
                            TextSpan(
                              text: 'Login',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                    Navigator.pushNamed(context, '/login'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
