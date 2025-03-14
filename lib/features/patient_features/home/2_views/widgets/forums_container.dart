import 'package:flutter/material.dart';
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
      onTap: () {
        Navigator.pushNamed(context, '/forums');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              GinaAppTheme.lightTertiaryContainer.withOpacity(0.5),
              GinaAppTheme.lightTertiaryContainer,
            ],
          ),
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        height: height * 0.173,
        width: width / 2.99,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 17, 25),
              child: Image.asset(
                Images.forumImage,
              ),
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
