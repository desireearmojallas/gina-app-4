import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_consultation_history_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/bloc/home_bloc.dart';
import 'package:intl/intl.dart';

class ConsultationHistoryContainer extends StatelessWidget {
  final List<AppointmentModel> filteredConsultationHistory;
  const ConsultationHistoryContainer(
      {super.key, required this.filteredConsultationHistory});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ginaTheme = Theme.of(context);

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/appointments'),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: GinaAppTheme.lightOnTertiary,
              boxShadow: [
                GinaAppTheme.defaultBoxShadow,
              ],
            ),
            height: height / 2.55,
            width: width / 1.05,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0, top: 12),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Consultation History',
                          style: ginaTheme.textTheme.headlineSmall?.copyWith(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/appointments');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 14.0, top: 12),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'See all',
                            style: ginaTheme.textTheme.labelMedium?.copyWith(
                              color: GinaAppTheme.lightOutline,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // const Gap(15),

                filteredConsultationHistory.isEmpty
                    ? const Center(
                        child: Text(
                          'No History,\nYour consultation history will appear here.',
                          style: TextStyle(
                              color: Color.fromARGB(157, 158, 158, 158)),
                          textAlign: TextAlign.center,
                        ),
                        // child: CustomLoadingIndicator(),
                      )
                    : ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) =>
                            const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8),
                          child: Divider(
                            color: GinaAppTheme.lightOutline,
                          ),
                        ),
                        itemCount: min(3, filteredConsultationHistory.length),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final completedAppointment =
                              filteredConsultationHistory[index];

                          debugPrint(
                              'Completed appointment: $completedAppointment');
                          return AppointmentConsultationHistoryContainer(
                            appointment: completedAppointment,
                          );
                        },
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}
