import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

Widget styledFormField(
  BuildContext context,
  String hintText,
  TextEditingController controller,
  bool obscureText, {
  Function()? togglePasswordVisibility,
  IconData? icon,
  Function()? onTap,
  bool readOnly = false,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 1.28,
    child: Stack(
      alignment: Alignment.centerRight,
      children: [
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $hintText';
            }
            return null;
          },
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: readOnly ? hintText : null,
            labelText: !readOnly ? hintText : null,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontFamily: 'SF UI Display',
              fontWeight: FontWeight.w500,
              color: GinaAppTheme.lightOutlineVariant,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            suffixIcon: icon != null
                ? IconButton(
                    onPressed: onTap,
                    icon: Icon(icon),
                  )
                : null,
          ),
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'SF UI Display',
            fontWeight: FontWeight.w500,
            color: GinaAppTheme.lightOnPrimaryColor,
          ),
          readOnly: readOnly,
          onTap: onTap,
        ),
        if (togglePasswordVisibility != null)
          IconButton(
            onPressed: togglePasswordVisibility,
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
          ),
      ],
    ),
  );
}
