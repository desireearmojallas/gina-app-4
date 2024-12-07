import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

class DoctorEmergencyAnnouncementPatientList extends StatelessWidget {
  final Map<DateTime, List<AppointmentModel>> approvedPatients;
  const DoctorEmergencyAnnouncementPatientList({
    super.key,
    required this.approvedPatients,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    //! temporary scaffold. will replace once bloc is implemented
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select patients'),
      ),
      body: ScrollbarCustom(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          itemCount: 10,
          itemBuilder: (context, index) {
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              splashFactory: InkRipple.splashFactory,
              splashColor: GinaAppTheme.lightTertiaryContainer,
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: IntrinsicHeight(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: GinaAppTheme.appbarColorLight,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage(
                                  Images.patientProfileIcon,
                                ),
                              ),
                              const Gap(15),
                              SizedBox(
                                width: size.width * 0.4,
                                child: Expanded(
                                  child: Text(
                                    'Desiree Armojallas',
                                    style: ginaTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'December 18, 2024',
                                    style: ginaTheme.bodySmall?.copyWith(
                                      color:
                                          GinaAppTheme.lightTertiaryContainer,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Gap(5),
                                  Text(
                                    '10:00 AM - 11:00 AM',
                                    style: ginaTheme.bodySmall?.copyWith(
                                      color: GinaAppTheme.lightOutline,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                  const Gap(10),
                                ],
                              ),
                            ],
                          ),
                          const Gap(15),
                          Row(
                            children: [
                              Text(
                                'FACE-TO-FACE CONSULTATION',
                                style: ginaTheme.bodySmall?.copyWith(
                                  color: GinaAppTheme.lightTertiaryContainer,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                              const Spacer(),
                              AppointmentStatusContainer(
                                appointmentStatus: 1,
                              ), //TODO: replace with bloc
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
