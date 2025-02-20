import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';

class PrescriptionImagesList extends StatelessWidget {
  final List<File> prescriptionImage;
  final List<File> imageTitle;
  final AppointmentBloc appointmentBloc;

  const PrescriptionImagesList({
    super.key,
    required this.prescriptionImage,
    required this.imageTitle,
    required this.appointmentBloc,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    return ScrollbarCustom(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: size.height * 0.43,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Prescription/s to be Uploaded',
                style: ginaTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(10),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: prescriptionImage.length,
                  itemBuilder: (context, index) {
                    final image = prescriptionImage[index];
                    final title = imageTitle[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          Container(
                            width: size.width,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.file(
                                    image,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                  const Gap(20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.5,
                                        child: Text(
                                          title.path.split('/').last,
                                          style: ginaTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(10),
                                  InkWell(
                                    onTap: () {
                                      appointmentBloc
                                          .add(RemoveImageEvent(index: index));
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: GinaAppTheme.lightOutline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (index == prescriptionImage.length - 1)
                            const Gap(10),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  width: size.width * 0.9,
                  height: 50,
                  child: FilledButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    onPressed: () {
                      isUploadPrescriptionMode = true;
                      appointmentBloc.add(
                        UploadPrescriptionEvent(
                          appointmentUid: storedAppointmentUid!,
                          images: prescriptionImage,
                        ),
                      );
                    },
                    child: const Text(
                      'Upload',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
