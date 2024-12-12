import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/upcoming_appointments_container.dart';
import 'package:icons_plus/icons_plus.dart';

class SwiperBuilderWidget extends StatelessWidget {
  final List<AppointmentModel> upcomingAppointments;
  const SwiperBuilderWidget({super.key, required this.upcomingAppointments});

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
        : InkWell(
            child: SizedBox(
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
                    child: UpcomingAppointmentsContainer(
                      doctorName: upcomingAppointments[index].doctorName!,
                      // specialty: upcomingAppointments[index].specialty,
                      specialty: 'Dummy data',
                      date: upcomingAppointments[index].appointmentDate!,
                      time: upcomingAppointments[index].appointmentTime!,
                      appointmentType:
                          upcomingAppointments[index].modeOfAppointment == 0
                              ? 'Online'
                              : 'Face-to-Face',
                      appointmentStatus:
                          upcomingAppointments[index].appointmentStatus,
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
            ),
          );
  }
}
