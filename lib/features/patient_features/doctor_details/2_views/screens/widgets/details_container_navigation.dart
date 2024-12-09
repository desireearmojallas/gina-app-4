// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:gina_app_4/core/theme/theme_service.dart';

class DetailsContainerNavigation extends StatelessWidget {
  final IconData icon;
  final String containerLabel;
  final VoidCallback onTap;
  const DetailsContainerNavigation({
    super.key,
    required this.icon,
    required this.containerLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.height * 0.11,
        width: size.width * 0.44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              // Icons.monetization_on,
              icon,
              size: 30,
              color: GinaAppTheme.lightSecondary,
            ),
            const Gap(10),
            Text(
              // 'Consultation Fee\nDetails',
              containerLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
