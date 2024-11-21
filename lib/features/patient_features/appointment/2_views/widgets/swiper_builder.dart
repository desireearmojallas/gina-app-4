import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:intl/intl.dart'; // Add intl package to parse and format dates
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/upcoming_appointments_container.dart';

class SwiperBuilderWidget extends StatelessWidget {
  const SwiperBuilderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded appointments
    List<UpcomingAppointmentsContainer> hardCodedAppointments = [
      const UpcomingAppointmentsContainer(
        doctorName: 'Maria Santos',
        specialty: 'Obstetrician & Gynecologist',
        date: 'Sep 15, 2024',
        time: '9:30 AM',
        appointmentType: 'Online',
        appointmentStatus: 1,
      ),
      const UpcomingAppointmentsContainer(
        doctorName: 'John Doe',
        specialty: 'Cardiologist',
        date: 'Sep 20, 2024',
        time: '11:00 AM',
        appointmentType: 'In-Person',
        appointmentStatus: 1,
      ),
      const UpcomingAppointmentsContainer(
        doctorName: 'Emily Brown',
        specialty: 'Dermatologist',
        date: 'Sep 25, 2024',
        time: '2:30 PM',
        appointmentType: 'Online',
        appointmentStatus: 1,
      ),
    ];

    // Convert string dates to DateTime and sort appointments
    hardCodedAppointments.sort((a, b) {
      final dateA = DateFormat('MMM dd, yyyy').parse(a.date);
      final dateB = DateFormat('MMM dd, yyyy').parse(b.date);
      return dateA.compareTo(dateB); // Sort from nearest to latest date
    });

    List<List<Color>> gradientBGColors = [
      [const Color(0xffeea0b6), GinaAppTheme.lightTertiaryContainer],
      [const Color(0xffd3c5f7), const Color(0xffa491d3)],
      [const Color(0xffffdab5), const Color(0xfff08b60)],
    ];

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
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
            final colors = gradientBGColors[index % gradientBGColors.length];
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
              child: hardCodedAppointments[index],
            );
          },
          itemCount: hardCodedAppointments.length,
          layout: SwiperLayout.STACK,
          pagination: SwiperPagination(
            alignment: Alignment.bottomCenter,
            builder: DotSwiperPaginationBuilder(
              size: 8,
              activeSize: 9,
              color: Colors.grey[300],
              activeColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
