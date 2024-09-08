// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/floating_menu_bar/2_views/floating_menu_bar.dart';

class GinaPatientAppBar extends StatelessWidget implements PreferredSizeWidget {
  GinaPatientAppBar({
    required this.title,
    this.leading,
    super.key,
  });

  Widget? leading;
  final String title;

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        leading: leading,
        scrolledUnderElevation: 0,
        title: Text(
          title,
          style: ginaTheme.textTheme.headlineMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions:  [
          FloatingMenuWidget(),
          const Gap(10),
        ],
        notificationPredicate: (notification) => false,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55.0);
}
