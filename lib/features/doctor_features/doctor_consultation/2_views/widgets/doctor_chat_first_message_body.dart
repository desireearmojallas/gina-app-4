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
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
            child: Text(
              'Feel free to start the conversation by sending a message.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: GinaAppTheme.appbarColorLight,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
