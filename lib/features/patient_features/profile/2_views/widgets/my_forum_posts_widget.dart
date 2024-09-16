import 'package:flutter/material.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class MyForumPostsWidget extends StatelessWidget {
  const MyForumPostsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final ginaTheme = Theme.of(context);
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: width * 0.45,
        height: height * 0.15,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.patientForumPost),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'My Forum\nPosts',
              style: ginaTheme.textTheme.headlineSmall?.copyWith(
                color: GinaAppTheme.lightOnTertiary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
