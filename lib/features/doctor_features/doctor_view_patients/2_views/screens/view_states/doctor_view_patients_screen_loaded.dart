import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class DoctorViewPatientsScreenLoaded extends StatelessWidget {
  const DoctorViewPatientsScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;

    return ScrollbarCustom(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                //TODO: TEMPORARY ROUTE FOR PATIENT DETAILS VIEW
                Navigator.of(context).pushNamed(
                  '/doctorPatientDetails',
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(
                          Images.patientProfileIcon,
                        ),
                      ),
                      const Gap(15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Desiree Armojallas',
                            style: ginaTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'desireearmojallas@gina.com',
                            style: ginaTheme.bodySmall?.copyWith(
                              color: GinaAppTheme.lightOutline,
                            ),
                          ),
                        ],
                      ),
                    ],
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
