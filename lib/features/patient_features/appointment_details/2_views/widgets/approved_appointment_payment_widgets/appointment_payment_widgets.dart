import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/approved_appointment_payment_widgets/upload_payment_receipt_widgets/upload_payment_receipt_screen.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/2_views/screens/patient_payment_screen.dart';

class AppointmentPaymentWidgets extends StatelessWidget {
  final String appointmentId;
  final String doctorName;
  final String patientName;
  final String consultationType;
  final double amount;
  final String appointmentDate;

  const AppointmentPaymentWidgets({
    super.key,
    required this.appointmentId,
    required this.doctorName,
    required this.patientName,
    required this.consultationType,
    required this.amount,
    required this.appointmentDate,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PatientPaymentScreenProvider(
                  appointmentId: appointmentId,
                  doctorName: doctorName,
                  patientName: patientName,
                  modeOfAppointment: consultationType,
                  amount: amount,
                  appointmentDate: appointmentDate,
                );
              }));
            },
            child: Container(
              height: size.height * 0.065,
              width: size.width * 0.445,
              decoration: BoxDecoration(
                color: GinaAppTheme.appbarColorLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      height: size.height * 0.065,
                      width: size.width * 0.14,
                      decoration: BoxDecoration(
                        color: GinaAppTheme.lightBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.credit_card,
                        color: GinaAppTheme.lightInverseSurface,
                      ),
                    ),
                    const Gap(15),
                    Text(
                      'View\nBank Details',
                      style: ginaTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const UploadPaymentReceiptScreen();
              }));
            },
            child: Container(
              height: size.height * 0.065,
              width: size.width * 0.445,
              decoration: BoxDecoration(
                color: GinaAppTheme.appbarColorLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      height: size.height * 0.065,
                      width: size.width * 0.14,
                      decoration: BoxDecoration(
                        color: GinaAppTheme.lightBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.upload_rounded,
                        color: GinaAppTheme.lightInverseSurface,
                      ),
                    ),
                    const Gap(15),
                    Text(
                      'Upload\nPayment Receipt',
                      style: ginaTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
