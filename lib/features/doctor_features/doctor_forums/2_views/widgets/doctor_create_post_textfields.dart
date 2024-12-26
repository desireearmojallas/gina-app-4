import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class DoctorCreatePostTextFields extends StatelessWidget {
  final TextEditingController textFieldController;
  final String contentTitle;
  final int maxLines;
  final bool isTitle;
  const DoctorCreatePostTextFields({
    super.key,
    required this.textFieldController,
    required this.contentTitle,
    required this.maxLines,
    this.isTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          GinaAppTheme.defaultBoxShadow,
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contentTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: GinaAppTheme.lightOutline,
                  ),
            ),
            TextField(
              controller: textFieldController,
              maxLines: maxLines,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: isTitle ? 18.0 : 12.0,
                    fontWeight: isTitle ? FontWeight.bold : FontWeight.w500,
                  ),
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
