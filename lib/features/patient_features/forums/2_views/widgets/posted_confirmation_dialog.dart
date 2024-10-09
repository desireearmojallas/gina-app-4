import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

Future<dynamic> postedConfirmationDialog(BuildContext context, String content) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: GinaAppTheme.appbarColorLight,
      shadowColor: GinaAppTheme.appbarColorLight,
      surfaceTintColor: GinaAppTheme.appbarColorLight,
      icon: const Icon(
        Icons.check_circle_rounded,
        color: Colors.green,
        size: 80,
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    ),
  );
}
