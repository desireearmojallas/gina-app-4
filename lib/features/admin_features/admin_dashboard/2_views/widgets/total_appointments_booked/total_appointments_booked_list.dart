import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/total_appointments_booked/list_of_all_appointments_booked.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/widgets/total_appointments_booked/label_total_appointments_booked_container.dart';

class AdminDashboardTotalAppointmentsBooked extends StatelessWidget {
  const AdminDashboardTotalAppointmentsBooked({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

// TODO:
//! to change this scaffold
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        child: Container(
          height: size.height * 0.96,
          width: size.width / 1.2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Appointments History',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        //TODO: to change the routing. but for now, pop context
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: GinaAppTheme.lightOutline,
                      ),
                    ),
                  ],
                ),
              ),
              // Gap(10),
              const TotalAppointmentsBookedTable(),
              const ListOfAllAppointmentsBooked(),
            ],
          ),
        ),
      ),
    );
  }
}
