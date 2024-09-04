import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';

class SplashScreenInitial extends StatelessWidget {
  const SplashScreenInitial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.splashPic),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Images.appLogo,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                width: 150,
              ),
              const Text(
                'GINA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 75,
                  fontFamily: 'Cormorant Upright',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const CustomLoadingIndicator(
                colors: [
                  Colors.white,
                  Colors.white30,
                  Colors.white60,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
