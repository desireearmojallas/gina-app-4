// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/widgets/upcoming_appointments_container_for_doctor.dart.dart';
import 'package:icons_plus/icons_plus.dart';

import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/upcoming_appointments_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

class SwiperBuilderWidget extends StatelessWidget {
  final List<AppointmentModel> upcomingAppointments;
  bool? isDoctor;
  SwiperBuilderWidget({
    super.key,
    required this.upcomingAppointments,
    this.isDoctor,
  });

  @override
  Widget build(BuildContext context) {
    List<List<Color>> gradientBGColors = [
      [const Color(0xffeea0b6), GinaAppTheme.lightTertiaryContainer],
      [const Color(0xffd3c5f7), const Color(0xffa491d3)],
      [const Color(0xffffdab5), const Color(0xfff08b60)],
    ];

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ginaTheme = Theme.of(context).textTheme;

    return upcomingAppointments.isEmpty
        ? Center(
            child: Column(
              children: [
                const Icon(
                  MingCute.unhappy_line,
                  color: GinaAppTheme.lightOutline,
                ),
                const Gap(10),
                Text(
                  'No upcoming appointments',
                  style: ginaTheme.bodyLarge?.copyWith(
                    color: GinaAppTheme.lightOutline,
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            height: height * 0.2,
            child: Swiper(
              physics: const BouncingScrollPhysics(),
              itemWidth: width * 0.9,
              itemHeight: height * 0.2,
              curve: Curves.fastEaseInToSlowEaseOut,
              duration: 100,
              scrollDirection: Axis.horizontal,
              axisDirection: AxisDirection.left,
              itemBuilder: (context, index) {
                final appointment = upcomingAppointments[index];
                final colors =
                    gradientBGColors[index % gradientBGColors.length];
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: colors,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      GinaAppTheme.defaultBoxShadow,
                    ],
                  ),
                  child: isDoctor == true
                      ? UpcomingAppointmentsForDoctorContainer(
                          patientName: appointment.patientName!,
                          appointmentId: appointment.appointmentUid!,
                          date: appointment.appointmentDate!,
                          time: appointment.appointmentTime!,
                          appointmentType: appointment.modeOfAppointment == 0
                              ? 'Online'
                              : 'Face-to-Face',
                          appointmentStatus: appointment.appointmentStatus,
                          appointment: appointment,
                        )
                      : UpcomingAppointmentsContainer(
                          appointment: appointment,
                          doctorName: appointment.doctorName!,
                          appointmentId: appointment.appointmentUid!,
                          date: appointment.appointmentDate!,
                          time: appointment.appointmentTime!,
                          appointmentType: appointment.modeOfAppointment == 0
                              ? 'Online'
                              : 'Face-to-Face',
                          appointmentStatus: appointment.appointmentStatus,
                        ),
                );
              },
              itemCount: upcomingAppointments.length,
              layout: SwiperLayout.STACK,
              pagination: SwiperPagination(
                alignment: Alignment.bottomCenter,
                builder: DotSwiperPaginationBuilder(
                  size: 8,
                  activeSize: 9,
                  color: Colors.white.withOpacity(0.3),
                  activeColor: GinaAppTheme.appbarColorLight,
                ),
              ),
            ),
          );
  }
}
