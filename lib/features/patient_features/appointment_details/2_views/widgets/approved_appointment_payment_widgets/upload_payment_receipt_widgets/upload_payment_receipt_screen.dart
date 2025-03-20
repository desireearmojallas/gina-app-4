import 'package:flutter/material.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';

class UploadPaymentReceiptScreen extends StatelessWidget {
  const UploadPaymentReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GinaPatientAppBar(
        title: 'Upload Payment Receipt',
      ),
    );
  }
}
