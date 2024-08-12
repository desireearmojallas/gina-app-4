import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/gina_header.dart';
import 'package:lottie/lottie.dart';

class SplashScreenInitial extends StatelessWidget {
  const SplashScreenInitial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: SvgPicture.asset(
                'assets/images/gina_logo.svg',
                width: 50,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              width: 400,
              child: Center(
                child: Lottie.asset(
                  'assets/images/girl_yoga_loading.json',
                  repeat: true,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            const GinaHeader(size: 75),
          ],
        ),
      ),
    );
  }
}
