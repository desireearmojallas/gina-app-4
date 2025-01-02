import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class DoctorChatFirstMessageBody extends StatelessWidget {
  const DoctorChatFirstMessageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              '',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: GinaAppTheme.lightOutline,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
