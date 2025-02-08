import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/widgets/dashed_line_painter_horizontal.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp? timestamp) {
  if (timestamp == null) return '';
  final dateTime = timestamp.toDate();
  return DateFormat('MMMM d, yyyy\nh:mm a').format(dateTime);
}

Padding appointmentDetailsCard(
  Size size,
  TextTheme ginaTheme,
  int age,
  String appointmentUid,
  UserModel patientDetails,
) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
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
                            left: 30,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.9),
                                  width: 2.0,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 17,
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
                              radius: 17,
                              backgroundColor: Colors.transparent,
                              foregroundImage:
                                  AssetImage(Images.doctorProfileIcon1),
                            ),
                          ),
                        ],
                      ),
                      const Gap(40),
                      Text(
                        'Ongoing Appointment Details',
                        style: ginaTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('appointments')
                .doc(appointmentUid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CustomLoadingIndicator();
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Text('Appointment not found');
              }

              final updatedAppointment = AppointmentModel.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>);

              final isSessionStarted =
                  updatedAppointment.f2fAppointmentStarted == true;
              final isSessionEnded =
                  updatedAppointment.f2fAppointmentConcluded == true;

              return IntrinsicHeight(
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
                                  updatedAppointment.appointmentUid!,
                                  style: ginaTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                                    'Patient Name',
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
                                    updatedAppointment.patientName!,
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
                                    'Address',
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
                                    patientDetails.address,
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
                                    'Age',
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
                                    '$age years old',
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
                                    'Birthdate',
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
                                    patientDetails.dateOfBirth,
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
                                    'Date & time',
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
                                    '${updatedAppointment.appointmentDate}\n${updatedAppointment.appointmentTime}',
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
                                    'Mode of appointment',
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
                                    updatedAppointment.modeOfAppointment == 1
                                        ? 'Face-to-face Consultation'
                                        : 'Online Consultation',
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
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            bottom: 20.0,
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
                          isSessionEnded
                              ? 'Session ended'
                              : isSessionStarted
                                  ? 'Session started'
                                  : 'Session not started',
                          style: ginaTheme.bodySmall?.copyWith(
                            color: isSessionStarted
                                ? GinaAppTheme.lightTertiaryContainer
                                : isSessionEnded
                                    ? GinaAppTheme.lightOutline.withOpacity(0.8)
                                    : GinaAppTheme.lightOutline
                                        .withOpacity(0.8),
                            fontWeight: isSessionStarted
                                ? FontWeight.bold
                                : FontWeight.w600,
                            fontStyle: isSessionStarted
                                ? FontStyle.italic
                                : isSessionEnded
                                    ? FontStyle.normal
                                    : FontStyle.normal,
                          ),
                        ),
                        isSessionStarted || isSessionEnded
                            ? Column(
                                children: [
                                  if (isSessionStarted || isSessionEnded)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: SizedBox(
                                              width: size.width * 0.25,
                                              child: Text(
                                                'Time started',
                                                style: ginaTheme.bodySmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: GinaAppTheme
                                                      .lightOutline
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0),
                                            child: SizedBox(
                                              width: size.width * 0.5,
                                              child: Text(
                                                formatTimestamp(updatedAppointment
                                                    .f2fAppointmentStartedTime),
                                                style: ginaTheme.bodySmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (isSessionEnded)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: SizedBox(
                                              width: size.width * 0.25,
                                              child: Text(
                                                'Time ended',
                                                style: ginaTheme.bodySmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: GinaAppTheme
                                                      .lightOutline
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0),
                                            child: SizedBox(
                                              width: size.width * 0.5,
                                              child: Text(
                                                formatTimestamp(updatedAppointment
                                                    .f2fAppointmentConcludedTime),
                                                style: ginaTheme.bodySmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}
