import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/floating_doctor_menu_bar/floating_doctor_menu_bar.dart';

// ignore: must_be_immutable
class GinaDoctorAppBar extends StatelessWidget implements PreferredSizeWidget {
  GinaDoctorAppBar({required this.title, this.leading, super.key});

  final String title;
  Widget? leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      notificationPredicate: (notification) => false,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
      ),
      actions: [
        FloatingDoctorMenuWidget(),
        const Gap(10),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55.0);
}
