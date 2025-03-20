import 'package:flutter/material.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';

class ViewBankDetailsScreen extends StatelessWidget {
  const ViewBankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GinaPatientAppBar(
        title: 'View Bank Details',
      ),
      body: ScrollbarCustom(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Bank Details
              // Bank Name
              // Account Number
              // IFSC Code
              // Branch Name
              // Branch Address
              // Account Holder Name
              // Account Type
              // Account Status
            ],
          ),
        ),
      ),
    );
  }
}
