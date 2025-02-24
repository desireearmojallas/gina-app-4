import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/bloc/home_bloc.dart';

class BookAppointmentContainer extends StatelessWidget {
  const BookAppointmentContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ginaTheme = Theme.of(context);
    final homeBloc = context.read<HomeBloc>();
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pushNamed(context, '/find');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: GinaAppTheme.lightOnTertiary,
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        height: height * 0.173,
        width: width / 1.69,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(
                      'Book\nappointment',
                      style: ginaTheme.textTheme.headlineSmall?.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Gap(30),
                  SizedBox(
                    height: 25,
                    child: FilledButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5)),
                      ),
                      onPressed: () {
                        // TODO: ONPRESS BOOK APPT CONTAINER
                        // homeBloc.add();
                        //TODO: TO CHANGE? add this after implementing the period tracker
                        Navigator.pushNamed(context, '/find');
                        //  homeBloc.add(HomeNavigateToFindDoctorEvent());
                      },
                      child: Row(
                        children: [
                          Text(
                            'Next',
                            style: ginaTheme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const Gap(8),
                          const Icon(
                            Icons.arrow_forward,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              // child: SvgPicture.asset(
              //   Images.appointmentImage,
              //   height: height * 0.085,
              //   fit: BoxFit.fill,
              // ),
              child: Image.asset(
                Images.appointmentImage,
                height: height * 0.165,
                // height: 110,
                fit: BoxFit.fitHeight,
              ),
            ),
            const Gap(5),
          ],
        ),
      ),
    );
  }
}
