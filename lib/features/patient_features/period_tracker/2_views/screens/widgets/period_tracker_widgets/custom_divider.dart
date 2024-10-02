import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(10),
        Divider(
          color: Colors.grey[300] ?? Colors.grey,
          thickness: 1,
        ),
        const Gap(10),
      ],
    );
  }
}
