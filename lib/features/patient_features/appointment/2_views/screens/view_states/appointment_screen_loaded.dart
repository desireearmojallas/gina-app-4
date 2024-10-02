import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_consultation_history_container.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/swiper_builder.dart';

class AppointmentScreenLoaded extends StatelessWidget {
  const AppointmentScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ScrollbarCustom(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(context, 'Upcoming appointments'),
                  const Gap(17),
                  const SwiperBuilderWidget(),
                  const Gap(30),
                  _title(context, 'Consultation history'),
                  const Gap(17),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return const AppointmentConsultationHistoryContainer();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
      textAlign: TextAlign.left,
    );
  }
}
