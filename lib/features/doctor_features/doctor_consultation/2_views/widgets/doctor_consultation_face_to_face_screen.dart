import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/widgets/dashed_line_painter_horizontal.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:intl/intl.dart';

class DoctorConsultationFaceToFaceScreen extends StatelessWidget {
  final AppointmentModel patientAppointment;
  final UserModel patientDetails;

  const DoctorConsultationFaceToFaceScreen({
    super.key,
    required this.patientAppointment,
    required this.patientDetails,
  });

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final dateTime = timestamp.toDate();
    return DateFormat('MMMM d, yyyy\nh:mm a').format(dateTime);
  }

  bool isCurrentTimeWithinRange(String appointmentTime) {
    final now = DateTime.now();
    final dateFormat = DateFormat('hh:mm a');

    final times = appointmentTime.split(' - ');
    final startTime = dateFormat.parse(times[0]);
    final endTime = dateFormat.parse(times[1]);

    final startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    final endDateTime =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

    return now.isAfter(startDateTime) && now.isBefore(endDateTime);
  }

  @override
  Widget build(BuildContext context) {
    final doctorConsultationBloc = context.read<DoctorConsultationBloc>();
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    final age = context.read<BookAppointmentBloc>().calculateAge(
          patientDetails.dateOfBirth,
        );

    final isWithinTimeRange =
        isCurrentTimeWithinRange(patientAppointment.appointmentTime!);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.splashPic),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // StreamBuilder<DocumentSnapshot>(
              //   stream: FirebaseFirestore.instance
              //       .collection('appointments')
              //       .doc(patientAppointment.appointmentUid)
              //       .snapshots(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const CustomLoadingIndicator();
              //     }
              //     if (!snapshot.hasData || !snapshot.data!.exists) {
              //       return const Text('Appointment not found');
              //     }

              //     final updatedAppointment = AppointmentModel.fromJson(
              //         snapshot.data!.data() as Map<String, dynamic>);

              //     return BlocListener<DoctorConsultationBloc,
              //         DoctorConsultationState>(
              //       listener: (context, state) {
              //         // Handle specific state changes if needed
              //       },
              //       child: BlocBuilder<DoctorConsultationBloc,
              //           DoctorConsultationState>(
              //         builder: (context, state) {
              //           final isSessionStarted = state
              //                   is DoctorConsultationF2FSessionStartedState ||
              //               updatedAppointment.f2fAppointmentStarted == true;
              //           final isSessionEnded = state
              //                   is DoctorConsultationF2FSessionEndedState ||
              //               updatedAppointment.f2fAppointmentConcluded == true;

              //           return appointmentDetailsCard(
              //             size,
              //             ginaTheme,
              //             age,
              //             isSessionStarted,
              //             isSessionEnded,
              //             updatedAppointment,
              //           );
              //         },
              //       ),
              //     );
              //   },
              // ),

              appointmentDetailsCard(
                size,
                ginaTheme,
                age,
                patientAppointment.appointmentUid!,
                patientDetails,
              ),
              const Spacer(),
              BlocBuilder<DoctorConsultationBloc, DoctorConsultationState>(
                builder: (context, state) {
                  final isSessionStarted =
                      state is DoctorConsultationF2FSessionStartedState ||
                          patientAppointment.f2fAppointmentStarted == true;
                  final isSessionEnded =
                      state is DoctorConsultationF2FSessionEndedState ||
                          patientAppointment.f2fAppointmentConcluded == true;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: isSessionEnded || !isWithinTimeRange
                            ? null
                            : () {
                                if (!isSessionStarted) {
                                  doctorConsultationBloc.add(
                                    BeginF2FSessionEvent(
                                      appointmentId:
                                          patientAppointment.appointmentUid!,
                                    ),
                                  );
                                  Fluttertoast.showToast(
                                    msg: 'Session started',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 12,
                                    backgroundColor: GinaAppTheme
                                        .appbarColorLight
                                        .withOpacity(0.85),
                                    textColor: Colors.grey[700],
                                    fontSize: 12.0,
                                  );
                                }
                              },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: size.width * 0.3,
                          height: size.height * 0.12,
                          decoration: BoxDecoration(
                            gradient: isSessionStarted ||
                                    isSessionEnded ||
                                    !isWithinTimeRange
                                ? null
                                : const LinearGradient(
                                    colors: [
                                      Color(0xFFFB6C85),
                                      Color(0xFFFF3D68)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                            color: isSessionStarted ||
                                    isSessionEnded ||
                                    !isWithinTimeRange
                                ? GinaAppTheme.lightSurfaceVariant
                                    .withOpacity(0.15)
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: isSessionStarted ||
                                    isSessionEnded ||
                                    !isWithinTimeRange
                                ? []
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.1),
                                      spreadRadius: -2,
                                      blurRadius: 10,
                                      offset: const Offset(0, -3),
                                    ),
                                  ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.play_arrow_rounded,
                                size: 50,
                                color: Colors.white.withOpacity(
                                    isSessionStarted ||
                                            isSessionEnded ||
                                            !isWithinTimeRange
                                        ? 0.2
                                        : 1.0),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Begin Session',
                                style: ginaTheme.bodySmall?.copyWith(
                                  color: Colors.white.withOpacity(
                                      isSessionStarted ||
                                              isSessionEnded ||
                                              !isWithinTimeRange
                                          ? 0.2
                                          : 1.0),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: isSessionEnded || !isWithinTimeRange
                            ? null
                            : () {
                                if (isSessionStarted) {
                                  doctorConsultationBloc.add(
                                    ConcludeF2FSessionEvent(
                                      appointmentId:
                                          patientAppointment.appointmentUid!,
                                    ),
                                  );
                                  Fluttertoast.showToast(
                                    msg: 'Successfully ended the session',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 12,
                                    backgroundColor: GinaAppTheme
                                        .appbarColorLight
                                        .withOpacity(0.85),
                                    textColor: Colors.grey[700],
                                    fontSize: 12.0,
                                  );
                                }
                              },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: size.width * 0.3,
                          height: size.height * 0.12,
                          decoration: BoxDecoration(
                            gradient: isSessionStarted &&
                                    !isSessionEnded &&
                                    isWithinTimeRange
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFFB6C85),
                                      Color(0xFFFF3D68)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: !isSessionStarted ||
                                    isSessionEnded ||
                                    !isWithinTimeRange
                                ? GinaAppTheme.lightSurfaceVariant
                                    .withOpacity(0.15)
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: !isSessionStarted ||
                                    isSessionEnded ||
                                    !isWithinTimeRange
                                ? []
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.1),
                                      spreadRadius: -2,
                                      blurRadius: 10,
                                      offset: const Offset(0, -3),
                                    ),
                                  ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.stop_rounded,
                                size: 50,
                                color: Colors.white.withOpacity(
                                    !isSessionStarted ||
                                            isSessionEnded ||
                                            !isWithinTimeRange
                                        ? 0.2
                                        : 1.0),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Conclude Session',
                                style: ginaTheme.bodySmall?.copyWith(
                                  color: Colors.white.withOpacity(
                                      !isSessionStarted ||
                                              isSessionEnded ||
                                              !isWithinTimeRange
                                          ? 0.2
                                          : 1.0),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
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
                                color:
                                    GinaAppTheme.lightOutline.withOpacity(0.5),
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
                                      ? GinaAppTheme.lightOutline
                                          .withOpacity(0.8)
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
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
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
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
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
}
