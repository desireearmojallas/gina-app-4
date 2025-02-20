import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/completed_appointments/appointment_consultation_history_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'dart:math';

import 'package:gina_app_4/features/patient_features/home/2_views/bloc/home_bloc.dart';

class ConsultationHistoryContainer extends StatelessWidget {
  final List<AppointmentModel> completedAppointments;
  const ConsultationHistoryContainer({
    super.key,
    required this.completedAppointments,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ginaTheme = Theme.of(context).textTheme;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: GinaAppTheme.lightOnTertiary,
            boxShadow: [
              GinaAppTheme.defaultBoxShadow,
            ],
          ),
          height: height / 2.7,
          width: width / 1.05,
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0, top: 15),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Consultation History',
                        style: ginaTheme.headlineSmall?.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/bottomNavigation',
                        arguments: {
                          'initialIndex': 2,
                          'appointmentTabIndex': 4,
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14.0, top: 12),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Row(
                          children: [
                            Text(
                              'See all',
                              style: ginaTheme.labelMedium?.copyWith(
                                color: GinaAppTheme.lightOutline,
                              ),
                            ),
                            const Gap(5),
                            Text(
                              completedAppointments.isEmpty
                                  ? '(0)'
                                  : '(${completedAppointments.length})',
                              style: ginaTheme.labelMedium?.copyWith(
                                color: GinaAppTheme.lightOutline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              completedAppointments.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 60.0),
                        child: Text(
                          'No History\nYour consultation history will appear here.',
                          style: TextStyle(
                              color: Color.fromARGB(157, 158, 158, 158)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: height / 2.85 - 50,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: min(completedAppointments.length, 3),
                            itemBuilder: (context, index) {
                              final appointment = completedAppointments[index];
                              return AppointmentConsultationHistoryContainer(
                                appointment: appointment,
                              );
                            },
                          ),
                        ),
                        if (completedAppointments.length < 3)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 30.0,
                              right: 10.0,
                              left: 10.0,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: GinaAppTheme.lightOutline
                                        .withOpacity(0.2),
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    'Nothing follows',
                                    style: ginaTheme.bodyMedium?.copyWith(
                                      color: GinaAppTheme.lightOutline
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: GinaAppTheme.lightOutline
                                        .withOpacity(0.2),
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (completedAppointments.length >= 3)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 5.0,
                              right: 10.0,
                              left: 10.0,
                              top: 5.0,
                            ),
                            child: Text(
                              'Showing 3 of ${completedAppointments.length} consultations',
                              style: ginaTheme.bodySmall?.copyWith(
                                color:
                                    GinaAppTheme.lightOutline.withOpacity(0.6),
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }
}
