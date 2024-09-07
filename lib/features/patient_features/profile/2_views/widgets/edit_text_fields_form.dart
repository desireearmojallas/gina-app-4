import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class EditProfileTextField extends StatelessWidget {
  final bool readOnly;
  final TextEditingController textController;
  final ThemeData ginaTheme;
  final String labelText;

  const EditProfileTextField({
    super.key,
    required this.readOnly,
    required this.textController,
    required this.ginaTheme,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      controller: textController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        labelText: labelText,
        labelStyle: ginaTheme.textTheme.bodyLarge?.copyWith(
          color: GinaAppTheme.lightOutline,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        enabled: readOnly ? false : true,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: GinaAppTheme.lightOutline,
            width: 1,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: GinaAppTheme.lightPrimaryContainer,
            width: 1,
          ),
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: GinaAppTheme.searchBarColor,
            width: 1,
          ),
        ),
      ),
      autocorrect: false,
    );
  }
}
