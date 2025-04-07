import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/bloc/appointment_details_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

Future<dynamic> showCancelModalDialog(
  BuildContext context, {
  required String appointmentId,
}) {
  final appointmentDetailBloc = context.read<AppointmentDetailsBloc>();
  final appointmentBloc = context.read<AppointmentBloc>();

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: GinaAppTheme.appbarColorLight,
      shadowColor: GinaAppTheme.appbarColorLight,
      surfaceTintColor: GinaAppTheme.appbarColorLight,
      icon: const Icon(
        Icons.question_mark_rounded,
        color: GinaAppTheme.lightTertiaryContainer,
        size: 60,
      ),
      content: IntrinsicHeight(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('appointments')
              .doc(appointmentId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CustomLoadingIndicator());
            }

            final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
            final paymentStatus = data['paymentStatus'] as String? ?? '';
            final refundStatus = data['refundStatus'] as String?;
            final amount = data['amount'] as double? ?? 0.0;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to cancel\n your appointment?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                if (paymentStatus.toLowerCase() == 'paid' && amount > 0) ...[
                  const Gap(10),
                  Text(
                    'A refund will be processed for your payment of ₱${NumberFormat('#,##0.00').format(amount)}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  if (refundStatus != null) ...[
                    const Gap(10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getRefundStatusColor(refundStatus)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Refund Status: ${refundStatus.toUpperCase()}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getRefundStatusColor(refundStatus),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ],
                const Gap(20),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: OutlinedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      if (isFromAppointmentTabs) {
                        isFromAppointmentTabs = false;
                        appointmentBloc.add(
                          CancelAppointmentInAppointmentTabsEvent(
                            appointmentUid: appointmentId,
                          ),
                        );
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(
                          context,
                          '/bottomNavigation',
                          arguments: {'initialIndex': 2},
                        );
                      } else {
                        appointmentDetailBloc.add(
                          CancelAppointmentEvent(appointmentUid: appointmentId),
                        );
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(
                          context,
                          '/bottomNavigation',
                          arguments: {'initialIndex': 2},
                        );
                      }
                    },
                    child: Text(
                      'Yes',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
                const Gap(10),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: OutlinedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'No',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}

Color _getRefundStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.orange;
    case 'succeeded':
      return Colors.green;
    case 'failed':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
