import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/widgets/chat_econsult_card_list.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/swiper_builder.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/0_model/chat_message_model.dart';

class DoctorEConsultScreenLoaded extends StatelessWidget {
  final List<AppointmentModel> upcomingAppointments;
  final List<ChatMessageModel> chatRooms;
  const DoctorEConsultScreenLoaded({
    super.key,
    required this.upcomingAppointments,
    required this.chatRooms,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Upcoming Appointments'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Gap(15),
            SwiperBuilderWidget(
              upcomingAppointments: upcomingAppointments,
              isDoctor: true,
            ),
            const Gap(20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Consultation History'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Gap(10),
            ChatEConsultCardList(
              chatRooms: chatRooms,
            ),
          ],
        ),
      ),
    );
  }
}
