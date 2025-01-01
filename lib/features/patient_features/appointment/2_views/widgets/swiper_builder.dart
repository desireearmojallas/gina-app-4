import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/widgets/doctor_upcoming_appointments_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/upcoming_appointments_container.dart';
import 'package:icons_plus/icons_plus.dart';

class SwiperBuilderWidget extends StatelessWidget {
  final List<AppointmentModel> upcomingAppointments;
  final bool? isDoctor;
  const SwiperBuilderWidget({
    super.key,
    required this.upcomingAppointments,
    this.isDoctor,
  });

  @override
  Widget build(BuildContext context) {
    // List<List<Color>> gradientBGColors = [
    //   [const Color(0xffeea0b6), GinaAppTheme.lightTertiaryContainer],
    //   [const Color(0xffd3c5f7), const Color(0xffa491d3)],
    //   [const Color(0xffffdab5), const Color(0xfff08b60)],
    // ];

    List<List<Color>> gradientBGColors = [
      [const Color(0xffeea0b6), GinaAppTheme.lightTertiaryContainer],
      [const Color(0xffd3c5f7), const Color(0xffa491d3)],
      [const Color(0xffffdab5), const Color(0xfff08b60)],
      [const Color(0xffb2dfdb), const Color(0xff80cbc4)],
      [const Color(0xffc8e6c9), const Color(0xffa5d6a7)],
      [const Color(0xffd1c4e9), const Color(0xffb39ddb)],
      [const Color(0xffffccbc), const Color(0xffffab91)],
      [const Color(0xffbbdefb), const Color(0xff90caf9)],
      [const Color(0xfffff9c4), const Color(0xfffff59d)],
      [const Color(0xfff8bbd0), const Color(0xfff48fb1)],
      [const Color(0xffd7ccc8), const Color(0xffbcaaa4)],
      [const Color(0xffcfd8dc), const Color(0xffb0bec5)],
      [const Color(0xffe1bee7), const Color(0xffce93d8)],
      [const Color(0xfff0f4c3), const Color(0xffe6ee9c)],
      [const Color(0xffc8e6c9), const Color(0xffa5d6a7)],
      [const Color(0xffb3e5fc), const Color(0xff81d4fa)],
      [const Color(0xffd1c4e9), const Color(0xffb39ddb)],
      [const Color(0xfff8bbd0), const Color(0xfff48fb1)],
      [const Color(0xffc5cae9), const Color(0xff9fa8da)],
      [const Color(0xffffe0b2), const Color(0xffffcc80)],
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
                      ? DoctorUpcomingAppointmentsContainer(
                          appointment: appointment,
                          patientName: appointment.patientName!,
                          appointmentId: appointment.appointmentUid!,
                          date: appointment.appointmentDate!,
                          time: appointment.appointmentTime!,
                          appointmentType: appointment.modeOfAppointment == 0
                              ? 'Online'
                              : 'Face-to-Face',
                          appointmentStatus: appointment.appointmentStatus,
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
