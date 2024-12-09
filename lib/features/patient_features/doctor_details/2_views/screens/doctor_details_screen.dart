import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/doctor_details/2_views/screens/bloc/doctor_details_bloc.dart';
import 'package:gina_app_4/features/patient_features/doctor_details/2_views/screens/view_states/doctor_details_screen_loaded.dart';

class DoctorDetailsScreenProvider extends StatelessWidget {
  const DoctorDetailsScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorDetailsBloc>(
      create: (context) {
        final doctorDetailsBloc = sl<DoctorDetailsBloc>();

        return doctorDetailsBloc;
      },
      child: Container(),
    );
  }
}

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DoctorDetailsScreenLoaded();
  }
}
