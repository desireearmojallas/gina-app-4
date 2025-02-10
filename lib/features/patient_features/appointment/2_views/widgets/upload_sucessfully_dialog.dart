import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/bloc/appointment_details_bloc.dart';

Future<dynamic> showUploadSuccessDialog(
    BuildContext context, TextTheme ginaTheme, Size size) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      icon: const Icon(
        Icons.check_circle_rounded,
        color: Colors.green,
        size: 80,
      ),
      content: SizedBox(
        height: 100,
        width: 200,
        child: Column(
          children: [
            Text(
              'Files Uploaded',
              textAlign: TextAlign.center,
              style: ginaTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(20),
            SizedBox(
              height: 40,
              width: size.width * 0.5,
              child: FilledButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  isRescheduleMode = false;
                  Navigator.pop(context);
                },
                child: Text(
                  'Okay',
                  style: ginaTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
