import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class ApproveDeclineButtons extends StatelessWidget {
  final Color buttonColor;
  final Icon buttonIcon;
  final String buttonLabel;
  const ApproveDeclineButtons({
    super.key,
    required this.buttonColor,
    required this.buttonIcon,
    required this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        side: MaterialStateProperty.all(
          BorderSide(
            color: buttonColor,
            width: 1.5,
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed) ||
                states.contains(MaterialState.hovered)) {
              return buttonColor;
            }
            return Colors.transparent;
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed) ||
                states.contains(MaterialState.hovered)) {
              return GinaAppTheme.appbarColorLight;
            }
            return GinaAppTheme.lightOnPrimaryColor;
          },
        ),
      ),
      onPressed: () {},
      icon: buttonIcon,
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          buttonLabel,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
