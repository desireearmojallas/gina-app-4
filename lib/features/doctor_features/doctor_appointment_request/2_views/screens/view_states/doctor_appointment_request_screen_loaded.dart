import 'package:flutter/material.dart';

class DoctorAppointmentRequestScreenLoaded extends StatelessWidget {
  const DoctorAppointmentRequestScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Approved'),
              Tab(text: 'Declined'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ],
      ),
    );
  }
}
