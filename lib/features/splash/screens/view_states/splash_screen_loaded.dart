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

/* import 'package:flutter/material.dart';
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
} */

/* import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:splash_view/source/presentation/pages/splash_view.dart';
import 'package:splash_view/source/presentation/widgets/background_decoration.dart';

class SplashScreenInitial extends StatelessWidget {
  const SplashScreenInitial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SplashView(
              showStatusBar: true,
              backgroundImageDecoration: BackgroundImageDecoration(
                image: AssetImage(Images.splashPic),
                fit: BoxFit.fitHeight,
              ),
              logo: Column(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} */
