import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/widgets/doctor_name_widget.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/bloc/appointment_details_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/reschedule_appointment_success.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/reschedule_filled_button.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/doctor_availability/0_model/doctor_availability_model.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class BookAppointmentInitialScreen extends StatelessWidget {
  final DoctorAvailabilityModel doctorAvailabilityModel;
  final DoctorModel doctor;
  const BookAppointmentInitialScreen({
    super.key,
    required this.doctorAvailabilityModel,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final bookAppointmentBloc = context.read<BookAppointmentBloc>();
    final appointmentDetailsBloc = context.read<AppointmentDetailsBloc>();
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    // Ensure modeOfAppointmentList always has both options
    final modeOfAppointmentList = ['Online Consultation', 'Face-to-Face'];
    final availableModes =
        bookAppointmentBloc.getModeOfAppointment(doctorAvailabilityModel);

    // Debugging: Print the mode of appointment list
    debugPrint(
        'Mode of Appointment List in booked appt initial: $availableModes');

    return ScrollbarCustom(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            doctorNameWidget(size, ginaTheme, doctor),
            doctorAvailabilityModel.startTimes.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(
                            MingCute.unhappy_line,
                            size: 30,
                            color: GinaAppTheme.lightOutline,
                          ),
                          const Gap(20),
                          Text(
                            'Doctor is not yet available for appointments.\nPlease check back later.',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: GinaAppTheme.lightOutline,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select a date',
                          style: ginaTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(10),
                        SizedBox(
                          width: size.width * 1,
                          child: TextFormField(
                            controller: bookAppointmentBloc.dateController,
                            readOnly: true,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                            onTap: () async {
                              DateTime now = DateTime.now();
                              DateTime today =
                                  DateTime(now.year, now.month, now.day);
                              DateTime firstDayOfThisWeek =
                                  now.subtract(Duration(days: now.weekday - 1));
                              DateTime lastDayOfThisWeek = firstDayOfThisWeek
                                  .add(const Duration(days: 6));
                              DateTime firstDayOfNextWeek = firstDayOfThisWeek
                                  .add(const Duration(days: 7));

                              DateTime firstDate =
                                  now.isAfter(lastDayOfThisWeek)
                                      ? firstDayOfNextWeek
                                      : firstDayOfThisWeek;

                              DateTime lastDate =
                                  firstDate.add(const Duration(days: 6));

                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                firstDate: firstDate,
                                lastDate: lastDate,
                                helpText: 'Next week\'s dates out Sunday.',
                                selectableDayPredicate: (date) {
                                  return date.isAfter(today
                                          .subtract(const Duration(days: 1))) &&
                                      doctorAvailabilityModel.days
                                          .contains(date.weekday % 7);
                                },
                              );

                              if (selectedDate != null) {
                                bookAppointmentBloc.dateController.text =
                                    DateFormat('EEEE, d ' 'of' ' MMMM y')
                                        .format(selectedDate);
                              } else {
                                showDialog(
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('No Date Selected'),
                                      content:
                                          const Text('Please select a date'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Ok'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            decoration: InputDecoration(
                              suffixIcon: const Icon(
                                  Icons.calendar_today_rounded,
                                  color: GinaAppTheme.lightOutline),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Select a date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const Gap(20),
                        Text(
                          'Select time',
                          style: ginaTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(20),
                        Text(
                          'Morning',
                          style: ginaTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: GinaAppTheme.lightOutline,
                          ),
                        ),
                        const Gap(10),
                        Center(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final List<String> morningTimeslots = [];
                              final List<String> afternoonTimeslots = [];

                              for (var i = 0;
                                  i < doctorAvailabilityModel.startTimes.length;
                                  i++) {
                                final timeslot =
                                    '${doctorAvailabilityModel.startTimes[i]} - ${doctorAvailabilityModel.endTimes[i]}';
                                if (doctorAvailabilityModel.startTimes[i]
                                    .contains('AM')) {
                                  morningTimeslots.add(timeslot);
                                } else {
                                  afternoonTimeslots.add(timeslot);
                                }
                              }

                              debugPrint('$morningTimeslots morning');
                              debugPrint('$afternoonTimeslots afternoon');

                              const double rowHeight = 40.0;
                              const double spacing = 25.0;

                              final int morningRows =
                                  (morningTimeslots.length / 3).ceil();
                              final double morningDynamicHeight =
                                  (morningRows * rowHeight) +
                                      ((morningRows - 1) * spacing);

                              final int afternoonRows =
                                  (afternoonTimeslots.length / 3).ceil();
                              final double afternoonDynamicHeight =
                                  (afternoonRows * rowHeight) +
                                      ((afternoonRows - 1) * spacing);

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Morning Timeslots
                                  SizedBox(
                                    width: constraints.maxWidth * 0.95,
                                    height: morningDynamicHeight > 0
                                        ? morningDynamicHeight
                                        : rowHeight,
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: morningTimeslots.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisExtent: 40,
                                        crossAxisSpacing: 15,
                                        mainAxisSpacing: 25,
                                      ),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            final currentState =
                                                bookAppointmentBloc.state;
                                            if (currentState
                                                is GetDoctorAvailabilityLoaded) {
                                              final selectedIndex = currentState
                                                  .selectedTimeIndex;

                                              if (selectedIndex == index) {
                                                bookAppointmentBloc.add(
                                                  const SelectTimeEvent(
                                                    index: -1,
                                                    startingTime: '',
                                                    endingTime: '',
                                                  ),
                                                );
                                              } else {
                                                bookAppointmentBloc.add(
                                                  SelectTimeEvent(
                                                    index: index,
                                                    startingTime:
                                                        doctorAvailabilityModel
                                                            .startTimes[index],
                                                    endingTime:
                                                        doctorAvailabilityModel
                                                            .endTimes[index],
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          child: BlocBuilder<
                                              BookAppointmentBloc,
                                              BookAppointmentState>(
                                            builder: (context, state) {
                                              final selectedIndex = state
                                                      is GetDoctorAvailabilityLoaded
                                                  ? state.selectedTimeIndex
                                                  : -1;
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: selectedIndex == index
                                                      ? GinaAppTheme
                                                          .lightTertiaryContainer
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color:
                                                        selectedIndex == index
                                                            ? Colors.transparent
                                                            : GinaAppTheme
                                                                .lightOutline,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    morningTimeslots[index],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelSmall
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 11,
                                                          letterSpacing: 0.001,
                                                          color: selectedIndex ==
                                                                  index
                                                              ? Colors.white
                                                              : GinaAppTheme
                                                                  .lightOnPrimaryColor,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const Gap(20),
                                  // Afternoon Section
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Afternoon',
                                      style: ginaTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: GinaAppTheme.lightOutline,
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  SizedBox(
                                    width: constraints.maxWidth * 0.95,
                                    height: afternoonDynamicHeight > 0
                                        ? afternoonDynamicHeight
                                        : rowHeight,
                                    child: GridView.builder(
                                        shrinkWrap: true,
                                        itemCount: afternoonTimeslots.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisExtent: 40,
                                          crossAxisSpacing: 15,
                                          mainAxisSpacing: 25,
                                        ),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              final currentState =
                                                  bookAppointmentBloc.state;
                                              if (currentState
                                                  is GetDoctorAvailabilityLoaded) {
                                                final selectedIndex =
                                                    currentState
                                                        .selectedTimeIndex;

                                                final afternoonIndex = index +
                                                    morningTimeslots.length;

                                                if (selectedIndex ==
                                                    afternoonIndex) {
                                                  bookAppointmentBloc.add(
                                                    const SelectTimeEvent(
                                                      index: -1,
                                                      startingTime: '',
                                                      endingTime: '',
                                                    ),
                                                  );
                                                } else {
                                                  bookAppointmentBloc.add(
                                                    SelectTimeEvent(
                                                      index: afternoonIndex,
                                                      startingTime:
                                                          doctorAvailabilityModel
                                                                  .startTimes[
                                                              afternoonIndex],
                                                      endingTime:
                                                          doctorAvailabilityModel
                                                                  .endTimes[
                                                              afternoonIndex],
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            child: BlocBuilder<
                                                BookAppointmentBloc,
                                                BookAppointmentState>(
                                              builder: (context, state) {
                                                final selectedIndex = state
                                                        is GetDoctorAvailabilityLoaded
                                                    ? state.selectedTimeIndex
                                                    : -1;
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: selectedIndex ==
                                                            (index +
                                                                morningTimeslots
                                                                    .length)
                                                        ? GinaAppTheme
                                                            .lightTertiaryContainer
                                                        : Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      color: selectedIndex ==
                                                              (index +
                                                                  morningTimeslots
                                                                      .length)
                                                          ? Colors.transparent
                                                          : GinaAppTheme
                                                              .lightOutline,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      afternoonTimeslots[index],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 11,
                                                            letterSpacing:
                                                                0.001,
                                                            color: selectedIndex ==
                                                                    (index +
                                                                        morningTimeslots
                                                                            .length)
                                                                ? Colors.white
                                                                : GinaAppTheme
                                                                    .lightOnPrimaryColor,
                                                          ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const Gap(40),
                        Text(
                          'Mode of appointment',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const Gap(15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List<Widget>.generate(
                              modeOfAppointmentList.length,
                              (index) {
                                final isAvailable = availableModes
                                    .contains(modeOfAppointmentList[index]);
                                return InkWell(
                                  onTap: isAvailable
                                      ? () {
                                          // Debugging: Print the clicked index and mode of appointment
                                          debugPrint('Clicked Index: $index');
                                          debugPrint(
                                              'Clicked Mode of Appointment: ${modeOfAppointmentList[index]}');

                                          bookAppointmentBloc.add(
                                            SelectedModeOfAppointmentEvent(
                                              index: index,
                                              modeOfAppointment:
                                                  modeOfAppointmentList[index],
                                            ),
                                          );
                                        }
                                      : null,
                                  child: BlocBuilder<BookAppointmentBloc,
                                      BookAppointmentState>(
                                    builder: (context, state) {
                                      final selectedIndex = state
                                              is GetDoctorAvailabilityLoaded
                                          ? state.selectedModeofAppointmentIndex
                                          : -1;
                                      return Container(
                                        width: size.width * 0.42,
                                        decoration: BoxDecoration(
                                          color: selectedIndex == index
                                              ? GinaAppTheme
                                                  .lightTertiaryContainer
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: selectedIndex == index
                                                ? Colors.transparent
                                                : isAvailable
                                                    ? GinaAppTheme.lightOutline
                                                    : GinaAppTheme
                                                        .lightSurfaceVariant,
                                          ),
                                        ),
                                        height: 40,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              modeOfAppointmentList[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 11,
                                                    letterSpacing: 0.001,
                                                    color: selectedIndex ==
                                                            index
                                                        ? Colors.white
                                                        : isAvailable
                                                            ? GinaAppTheme
                                                                .lightOnPrimaryColor
                                                            : GinaAppTheme
                                                                .lightOutline,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const Gap(80),
                        BlocBuilder<BookAppointmentBloc, BookAppointmentState>(
                          builder: (context, state) {
                            return Center(
                              child: SizedBox(
                                width: size.width * 0.93,
                                height: size.height / 17,
                                child: FilledButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (bookAppointmentBloc
                                            .dateController.text.isEmpty ||
                                        bookAppointmentBloc.selectedTimeIndex ==
                                            -1 ||
                                        bookAppointmentBloc
                                                .selectedModeofAppointmentIndex ==
                                            -1) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please select a date, time and mode of appointment',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                          backgroundColor:
                                              GinaAppTheme.lightError,
                                        ),
                                      );
                                    } else {
                                      final currentState =
                                          bookAppointmentBloc.state;

                                      if (currentState
                                          is GetDoctorAvailabilityLoaded) {
                                        final selectedIndex =
                                            currentState.selectedTimeIndex!;
                                        final selectedTime =
                                            '${doctorAvailabilityModel.startTimes[selectedIndex]} - ${doctorAvailabilityModel.endTimes[selectedIndex]}';

                                        if (isRescheduleMode) {
                                          appointmentDetailsBloc.add(
                                            RescheduleAppointmentEvent(
                                              appointmentUid:
                                                  appointmentUidToReschedule!,
                                              appointmentDate:
                                                  bookAppointmentBloc
                                                      .dateController.text,
                                              appointmentTime: selectedTime,
                                              modeOfAppointment: bookAppointmentBloc
                                                  .selectedModeofAppointmentIndex,
                                            ),
                                          );
                                          isRescheduleMode = false;
                                          showRescheduleAppointmentSuccessDialog(
                                            context,
                                            appointmentUidToReschedule!,
                                          );
                                        } else {
                                          debugPrint(
                                              'Doctor ID: ${doctor.uid}');
                                          debugPrint(
                                              'Doctor Name: ${doctor.name}');
                                          debugPrint(
                                              'Doctor Address: ${doctor.officeAddress}');
                                          debugPrint(
                                              'Selected Date: ${bookAppointmentBloc.dateController.text}');
                                          debugPrint(
                                              'Selected Time: $selectedTime');
                                          debugPrint(
                                              'Mode of Appointment: ${modeOfAppointmentList[bookAppointmentBloc.selectedModeofAppointmentIndex]}');

                                          bookAppointmentBloc.add(
                                            BookForAnAppointmentEvent(
                                              doctorId: doctor.uid,
                                              doctorName: doctor.name,
                                              doctorClinicAddress:
                                                  doctor.officeAddress,
                                              appointmentDate:
                                                  bookAppointmentBloc
                                                      .dateController.text,
                                              appointmentTime: selectedTime,
                                            ),
                                          );

                                          debugPrint(
                                              'BookForAnAppointmentEvent dispatched');
                                        }
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Book Appointment',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
