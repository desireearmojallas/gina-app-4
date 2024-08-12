import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/validators_widget.dart';

final GlobalKey<FormState> doctorRegistrationStepOneFormKey =
    GlobalKey<FormState>();

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();

class DoctorRegistrationStepOne extends StatefulWidget {
  const DoctorRegistrationStepOne({super.key});

  @override
  State<DoctorRegistrationStepOne> createState() =>
      _DoctorRegistrationStepOneState();
}

class _DoctorRegistrationStepOneState extends State<DoctorRegistrationStepOne> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  int currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: doctorRegistrationStepOneFormKey,
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
                  'Step 1',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SF UI Display',
                  ),
                  textAlign: TextAlign.left,
                ),
                const Gap(10),
                _styledFormField('Name', nameController, false),
                const Gap(10),
                _styledFormField('Email', emailController, false),
                const Gap(10),
                _styledFormField(
                  'Password',
                  passwordController,
                  obscurePassword,
                  togglePasswordVisibility: _togglePasswordVisibility,
                ),
                const Gap(10),
                _styledFormField(
                  'Confirm Password',
                  confirmPasswordController,
                  obscureConfirmPassword,
                  togglePasswordVisibility: _toggleConfirmPasswordVisibility,
                ),
                passwordMatchValidator(
                  passwordController.text,
                  confirmPasswordController.text,
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
        color: isActive ? GinaAppTheme.lightPrimaryColor : Colors.grey,
      ),
    );
  }

  Widget _styledFormField(
    String hintText,
    TextEditingController controller,
    bool obscureText, {
    Function()? togglePasswordVisibility,
    IconData? icon,
    Function()? onTap,
    bool readOnly = false,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.28,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $hintText';
              }
              return null;
            },
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: readOnly ? hintText : null,
              labelText: !readOnly ? hintText : null,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontFamily: 'SF UI Display',
                fontWeight: FontWeight.w500,
                color: Color(0xFF9493A0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              suffixIcon: icon != null
                  ? IconButton(
                      icon: Icon(icon),
                      onPressed: onTap,
                    )
                  : null,
            ),
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'SF UI Display',
              fontWeight: FontWeight.w500,
              color: Color(0xFF36344E),
            ),
            readOnly: readOnly,
            onTap: onTap,
          ),
          if (togglePasswordVisibility != null)
            IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: togglePasswordVisibility,
            ),
        ],
      ),
    );
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  void _togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      obscureConfirmPassword = !obscureConfirmPassword;
    });
  }

  ElevatedButton nextButton() {
    return ElevatedButton(
      onPressed: () {
        // TODO: sign up logic here
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: GinaAppTheme.lightPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.45,
        height: 49,
        child: const Center(
          child: Text(
            'Next',
            style: TextStyle(
              color: GinaAppTheme.lightOnPrimaryColor,
              fontSize: 16,
              fontFamily: 'SF UI Display',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
        ),
      ),
    );
  }
}
