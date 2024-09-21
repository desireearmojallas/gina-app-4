import 'package:flutter/material.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_consultation_history_container.dart';

class ConsultationHistoryContainer extends StatelessWidget {
  const ConsultationHistoryContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ginaTheme = Theme.of(context);
    // TODO: BLOC BUILDER
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: GinaAppTheme.lightOnTertiary,
        boxShadow: [
          GinaAppTheme.defaultBoxShadow,
        ],
      ),
      // height: height * 0.295,
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
                  // TODO: APPOINTMENT ROUTE
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

          // temporary
          /* const Expanded(
            child: Center(
              child: Text(
                'No History,\nYour consultation history will appear here.',
                style: TextStyle(color: Color.fromARGB(157, 158, 158, 158)),
                textAlign: TextAlign.center,
              ),
             // child: CustomLoadingIndicator(),
            ),
          ), */

          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return const AppointmentConsultationHistoryContainer();
              },
            ),
          ),

          // TODO: BLOC BUILDER FOR THE HOME STATES
        ],
      ),
    );
  }
}
