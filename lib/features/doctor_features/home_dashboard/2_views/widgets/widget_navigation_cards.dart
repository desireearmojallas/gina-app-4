import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class WidgetNavigationCards extends StatelessWidget {
  final String widgetText;
  final IconData icon;
  final VoidCallback onPressed;
  const WidgetNavigationCards({
    super.key,
    required this.widgetText,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadowColor: Colors.black.withOpacity(0.1),
        elevation: 5,
      ),
      child: Container(
        height: size.height * 0.06,
        width: size.width / 2.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        child: Row(
          children: [
            const Gap(20),
            Icon(
              icon,
              color: GinaAppTheme.lightTertiaryContainer,
              size: 25,
            ),
            const Gap(20),
            Text(
              widgetText,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: GinaAppTheme.lightOnPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
