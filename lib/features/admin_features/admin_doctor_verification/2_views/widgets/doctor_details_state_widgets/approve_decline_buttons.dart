import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/bloc/admin_dashboard_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/bloc/admin_doctor_verification_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/doctor_details_state_widgets/declined_verification_dialog.dart';

class ApproveDeclineButtons extends StatelessWidget {
  final String doctorId;
  final String doctorVerificationId;
  final Color buttonColor;
  final Icon buttonIcon;
  final String buttonLabel;
  final bool? isApprove;
  TextEditingController? declineReasonController;
  ApproveDeclineButtons({
    super.key,
    required this.buttonColor,
    required this.buttonIcon,
    required this.buttonLabel,
    required this.doctorId,
    required this.doctorVerificationId,
    this.isApprove = true,
    this.declineReasonController,
  });

  @override
  Widget build(BuildContext context) {
    final adminDoctorVerificationBloc =
        context.read<AdminDoctorVerificationBloc>();
    final adminDashboardBloc = context.read<AdminDashboardBloc>();

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
      onPressed: () {
        if (isApprove == true) {
          if (isFromAdminDashboard) {
            adminDashboardBloc.add(AdminDashboardApproveEvent(
              doctorId: doctorId,
              doctorVerificationId: doctorVerificationId,
            ));
          } else {
            adminDoctorVerificationBloc.add(AdminDoctorVerificationApproveEvent(
              doctorId: doctorId,
              doctorVerificationId: doctorVerificationId,
            ));
          }
        } else {
          declinedVerificationDialog(
            context,
            doctorId,
            doctorVerificationId,
            declineReasonController!,
          );
        }
      },
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
