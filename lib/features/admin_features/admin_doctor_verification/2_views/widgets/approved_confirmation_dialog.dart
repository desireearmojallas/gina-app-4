import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Future<dynamic> approvedConfirmationDialog(
  BuildContext context,
) {
  final size = MediaQuery.of(context).size;
  final ginaTheme = Theme.of(context).textTheme;
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      content: SizedBox(
        width: size.width * 0.3,
        height: size.height * 0.3,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 80,
              ),
              const Gap(30),
              Text(
                'Doctor Approved Successfully!',
                textAlign: TextAlign.center,
                style: ginaTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(40),
              SizedBox(
                width: size.width * 0.2,
                height: size.height * 0.04,
                child: FilledButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
