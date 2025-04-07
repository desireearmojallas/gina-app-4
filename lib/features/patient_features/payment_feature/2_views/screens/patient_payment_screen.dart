import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/doctor_availability/2_views/bloc/doctor_availability_bloc.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/2_views/bloc/patient_payment_bloc.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/2_views/screens/view_states/patient_payment_screen_initial.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/2_views/screens/view_states/payment_success_screen.dart';

class PatientPaymentScreenProvider extends StatelessWidget {
  final String appointmentId;
  final String doctorName;
  final String patientName;
  final String modeOfAppointment;
  final double amount;
  final String appointmentDate;

  const PatientPaymentScreenProvider({
    super.key,
    required this.appointmentId,
    required this.doctorName,
    required this.patientName,
    required this.modeOfAppointment,
    required this.amount,
    required this.appointmentDate,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatientPaymentBloc>(
      create: (context) {
        final patientPaymentBloc = sl<PatientPaymentBloc>();
        return patientPaymentBloc;
      },
      child: PatientPaymentScreen(
        appointmentId: appointmentId,
        doctorName: doctorName,
        patientName: patientName,
        modeOfAppointment: modeOfAppointment,
        amount: amount,
        appointmentDate: appointmentDate,
      ),
    );
  }
}

class PatientPaymentScreen extends StatelessWidget {
  final String appointmentId;
  final String doctorName;
  final String patientName;
  final String modeOfAppointment;
  final double amount;
  final String appointmentDate;

  const PatientPaymentScreen({
    super.key,
    required this.appointmentId,
    required this.doctorName,
    required this.patientName,
    required this.modeOfAppointment,
    required this.amount,
    required this.appointmentDate,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientPaymentBloc, PatientPaymentState>(
      listener: (context, state) {
        // Handle any payment-related notifications or errors
      },
      builder: (context, state) {
        if (state.status == PaymentStatus.success &&
            state.successData != null) {
          return PaymentSuccessScreen(
            refNumber: state.successData!.refNumber,
            date: state.successData!.date,
            time: state.successData!.time,
            paymentMethod: state.successData!.paymentMethod,
            senderName: state.successData!.senderName,
            receiverName: state.successData!.receiverName,
            amount: state.successData!.amount,
          );
        }

        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                Images.splashPic,
                fit: BoxFit.cover,
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: GinaPatientAppBar(
                title: 'Payment',
              ),
              body: PatientPaymentScreenInitial(
                appointmentId: appointmentId,
                doctorName: doctorName,
                patientName: patientName,
                amount: amount,
                appointmentDate: appointmentDate,
                modeOfAppointment: modeOfAppointment == 'Face-to-Face' ? 0 : 1,
              ),
            ),
          ],
        );
      },
    );
  }
}
