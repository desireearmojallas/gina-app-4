import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/2_views/bloc/auth_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';

class DoctorUploadStatusScreen extends StatelessWidget {
  const DoctorUploadStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);
    final authBloc = context.read<AuthBloc>();
    final size = MediaQuery.of(context).size;
    bool _hasShownProgressBar = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Medical License',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
            ),
            const Gap(20),
            const Text(
              'The file must be submitted in the format JPG, JPEG, PNG or PDF, and the file size is limited to 2.5 MB.',
              textAlign: TextAlign.left,
            ),
            const Gap(35),
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: const [25, 20],
              color: const Color(0xffB4B4B4),
              strokeWidth: 2,
              child: Container(
                width: size.width * 0.9,
                height: size.height * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Bootstrap.cloud_upload_fill,
                      color: Color(0xffB4B4B4),
                      size: 125,
                    ),
                    const Gap(20),
                    SizedBox(
                      width: size.width * 0.3,
                      child: OutlinedButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide>(
                            const BorderSide(
                              color: GinaAppTheme.lightOnPrimaryColor,
                              width: 1.4,
                            ),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Import file',
                          style: TextStyle(
                            color: GinaAppTheme.lightOnPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          authBloc.add(ChooseMedicalIdImageEvent());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(35),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is UploadMedicalImageLoadingState) {
                  return const Center(
                    child: CustomLoadingIndicator(),
                  );
                } else if (state is UploadMedicalImageState) {
                  final image = state.medicalImageId;
                  final imageTitle = state.medicalImageIdTitle;

                  if (!state.hasShownProgressBar) {
                    Timer(const Duration(seconds: 10), () {
                      authBloc.add(ProgressBarCompletedEvent());
                    });
                  }

                  if (image.path.isEmpty) {
                    return const SizedBox();
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Medical License to be Uploaded for Verification',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const Gap(25),
                        Container(
                          width: size.width,
                          height: 80,
                          decoration: BoxDecoration(
                            color: GinaAppTheme.appbarColorLight,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              GinaAppTheme.defaultBoxShadow,
                            ],
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.photo,
                                  color: Color(0xffB4B4B4),
                                  size: 30,
                                ),
                                const Gap(20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (!state.hasShownProgressBar)
                                      Column(
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.5,
                                            child: Text(
                                              imageTitle.path.split('/').last,
                                              // 'medical_license.pdf',
                                              style: ginaTheme
                                                  .textTheme.bodyMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (state.hasShownProgressBar)
                                      SizedBox(
                                        width: size.width * 0.60,
                                        child: Text(
                                          imageTitle.path.split('/').last,
                                          // 'medical_license.pdf',
                                          style: ginaTheme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: true,
                                        ),
                                      ),
                                    Gap(size.height * 0.01),
                                    if (!state.hasShownProgressBar)
                                      ProgressBarAnimation(
                                        duration: const Duration(seconds: 10),
                                        width: size.width * 0.60,
                                        height: size.height * 0.006,
                                        gradient: LinearGradient(
                                          colors: GinaAppTheme.gradientColors,
                                        ),
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.4),
                                      ),
                                    if (state.hasShownProgressBar)
                                      const SizedBox.shrink(),
                                  ],
                                ),
                                const Gap(25),
                                InkWell(
                                  onTap: () {
                                    authBloc.add(RemoveMedicalIdImageEvent());
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                    color: GinaAppTheme.lightOutline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(60),
                        SizedBox(
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
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Upload File',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
