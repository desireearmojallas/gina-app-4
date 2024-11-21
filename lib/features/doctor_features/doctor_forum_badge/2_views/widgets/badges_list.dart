import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class BadgesList extends StatelessWidget {
  final String badgeName;
  final String badgeDescription;
  final Color badgeColor;

  const BadgesList({
    super.key,
    required this.badgeName,
    required this.badgeDescription,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: GinaAppTheme.lightOnTertiary,
      ),
      height: size.height * 0.11,
      width: size.width * 0.9, // Adjust the width as needed
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: badgeColor.withOpacity(0.25),
              child: Icon(
                Icons.star_rounded,
                size: 40,
                color: badgeColor,
              ),
            ),
            const Gap(15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    badgeName,
                    textAlign: TextAlign.left,
                    style: ginaTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                  const Gap(5),
                  Text(
                    badgeDescription,
                    style: ginaTheme.labelSmall!.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
