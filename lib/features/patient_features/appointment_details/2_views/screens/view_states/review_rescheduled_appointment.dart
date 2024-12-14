import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/doctor_rating_badge/doctor_rating_badge.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/bloc/appointment_details_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/widgets/appointment_made_dialogue.dart';

class ReviewRescheduledAppointmentScreen extends StatelessWidget {
  final DoctorModel doctorDetails;
  final UserModel currentPatient;
  final AppointmentModel appointmentModel;
  const ReviewRescheduledAppointmentScreen({
    super.key,
    required this.doctorDetails,
    required this.currentPatient,
    required this.appointmentModel,
  });

  @override
  Widget build(BuildContext context) {
    final bookAppointmentBloc = context.read<BookAppointmentBloc>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(25),
                Row(
                  children: [
                    const Gap(20),
                    Image.asset(Images.doctorProfileIcon1,
                        width: 120, height: 120),
                    const Gap(30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DoctorRatingBadge(
                          doctorRating: doctorDetails.doctorRatingId,
                        ),
                        const Gap(5),
                        Row(
                          children: [
                            Text(
                              'Dr. ${doctorDetails.name}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const Gap(5),
                            const Icon(
                              Icons.verified_rounded,
                              color: Color(0xff29A5FF),
                              size: 20,
                            )
                          ],
                        ),
                        const Gap(2),
                        Text(doctorDetails.medicalSpecialty,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: GinaAppTheme.lightOutline,
                                )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Text(doctorDetails.officeMapsLocationAddress,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: GinaAppTheme.lightOutline,
                                  )),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(20),
                      const Divider(
                        thickness: 0.2,
                        color: GinaAppTheme.lightOutline,
                      ),
                      const Gap(5),
                      Text(' ID: ${appointmentModel.appointmentUid}',
                          style: Theme.of(context).textTheme.bodyMedium),
                      const Gap(5),
                      const Divider(
                        thickness: 0.2,
                        color: GinaAppTheme.lightOutline,
                      ),
                      const Gap(10),
                      Row(
                        children: [
                          const Gap(5),
                          // Image.asset(Images.doctorStethoscope),
                          const Gap(15),
                          Text(
                            'Appointment Detail',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        ],
                      ),
                      const Gap(10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Clinic location',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const Gap(35),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Text(
                              appointmentModel.doctorClinicAddress!,
                              style: const TextStyle(fontSize: 12),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Mode of appointment',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const Gap(35),
                          Text(
                            appointmentModel.modeOfAppointment == 0
                                ? 'Online Consultation'
                                : 'Face-to-Face Consultation',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const Gap(20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date and time',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const Gap(35),
                          Text(
                            '${appointmentModel.appointmentDate!} \n${appointmentModel.appointmentTime!}',
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                      const Gap(10),
                      const Divider(
                        thickness: 0.2,
                        color: GinaAppTheme.lightOutline,
                      ),
                      const Gap(10),
                      Row(
                        children: [
                          const Gap(5),
                          const Icon(
                            Icons.person_rounded,
                            color: GinaAppTheme.lightOnSecondary,
                          ),
                          const Gap(5),
                          Text(
                            'Patient Personal Information',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        ],
                      ),
                      const Gap(20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Name',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const Gap(35),
                          Text(
                            currentPatient.name,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const Gap(20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Age',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const Gap(35),
                          Text(
                            " ${bookAppointmentBloc.calculateAge(currentPatient.dateOfBirth)} years old",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const Gap(20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Location',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const Gap(35),
                          SizedBox(
                            width: 150,
                            child: Text(
                              currentPatient.address,
                              textAlign: TextAlign.end,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Gap(5),
          Text(
            'To ensure a smooth online appointment, please be prepared 15 \nminutes before the scheduled time.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: GinaAppTheme.lightOutline,
                ),
          ),
          const Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: FilledButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              onPressed: () {
                isRescheduleMode = false;
                showAppointmentMadeDialog(context)
                    .then((value) => Navigator.of(context).pop());
              },
              child: Text(
                'Finish Review',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
