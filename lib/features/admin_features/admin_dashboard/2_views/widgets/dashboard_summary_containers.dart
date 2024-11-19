import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/total_appointments_booked/total_appointments_booked_list.dart';

class DashboardSummaryContainers extends StatelessWidget {
  const DashboardSummaryContainers({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        InkWell(
          onTap: () {},
          child: FittedBox(
            child: Container(
              width: size.width * 0.115,
              height: size.height * 0.14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffF5E0CD),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: GinaAppTheme.pendingTextColor,
                          child: Icon(
                            Icons.watch_later_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pending\nDoctor\nVerification',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(5),
                        Text(
                          '1000',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Gap(15),
        SizedBox(
          height: size.height * 0.1,
          child: const VerticalDivider(
            color: GinaAppTheme.lightScrim,
            thickness: 0.1,
          ),
        ),
        const Gap(15),
        InkWell(
          onTap: () {},
          child: FittedBox(
            child: Container(
              width: size.width * 0.115,
              height: size.height * 0.14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: GinaAppTheme.lightPrimaryColor,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: GinaAppTheme.lightTertiaryContainer,
                          child: Icon(
                            Icons.badge_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total\nVerified\nDoctors',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(5),
                        Text(
                          '18',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Gap(20),
        InkWell(
          onTap: () {},
          child: FittedBox(
            child: Container(
              width: size.width * 0.115,
              height: size.height * 0.14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffCCEBD9),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: GinaAppTheme.approvedTextColor,
                          child: Icon(
                            Icons.face_3_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total\nPatients',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(5),
                        Text(
                          '23',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Gap(20),
        InkWell(
          onTap: () {
            // TODO:
            //! Temporary route. Will add bloc event here to navigate to the correct page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const AdminDashboardTotalAppointmentsBooked(),
              ),
            );
          },
          child: FittedBox(
            child: Container(
              width: size.width * 0.115,
              height: size.height * 0.14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffE3CDF5),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(0xffA837FF),
                          child: Icon(
                            CupertinoIcons.book_fill,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total\nAppointments\nBooked',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(5),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
