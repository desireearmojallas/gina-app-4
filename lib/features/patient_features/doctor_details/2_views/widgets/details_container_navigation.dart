// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:gina_app_4/core/theme/theme_service.dart';

class DetailsContainerNavigation extends StatelessWidget {
  final IconData icon;
  final String containerLabel;
  final VoidCallback onTap;
  final bool? isNull;
  const DetailsContainerNavigation({
    super.key,
    required this.icon,
    required this.containerLabel,
    required this.onTap,
    this.isNull = false,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('isNull: $isNull');
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: isNull == true ? null : onTap,
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.44,
        decoration: BoxDecoration(
          color: isNull == true ? Colors.white.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: isNull == true
                  ? GinaAppTheme.lightSurfaceVariant.withOpacity(0.5)
                  : GinaAppTheme.lightSecondary,
            ),
            const Gap(10),
            Text(
              containerLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isNull == true
                    ? GinaAppTheme.lightSurfaceVariant
                    : GinaAppTheme.lightOnPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
