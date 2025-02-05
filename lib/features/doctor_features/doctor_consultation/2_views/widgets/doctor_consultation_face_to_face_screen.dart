import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';

class DoctorConsultationFaceToFaceScreen extends StatelessWidget {
  final AppointmentModel patientAppointment;
  final UserModel patientDetails;
  const DoctorConsultationFaceToFaceScreen({
    super.key,
    required this.patientAppointment,
    required this.patientDetails,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    final age = context.read<BookAppointmentBloc>().calculateAge(
          patientDetails.dateOfBirth,
        );
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
              appointmentDetailsCard(size, ginaTheme, age),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      // Add your functionality here
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: size.width * 0.3,
                      height: size.height * 0.12,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFB6C85),
                            Color(0xFFFF3D68)
                          ], // Smooth gradient
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 5), // Soft drop shadow
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            spreadRadius: -2,
                            blurRadius: 10,
                            offset: const Offset(
                                0, -3), // Subtle top highlight for depth
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.play_arrow_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Begin Session',
                            style: ginaTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.3,
                    height: size.height * 0.12,
                    decoration: BoxDecoration(
                      color: GinaAppTheme.lightSurfaceVariant
                          .withOpacity(0.15), // More faded background
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.stop_rounded,
                            size: 50,
                            color: Colors.white
                                .withOpacity(0.2), // More faded icon
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Conclude Session',
                            style: ginaTheme.bodySmall?.copyWith(
                              color: Colors.white
                                  .withOpacity(0.2), // More faded text
                              fontWeight: FontWeight.w500, // Slightly less bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Padding appointmentDetailsCard(Size size, TextTheme ginaTheme, int age) {
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
            IntrinsicHeight(
              child: Container(
                // height: size.height * 0.2,
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
                                patientAppointment.appointmentUid!,
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
                                  patientAppointment.patientName!,
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
                                  '${patientAppointment.appointmentDate}\n${patientAppointment.appointmentTime}',
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
