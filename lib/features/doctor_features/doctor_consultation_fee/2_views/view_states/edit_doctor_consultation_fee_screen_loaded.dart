import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/bloc/doctor_consultation_fee_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/widgets/doctor_name_widget.dart';

class EditDoctorConsultationFeeScreenLoaded extends StatelessWidget {
  final DoctorModel doctorData;
  bool? isFromDashboard;
  EditDoctorConsultationFeeScreenLoaded({
    super.key,
    required this.doctorData,
    this.isFromDashboard = false,
  });

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final doctorUpdateConsultationFeeBloc =
        context.read<DoctorConsultationFeeBloc>();

    final TextEditingController f2fInitialConsultationPriceController =
        TextEditingController(
            text: doctorData.f2fInitialConsultationPrice != null
                ? doctorData.f2fInitialConsultationPrice?.toStringAsFixed(2)
                : '0.00');
    final TextEditingController f2fFollowUpConsultationPriceController =
        TextEditingController(
            text: doctorData.f2fFollowUpConsultationPrice != null
                ? doctorData.f2fFollowUpConsultationPrice?.toStringAsFixed(2)
                : '0.00');
    final TextEditingController onlineInitialConsultationPriceController =
        TextEditingController(
            text: doctorData.olInitialConsultationPrice != null
                ? doctorData.olInitialConsultationPrice?.toStringAsFixed(2)
                : '0.00');
    final TextEditingController onlineFollowUpConsultationPriceController =
        TextEditingController(
            text: doctorData.olFollowUpConsultationPrice != null
                ? doctorData.olFollowUpConsultationPrice?.toStringAsFixed(2)
                : '0.00');

    return SingleChildScrollView(
      child: Column(
        children: [
          doctorNameWidget(size, ginaTheme, doctorData),
          Column(
            children: [
              Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 10.0),
                    child: Text(
                      'Consultation Fees'.toUpperCase(),
                      style: ginaTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Container(
                    height: size.height * 0.22,
                    width: size.width * 0.92,
                    padding: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Face-to-face consultation',
                              style: ginaTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: GinaAppTheme.lightOutline,
                              ),
                            ),
                            Row(
                              children: [
                                const Text(
                                  '₱',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: TextField(
                                    controller:
                                        f2fInitialConsultationPriceController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.right,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: GinaAppTheme
                                              .lightTertiaryContainer,
                                        ),
                                      ),
                                      isDense: true,
                                    ),
                                    style: ginaTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Gap(20),
                        const Divider(
                          thickness: 0.5,
                          color: GinaAppTheme.lightOutline,
                        ),
                        const Gap(20),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween, //space evenly
                          children: [
                            Text(
                              'Online consultation',
                              style: ginaTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: GinaAppTheme.lightOutline,
                              ),
                            ),
                            Row(
                              children: [
                                const Text(
                                  '₱',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: TextField(
                                    controller:
                                        onlineInitialConsultationPriceController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.right,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: GinaAppTheme
                                              .lightTertiaryContainer,
                                        ),
                                      ),
                                      isDense: true,
                                    ),
                                    style: ginaTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // const Gap(10),
              // Column(
              //   children: [
              //     Container(
              //       alignment: Alignment.centerLeft,
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 30.0, vertical: 10.0),
              //       child: Text(
              //         'Online Consultation'.toUpperCase(),
              //         style: ginaTheme.titleMedium?.copyWith(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 11,
              //         ),
              //       ),
              //     ),
              //     Container(
              //       height: size.height * 0.22,
              //       width: size.width * 0.92,
              //       padding: const EdgeInsets.all(30.0),
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Row(
              //             mainAxisAlignment:
              //                 MainAxisAlignment.spaceBetween, //space evenly
              //             children: [
              //               Text(
              //                 'Initial consultation',
              //                 style: ginaTheme.bodyMedium?.copyWith(
              //                   fontWeight: FontWeight.w500,
              //                   color: GinaAppTheme.lightOutline,
              //                 ),
              //               ),
              //               Row(
              //                 children: [
              //                   const Text(
              //                     '₱',
              //                     style: TextStyle(
              //                       fontWeight: FontWeight.bold,
              //                       fontSize: 16.0,
              //                     ),
              //                   ),
              //                   SizedBox(
              //                     width: 100,
              //                     child: TextField(
              //                       controller:
              //                           onlineInitialConsultationPriceController,
              //                       keyboardType: TextInputType.number,
              //                       textAlign: TextAlign.right,
              //                       decoration: const InputDecoration(
              //                         border: UnderlineInputBorder(),
              //                         focusedBorder: UnderlineInputBorder(
              //                           borderSide: BorderSide(
              //                             color: GinaAppTheme
              //                                 .lightTertiaryContainer,
              //                           ),
              //                         ),
              //                         isDense: true,
              //                       ),
              //                       style: ginaTheme.bodyMedium?.copyWith(
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //           const Gap(20),
              //           const Divider(
              //             thickness: 0.5,
              //             color: GinaAppTheme.lightOutline,
              //           ),
              //           const Gap(20),
              //           Row(
              //             mainAxisAlignment:
              //                 MainAxisAlignment.spaceBetween, //space evenly
              //             children: [
              //               Text(
              //                 'Follow-up consultation',
              //                 style: ginaTheme.bodyMedium?.copyWith(
              //                   fontWeight: FontWeight.w500,
              //                   color: GinaAppTheme.lightOutline,
              //                 ),
              //               ),
              //               Row(
              //                 children: [
              //                   const Text(
              //                     '₱',
              //                     style: TextStyle(
              //                       fontWeight: FontWeight.bold,
              //                       fontSize: 16.0,
              //                     ),
              //                   ),
              //                   SizedBox(
              //                     width: 100,
              //                     child: TextField(
              //                       controller:
              //                           onlineFollowUpConsultationPriceController,
              //                       keyboardType: TextInputType.number,
              //                       textAlign: TextAlign.right,
              //                       decoration: const InputDecoration(
              //                         border: UnderlineInputBorder(),
              //                         focusedBorder: UnderlineInputBorder(
              //                           borderSide: BorderSide(
              //                             color: GinaAppTheme
              //                                 .lightTertiaryContainer,
              //                           ),
              //                         ),
              //                         isDense: true,
              //                       ),
              //                       style: ginaTheme.bodyMedium?.copyWith(
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              const Gap(45),
              SizedBox(
                height: size.height * 0.06,
                width: size.width * 0.9,
                child: FilledButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    doctorUpdateConsultationFeeBloc.add(
                      SaveEditDoctorConsultationFeeEvent(
                        f2fInitialConsultationPrice: double.parse(
                            f2fInitialConsultationPriceController.text),
                        // f2fFollowUpConsultationPrice: double.parse(
                        //     f2fFollowUpConsultationPriceController.text),
                        olInitialConsultationPrice: double.parse(
                            onlineInitialConsultationPriceController.text),
                        // olFollowUpConsultationPrice: double.parse(
                        //     onlineFollowUpConsultationPriceController.text),
                      ),
                    );

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Consultation fees updated'),
                        content: const Text(
                            'Consultation fees have been updated successfully.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              if (isFromDashboard == true) {
                                Navigator.popAndPushNamed(
                                    context, '/doctorConsultationFee');
                              }
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ).then((value) => doctorUpdateConsultationFeeBloc
                        .add(GetDoctorConsultationFeeEvent()));
                  },
                  child: Text(
                    'Save consultation fees',
                    style: ginaTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
