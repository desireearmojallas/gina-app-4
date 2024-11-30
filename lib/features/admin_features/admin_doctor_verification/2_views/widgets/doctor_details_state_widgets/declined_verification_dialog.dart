import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/bloc/admin_dashboard_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/bloc/admin_doctor_verification_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<dynamic> declinedVerificationDialog(
  BuildContext context,
  String doctorId,
  String doctorVerificationId,
  TextEditingController declineReasonController,
) {
  // TextEditingController declineReasonController = TextEditingController();
  final adminDoctorVerificationBloc =
      context.read<AdminDoctorVerificationBloc>();
  final adminDashboardBloc = context.read<AdminDashboardBloc>();

  final ginaTheme = Theme.of(context).textTheme;
  final size = MediaQuery.of(context).size;

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
        height: size.height * 0.35,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.cancel_rounded,
                  color: GinaAppTheme.lightError,
                  size: 80,
                ),
                const Gap(30),
                Text(
                  'Doctor Verification Declined',
                  textAlign: TextAlign.center,
                  style: ginaTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(15),
                Text(
                  'Please provide a reason for declining the verification',
                  textAlign: TextAlign.center,
                  style: ginaTheme.labelMedium?.copyWith(
                    color: GinaAppTheme.lightOutline,
                  ),
                ),
                const Gap(25),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    controller: declineReasonController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Type here...',
                      hintStyle: ginaTheme.labelMedium?.copyWith(
                        color: GinaAppTheme.lightOutline,
                      ),
                    ),
                    style: ginaTheme.labelMedium,
                  ),
                ),
                const Gap(40),
                SizedBox(
                  width: size.width * 0.2,
                  height: size.height * 0.045,
                  child: FilledButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (isFromAdminDashboard) {
                        adminDashboardBloc.add(AdminDashboardDeclineEvent(
                          doctorId: doctorId,
                          doctorVerificationId: doctorVerificationId,
                          declinedReason: declineReasonController.text,
                        ));
                      } else {
                        adminDoctorVerificationBloc
                            .add(AdminDoctorVerificationDeclineEvent(
                          doctorId: doctorId,
                          doctorVerificationId: doctorVerificationId,
                          declinedReason: declineReasonController.text,
                        ));
                      }
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Ok',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
