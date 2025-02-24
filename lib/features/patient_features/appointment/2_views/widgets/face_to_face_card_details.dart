import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/widgets/dashed_line_painter_horizontal.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:intl/intl.dart';

class FaceToFaceCardDetails extends StatelessWidget {
  final AppointmentModel appointment;
  const FaceToFaceCardDetails({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    String formatTimestamp(Timestamp? timestamp) {
      if (timestamp == null) return '';
      final dateTime = timestamp.toDate();
      return DateFormat('MMMM d, yyyy | h:mm a').format(dateTime);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 10.0),
      child: Container(
        width: size.width * 1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: size.height * 0.065,
              width: size.width * 1,
              decoration: const BoxDecoration(
                color: Color(0xFFFB6C85),
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Center(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 28,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.9),
                                    width: 2.0,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.transparent,
                                  foregroundImage:
                                      AssetImage(Images.patientProfileIcon),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.9),
                                  width: 2.0,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.transparent,
                                foregroundImage:
                                    AssetImage(Images.doctorProfileIcon1),
                              ),
                            ),
                          ],
                        ),
                        const Gap(40),
                        SizedBox(
                          width: size.width * 0.6,
                          child: Text(
                            'F2F Appointment with Dr. ${appointment.doctorName}',
                            style: ginaTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            IntrinsicHeight(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: SizedBox(
                              width: size.width * 0.25,
                              child: Text(
                                'Appointment ID',
                                style: ginaTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: GinaAppTheme.lightOutline
                                      .withOpacity(0.8),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: SizedBox(
                              width: size.width * 0.5,
                              child: Text(
                                appointment.appointmentUid!,
                                style: ginaTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                          bottom: 20.0,
                          right: 5.0,
                        ),
                        child: CustomPaint(
                          size: const Size(double.infinity, 1),
                          painter: DashedLinePainterHorizontal(
                            dashWidth: 5.0,
                            dashSpace: 3.0,
                            color: GinaAppTheme.lightOutline.withOpacity(0.5),
                          ),
                        ),
                      ),
                      Text(
                        'Session ended',
                        style: ginaTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: GinaAppTheme.lightTertiaryContainer,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: SizedBox(
                                    width: size.width * 0.25,
                                    child: Text(
                                      'Time started',
                                      style: ginaTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: GinaAppTheme.lightOutline
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 25.0),
                                  child: SizedBox(
                                    width: size.width * 0.5,
                                    child: Text(
                                      formatTimestamp(appointment
                                          .f2fAppointmentStartedTime),
                                      style: ginaTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: SizedBox(
                                    width: size.width * 0.25,
                                    child: Text(
                                      'Time ended',
                                      style: ginaTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: GinaAppTheme.lightOutline
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 25.0),
                                  child: SizedBox(
                                    width: size.width * 0.5,
                                    child: Text(
                                      formatTimestamp(appointment
                                          .f2fAppointmentConcludedTime),
                                      style: ginaTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
