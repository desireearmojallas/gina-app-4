import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

Future<dynamic> declinedVerificationInformationDialog(
  BuildContext context,
  String declinedReason,
) {
  return showDialog(
    context: context,
    builder: (context) {
      final size = MediaQuery.of(context).size;
      final ginaTheme = Theme.of(context).textTheme;

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.2),
        surfaceTintColor: Colors.white,
        content: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                left: size.width * 0.29,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close_rounded,
                    color: GinaAppTheme.lightOutline,
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.3,
                height: size.height * 0.4,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Gap(30),
                      const Icon(
                        Icons.cancel_rounded,
                        color: GinaAppTheme.declinedTextColor,
                        size: 80,
                      ),
                      const Gap(30),
                      Text('Doctor Verification Declined',
                          textAlign: TextAlign.center,
                          style: ginaTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          )),
                      const Gap(15),
                      Text(
                        'Reason for declining the verification:',
                        style: ginaTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: GinaAppTheme.lightOutline,
                        ),
                      ),
                      const Gap(30),
                      SizedBox(
                        width: size.width * 0.2,
                        child: TextFormField(
                          initialValue: declinedReason,
                          readOnly: true,
                          maxLines: null,
                          style: ginaTheme.labelMedium?.copyWith(
                            color: GinaAppTheme.lightOnBackground,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const Gap(40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
