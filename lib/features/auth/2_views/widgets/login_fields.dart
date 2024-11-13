import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/validators_widget.dart';

SizedBox loginFields({
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required bool obscurePassword,
  required Function()? togglePasswordVisibility,
  required BuildContext context,
  Function? onSubmit,
  bool? isAdmin = false,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 1.45,
    child: Column(
      children: [
        // Email Address Form Field
        _buildFormField(
          controller: emailController,
          validator: validateEmail,
        ),

        // Password Form Field
        _buildPasswordField(
          passwordController,
          context,
          validatePassword,
          onSubmit,
          obscurePassword,
          togglePasswordVisibility: togglePasswordVisibility,
        ),

        const Gap(10),

        // Forgot Password Text
        isAdmin == false
            ? Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Navigate to the ForgotPasswordScreen when the Forgot Password text is clicked
                    Navigator.pushNamed(context, '/forgotPassword');
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Color(0xFF979797),
                      fontSize: 14,
                      fontFamily: 'SF UI Display',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    ),
  );
}

// Helper function to build a form field
Widget _buildFormField({
  required TextEditingController controller,
  required String? Function(String?) validator,
}) {
  return SizedBox(
    height: 80,
    child: TextFormField(
      validator: validator,
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Email Address',
      ),
    ),
  );
}

// Helper function to build a password form field
Widget _buildPasswordField(
  TextEditingController controller,
  BuildContext context,
  String? Function(String?) validator,
  Function? onSubmit,
  bool obscureText, {
  Function()? togglePasswordVisibility,
  Function()? onTap,
  bool readOnly = false,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 1.28,
    child: TextFormField(
      onFieldSubmitted: (value) {
        if (onSubmit != null) {
          onSubmit();
        }
      },
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: togglePasswordVisibility,
        ),
      ),
      readOnly: readOnly,
      onTap: onTap,
    ),
  );
}
