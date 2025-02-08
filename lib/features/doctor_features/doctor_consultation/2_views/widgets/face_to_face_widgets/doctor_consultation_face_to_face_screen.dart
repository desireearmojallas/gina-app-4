import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/widgets/face_to_face_widgets/appointment_details_card.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/widgets/face_to_face_widgets/session_buttons.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:intl/intl.dart';

class DoctorConsultationFaceToFaceScreen extends StatelessWidget {
  final AppointmentModel patientAppointment;
  final UserModel patientDetails;

  const DoctorConsultationFaceToFaceScreen({
    super.key,
    required this.patientAppointment,
    required this.patientDetails,
  });

  isCurrentTimeWithinRange(String appointmentTime) {
    final now = DateTime.now();
    final dateFormat = DateFormat('hh:mm a');

    final times = appointmentTime.split(' - ');
    final startTime = dateFormat.parse(times[0]);
    final endTime = dateFormat.parse(times[1]);

    final startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
    ).subtract(
        const Duration(minutes: 15)); // Subtract 15 minutes from start time
    final endDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      endTime.hour,
      endTime.minute,
    );

    return now.isAfter(startDateTime) && now.isBefore(endDateTime);
  }

  @override
  Widget build(BuildContext context) {
    final doctorConsultationBloc = context.read<DoctorConsultationBloc>();
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    final age = context.read<BookAppointmentBloc>().calculateAge(
          patientDetails.dateOfBirth,
        );

    final isWithinTimeRange =
        isCurrentTimeWithinRange(patientAppointment.appointmentTime!);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.splashPic),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              appointmentDetailsCard(
                size,
                ginaTheme,
                age,
                patientAppointment.appointmentUid!,
                patientDetails,
              ),
              const Spacer(),
              BlocBuilder<DoctorConsultationBloc, DoctorConsultationState>(
                builder: (context, state) {
                  final isSessionStarted =
                      state is DoctorConsultationF2FSessionStartedState ||
                          patientAppointment.f2fAppointmentStarted == true ||
                          f2fAppointmentStarted == true;
                  final isSessionEnded =
                      state is DoctorConsultationF2FSessionEndedState ||
                          patientAppointment.f2fAppointmentConcluded == true ||
                          f2fAppointmentEnded == true;

                  return SessionControlButtons(
                    isSessionStarted: isSessionStarted,
                    isSessionEnded: isSessionEnded,
                    isWithinTimeRange: isWithinTimeRange,
                    size: size,
                    onStartSession: () {
                      doctorConsultationBloc.add(
                        BeginF2FSessionEvent(
                          appointmentId: patientAppointment.appointmentUid!,
                        ),
                      );
                      Fluttertoast.showToast(
                        msg: 'Session started',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 12,
                        backgroundColor:
                            GinaAppTheme.appbarColorLight.withOpacity(0.85),
                        textColor: Colors.grey[700],
                        fontSize: 12.0,
                      );
                    },
                    onEndSession: () {
                      doctorConsultationBloc.add(
                        ConcludeF2FSessionEvent(
                          appointmentId: patientAppointment.appointmentUid!,
                        ),
                      );
                      Fluttertoast.showToast(
                        msg: 'Successfully ended the session',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 12,
                        backgroundColor:
                            GinaAppTheme.appbarColorLight.withOpacity(0.85),
                        textColor: Colors.grey[700],
                        fontSize: 12.0,
                      );
                    },
                  );
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
