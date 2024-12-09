import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/doctor_details_state_widgets/detailed_view_icon.dart';

Widget buildAvailabilityRow({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Row(
      children: [
        DetailedViewIcon(icon: Icon(icon, color: GinaAppTheme.lightOutline)),
        const Gap(20),
        SizedBox(
          width: 100,
          child:
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        const Gap(20),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
