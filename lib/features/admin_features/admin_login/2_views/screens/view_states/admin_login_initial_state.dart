import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
// import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_login/2_views/bloc/admin_login_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/gina_header.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/login_fields.dart';

class AdminLoginInitialState extends StatefulWidget {
  const AdminLoginInitialState({super.key});

  @override
  State<AdminLoginInitialState> createState() => _AdminLoginInitialStateState();
}

class _AdminLoginInitialStateState extends State<AdminLoginInitialState> {
  bool obscurePassword = true;
  final TextEditingController emailAdminController = TextEditingController();
  final TextEditingController passwordAdminController = TextEditingController();

  final adminFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final adminLoginBloc = context.read<AdminLoginBloc>();
    return Form(
      key: adminFormKey,
      child: Stack(
        children: [
          // const GradientBackground(),
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.splashPic),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              height: size.height * 0.6,
              width: size.width * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  GinaAppTheme.defaultBoxShadow,
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 80.0),
                child: SizedBox(
                  width: size.width / 2.5,
                  height: size.height / 1.5,
                  child: Column(
                    children: [
                      const Gap(30),
                      SvgPicture.asset(
                        Images.appLogo,
                        height: 120,
                      ),
                      GinaHeader(size: 50),
                      adminContainerText(),
                      const Gap(40),
                      SizedBox(
                        width: size.width / 2.5,
                        child: loginFields(
                          isAdmin: true,
                          emailController: emailAdminController,
                          passwordController: passwordAdminController,
                          obscurePassword: obscurePassword,
                          togglePasswordVisibility: _togglePasswordVisibility,
                          onSubmit: () {
                            if (adminFormKey.currentState!.validate()) {
                              adminLoginBloc.add(
                                AdminLoginEventLogin(
                                  email: emailAdminController.text,
                                  password: passwordAdminController.text,
                                ),
                              );
                            }
                          },
                          context: context,
                        ),
                      ),
                      const Gap(40),
                      SizedBox(
                        width: size.width / 1.45,
                        height: size.height / 20,
                        child: FilledButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (adminFormKey.currentState!.validate()) {
                              adminLoginBloc.add(
                                AdminLoginEventLogin(
                                  email: emailAdminController.text,
                                  password: passwordAdminController.text,
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  Widget adminContainerText() {
    return SizedBox(
      width: 60,
      height: 20,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 60,
              height: 20,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: GinaAppTheme.lightOnPrimaryColor,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 6,
            top: 1,
            child: Text(
              'ADMIN',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: GinaAppTheme.lightOnPrimaryColor,
                fontSize: 15,
                fontFamily: 'Cormorant Upright',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
