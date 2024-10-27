import 'package:flutter/material.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

Future<dynamic> submittingMedicalLicenseDialog(
    BuildContext context, String content) {
  return showDialog(
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(12.0),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: GinaAppTheme.appbarColorLight,
        shadowColor: GinaAppTheme.appbarColorLight,
        surfaceTintColor: GinaAppTheme.appbarColorLight,
        icon: const CustomLoadingIndicator(),
        content: Text(
          content,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    ),
  );
}
