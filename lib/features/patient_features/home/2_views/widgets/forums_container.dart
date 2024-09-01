import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class ForumsContainer extends StatelessWidget {
  const ForumsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final ginaTheme = Theme.of(context);
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color: GinaAppTheme.lightPrimaryColor,
          color: GinaAppTheme.lightTertiaryContainer,
          // gradient: const LinearGradient(
          //   colors: [
          //     GinaAppTheme.lightTertiaryContainer,
          //     GinaAppTheme.lightPrimaryColor,
          //     GinaAppTheme.lightSecondary,
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        height: height * 0.173,
        width: width / 2.99,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset(
              Images.forumImage,
              height: height * 0.10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Forums',
                  style: ginaTheme.textTheme.headlineSmall?.copyWith(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // const Gap(10),
          ],
        ),
      ),
    );
  }
}
