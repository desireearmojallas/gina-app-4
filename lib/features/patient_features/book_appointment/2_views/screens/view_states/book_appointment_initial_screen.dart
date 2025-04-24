import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/gina_divider.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/widgets/doctor_name_widget.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/bloc/appointment_details_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/screens/view_states/review_rescheduled_appointment.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/reschedule_appointment_success.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/reschedule_filled_button.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/doctor_availability/0_model/doctor_availability_model.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    var selectedModeOfAppointmentIndex = -1;

//TODO: TO CHANGE THIS, WILL MAKE THIS DYNAMIC ON THE ADMIN SIDE
    const double onlinePlatformFeePercentage = 0.10;
    const double f2fPlatformFeePercentage = 0.15;

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
                        Container(
                          width: size.width * 1,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: GinaAppTheme.lightTertiaryContainer,
                            ),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: GinaAppTheme.lightTertiaryContainer
                            //         .withOpacity(0.1),
                            //     blurRadius: 8,
                            //     offset: const Offset(0, 4),
                            //   ),
                            // ],
                          ),
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

                              bool allCurrentWeekSlotsDisabled = true;

                              for (int weekday = now.weekday;
                                  weekday <= 7;
                                  weekday++) {
                                int doctorDayIndex = weekday % 7;

                                // Skip days the doctor doesn't work
                                if (!doctorAvailabilityModel.days
                                    .contains(doctorDayIndex)) {
                                  continue;
                                }

                                // Create date for this weekday
                                DateTime checkDate = today.add(Duration(
                                    days: doctorDayIndex - today.weekday % 7));

                                // Check if at least one time slot is available on this day
                                bool hasAvailableSlot = false;
                                for (int i = 0;
                                    i <
                                        doctorAvailabilityModel
                                            .startTimes.length;
                                    i++) {
                                  if (!doctorAvailabilityModel
                                      .isTimeSlotDisabled(
                                          doctorDayIndex,
                                          doctorAvailabilityModel.startTimes[i],
                                          doctorAvailabilityModel.endTimes[i],
                                          selectedDate: checkDate)) {
                                    hasAvailableSlot = true;
                                    break;
                                  }
                                }

                                if (hasAvailableSlot) {
                                  allCurrentWeekSlotsDisabled = false;
                                  break;
                                }
                              }

                              // If all slots are unavailable, go to next week automatically
                              DateTime firstDate =
                                  allCurrentWeekSlotsDisabled ||
                                          now.isAfter(lastDayOfThisWeek)
                                      ? firstDayOfNextWeek
                                      : firstDayOfThisWeek;
                              DateTime lastDate =
                                  firstDate.add(const Duration(days: 6));

                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                firstDate: firstDate,
                                lastDate: lastDate,
                                helpText: allCurrentWeekSlotsDisabled
                                    ? 'This week\'s slots are full. Showing next week.'
                                    : 'Select an appointment date.',
                                selectableDayPredicate: (date) {
                                  return date.isAfter(today
                                          .subtract(const Duration(days: 1))) &&
                                      doctorAvailabilityModel.days
                                          .contains(date.weekday % 7);
                                },
                              );

                              if (selectedDate != null) {
                                // Store the date in MMMM dd, yyyy format
                                final formattedDate = DateFormat('MMMM d, yyyy')
                                    .format(selectedDate);
                                // Display the date in a more readable format
                                bookAppointmentBloc.dateController.text =
                                    DateFormat('EEEE, d \'of\' MMMM y')
                                        .format(selectedDate);
                                // Store the formatted date for later use
                                bookAppointmentBloc.selectedFormattedDate =
                                    formattedDate;
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
                                color: GinaAppTheme.lightOutline,
                              ),
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
                                              if (bookAppointmentBloc
                                                  .dateController
                                                  .text
                                                  .isEmpty) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Please select a date first'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                                return;
                                              }

                                              final selectedIndex = currentState
                                                  .selectedTimeIndex;

                                              // Get the selected date's weekday (0-6, where 0 is Sunday)
                                              DateTime selectedDate = DateFormat(
                                                      'EEEE, d \'of\' MMMM y')
                                                  .parse(bookAppointmentBloc
                                                      .dateController.text);
                                              int selectedWeekday =
                                                  selectedDate.weekday % 7;

                                              // Check if the time slot is disabled
                                              bool isDisabled =
                                                  doctorAvailabilityModel
                                                      .isTimeSlotDisabled(
                                                selectedWeekday,
                                                doctorAvailabilityModel
                                                    .startTimes[index],
                                                doctorAvailabilityModel
                                                    .endTimes[index],
                                                selectedDate: selectedDate,
                                              );

                                              if (isDisabled) {
                                                // Show a message that the slot is not available
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'This time slot is not available'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                                return;
                                              }

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

                                              // Check if the time slot is disabled
                                              bool isDisabled = false;
                                              if (bookAppointmentBloc
                                                  .dateController
                                                  .text
                                                  .isNotEmpty) {
                                                DateTime selectedDate = DateFormat(
                                                        'EEEE, d \'of\' MMMM y')
                                                    .parse(bookAppointmentBloc
                                                        .dateController.text);
                                                int selectedWeekday =
                                                    selectedDate.weekday % 7;
                                                isDisabled =
                                                    doctorAvailabilityModel
                                                        .isTimeSlotDisabled(
                                                  selectedWeekday,
                                                  doctorAvailabilityModel
                                                      .startTimes[index],
                                                  doctorAvailabilityModel
                                                      .endTimes[index],
                                                  selectedDate: selectedDate,
                                                );
                                              }

                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: isDisabled
                                                      ? Colors.grey[300]
                                                      : selectedIndex == index
                                                          ? GinaAppTheme
                                                              .lightTertiaryContainer
                                                          : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: isDisabled
                                                        ? Colors.grey[400]!
                                                        : selectedIndex == index
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
                                                          color: isDisabled
                                                              ? Colors.grey[600]
                                                              : selectedIndex ==
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
                                                if (bookAppointmentBloc
                                                    .dateController
                                                    .text
                                                    .isEmpty) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Please select a date first'),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                  return;
                                                }
                                                final selectedIndex =
                                                    currentState
                                                        .selectedTimeIndex;

                                                final afternoonIndex = index +
                                                    morningTimeslots.length;

                                                // Get the selected date's weekday (0-6, where 0 is Sunday)
                                                DateTime selectedDate = DateFormat(
                                                        'EEEE, d \'of\' MMMM y')
                                                    .parse(bookAppointmentBloc
                                                        .dateController.text);
                                                int selectedWeekday = selectedDate
                                                        .weekday %
                                                    7; // Convert to 0-6 format

                                                // Check if the time slot is disabled
                                                bool isDisabled =
                                                    doctorAvailabilityModel
                                                        .isTimeSlotDisabled(
                                                  selectedWeekday,
                                                  doctorAvailabilityModel
                                                          .startTimes[
                                                      afternoonIndex],
                                                  doctorAvailabilityModel
                                                      .endTimes[afternoonIndex],
                                                  selectedDate: selectedDate,
                                                );

                                                if (isDisabled) {
                                                  // Show a message that the slot is not available
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'This time slot is not available'),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                  return;
                                                }

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

                                                final afternoonIndex = index +
                                                    morningTimeslots.length;

                                                // Check if the time slot is disabled
                                                bool isDisabled = false;
                                                if (bookAppointmentBloc
                                                    .dateController
                                                    .text
                                                    .isNotEmpty) {
                                                  DateTime selectedDate = DateFormat(
                                                          'EEEE, d \'of\' MMMM y')
                                                      .parse(bookAppointmentBloc
                                                          .dateController.text);
                                                  int selectedWeekday =
                                                      selectedDate.weekday % 7;
                                                  isDisabled =
                                                      doctorAvailabilityModel
                                                          .isTimeSlotDisabled(
                                                    selectedWeekday,
                                                    doctorAvailabilityModel
                                                            .startTimes[
                                                        afternoonIndex],
                                                    doctorAvailabilityModel
                                                            .endTimes[
                                                        afternoonIndex],
                                                    selectedDate: selectedDate,
                                                  );
                                                }

                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: isDisabled
                                                        ? Colors.grey[300]
                                                        : selectedIndex ==
                                                                afternoonIndex
                                                            ? GinaAppTheme
                                                                .lightTertiaryContainer
                                                            : Colors
                                                                .transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      color: isDisabled
                                                          ? Colors.grey[400]!
                                                          : selectedIndex ==
                                                                  afternoonIndex
                                                              ? Colors
                                                                  .transparent
                                                              : GinaAppTheme
                                                                  .lightOutline,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      afternoonTimeslots[index],
                                                      style:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .labelSmall
                                                              ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 11,
                                                                letterSpacing:
                                                                    0.001,
                                                                color: isDisabled
                                                                    ? Colors.grey[600]
                                                                    : selectedIndex == afternoonIndex
                                                                        ? Colors.white
                                                                        : GinaAppTheme.lightOnPrimaryColor,
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
                                final price = index == 0
                                    ? doctor.olInitialConsultationPrice
                                    : doctor.f2fInitialConsultationPrice;

                                return InkWell(
                                  onTap: isRescheduleMode
                                      ? null // Disable selection in reschedule mode
                                      : isAvailable
                                          ? () {
                                              debugPrint(
                                                  'Clicked Index: $index');
                                              selectedModeOfAppointmentIndex =
                                                  index;
                                              debugPrint(
                                                  'Clicked Mode of Appointment: ${modeOfAppointmentList[index]}');

                                              bookAppointmentBloc.add(
                                                SelectedModeOfAppointmentEvent(
                                                  index: index,
                                                  modeOfAppointment:
                                                      modeOfAppointmentList[
                                                          index],
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

                                      // In reschedule mode, use the mode from appointmentDetailsForReschedule
                                      final isSelected = isRescheduleMode
                                          ? appointmentDetailsForReschedule
                                                  ?.modeOfAppointment ==
                                              index
                                          : selectedIndex == index;

                                      return Container(
                                        width: size.width * 0.42,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? GinaAppTheme
                                                  .lightTertiaryContainer
                                              : isRescheduleMode && !isSelected
                                                  ? Colors.grey[200]
                                                  : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: isSelected
                                                ? Colors.transparent
                                                : isAvailable
                                                    ? GinaAppTheme.lightOutline
                                                    : GinaAppTheme
                                                        .lightSurfaceVariant,
                                          ),
                                        ),
                                        height: 60,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              modeOfAppointmentList[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 11,
                                                    letterSpacing: 0.001,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : isAvailable
                                                            ? GinaAppTheme
                                                                .lightOnPrimaryColor
                                                            : GinaAppTheme
                                                                .lightOutline,
                                                  ),
                                            ),
                                            if (price != null &&
                                                isAvailable) ...[
                                              const Gap(4),
                                              Text(
                                                '₱${NumberFormat('#,##0.00').format(price)} + ${((index == 0 ? onlinePlatformFeePercentage : f2fPlatformFeePercentage) * 100).toInt()}% PF',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 10,
                                                      color: isSelected
                                                          ? Colors.white
                                                          : isAvailable
                                                              ? GinaAppTheme
                                                                  .lightOnPrimaryColor
                                                              : GinaAppTheme
                                                                  .lightOutline,
                                                    ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const Gap(30),
                        Text(
                          'Chief complaint / Reason for visit',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const Gap(15),
                        Container(
                          width: size.width * 1,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: GinaAppTheme.lightTertiaryContainer,
                            ),
                          ),
                          child: TextFormField(
                            controller: bookAppointmentBloc.reasonController,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText:
                                  'Please describe your symptoms or reason for this visit',
                              hintStyle: TextStyle(
                                fontSize: 12.0,
                                color:
                                    GinaAppTheme.lightOutline.withOpacity(0.7),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(15),
                            ),
                          ),
                        ),
                        const Gap(20),
                        GinaDivider(),
                        // Commenting out the Pay Now button section - can be uncommented if needed
                        /*
                        BlocBuilder<BookAppointmentBloc, BookAppointmentState>(
                          builder: (context, state) {
                            // Check if we have all the required selections
                            final hasDate = bookAppointmentBloc
                                .dateController.text.isNotEmpty;
                            final hasTime =
                                bookAppointmentBloc.selectedTimeIndex != -1;
                            final hasMode = isRescheduleMode
                                ? true // In reschedule mode, mode is already selected
                                : bookAppointmentBloc
                                        .selectedModeofAppointmentIndex !=
                                    -1;

                            debugPrint('Pay Now Button State:');
                            debugPrint('Has Date: $hasDate');
                            debugPrint('Has Time: $hasTime');
                            debugPrint('Has Mode: $hasMode');

                            if (hasDate && hasTime && hasMode) {
                              // Calculate amount based on selected mode
                              final amount = isRescheduleMode
                                  ? (appointmentDetailsForReschedule
                                              ?.modeOfAppointment ==
                                          0
                                      ? doctor.olInitialConsultationPrice
                                      : doctor.f2fInitialConsultationPrice)
                                  : (bookAppointmentBloc
                                              .selectedModeofAppointmentIndex ==
                                          0
                                      ? doctor.olInitialConsultationPrice
                                      : doctor.f2fInitialConsultationPrice);

                              debugPrint('Creating Pay Now Button with:');
                              debugPrint('Amount: $amount');
                              debugPrint(
                                  'Temp Appointment ID: ${bookAppointmentBloc.tempAppointmentId}');

                              // Parse the selected date
                              // final selectedDate =
                              //     DateFormat('EEEE, d \'of\' MMMM y').parse(
                              //         bookAppointmentBloc.dateController.text);

                              return PayNowButton(
                                appointmentId: isRescheduleMode
                                    ? appointmentDetailsForReschedule!
                                        .appointmentUid!
                                    : bookAppointmentBloc.tempAppointmentId!,
                                doctorId: doctor.uid,
                                doctorName: doctor.name,
                                patientName: currentActivePatient!.name,
                                modeOfAppointment: isRescheduleMode
                                    ? (appointmentDetailsForReschedule
                                            ?.modeOfAppointment ??
                                        0)
                                    : bookAppointmentBloc
                                        .selectedModeofAppointmentIndex,
                                amount: amount ?? 0.0,
                                appointmentDate:
                                    bookAppointmentBloc.dateController.text,
                                onPaymentCreated: (invoiceUrl) {
                                  // Store the invoice URL in the bloc for reuse
                                  bookAppointmentBloc.currentInvoiceUrl =
                                      invoiceUrl;
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        */
                        const Gap(30),
                        // Commenting out the payment warning message - can be uncommented if needed
                        /*
                        if (bookAppointmentBloc.isBookAppointmentClicked)
                          Center(
                            child: Text(
                              'Please complete the payment before booking the appointment.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        */
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.93,
                              height: MediaQuery.of(context).size.height / 17,
                              child: BlocBuilder<BookAppointmentBloc,
                                  BookAppointmentState>(
                                builder: (context, state) {
                                  if (isRescheduleMode) {
                                    // Check if date and time are selected first
                                    final hasDate = bookAppointmentBloc
                                        .dateController.text.isNotEmpty;
                                    final hasTime =
                                        bookAppointmentBloc.selectedTimeIndex !=
                                            -1;

                                    // If date and time aren't selected, don't show the button
                                    if (!hasDate || !hasTime) {
                                      return const SizedBox.shrink();
                                    }

                                    return StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('appointments')
                                          .doc(appointmentDetailsForReschedule!
                                              .appointmentUid!)
                                          .collection('payments')
                                          .snapshots(),
                                      builder: (context, paymentSnapshot) {
                                        // Always show the button in reschedule mode if we have date and time
                                        return FilledButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              GinaAppTheme
                                                  .lightTertiaryContainer,
                                            ),
                                          ),
                                          onPressed: () {
                                            if (bookAppointmentBloc
                                                        .selectedTimeIndex ==
                                                    -1 ||
                                                bookAppointmentBloc
                                                    .dateController
                                                    .text
                                                    .isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Please select date and time'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                              return;
                                            }

                                            final currentState =
                                                bookAppointmentBloc.state;
                                            if (currentState
                                                is GetDoctorAvailabilityLoaded) {
                                              final selectedIndex = currentState
                                                  .selectedTimeIndex!;
                                              final selectedTime =
                                                  '${doctorAvailabilityModel.startTimes[selectedIndex]} - ${doctorAvailabilityModel.endTimes[selectedIndex]}';

                                              debugPrint(
                                                  'Rescheduling appointment...');
                                              appointmentDetailsBloc.add(
                                                RescheduleAppointmentEvent(
                                                  doctor: doctor,
                                                  appointmentUid:
                                                      appointmentUidToReschedule!,
                                                  appointmentDate:
                                                      bookAppointmentBloc
                                                          .selectedFormattedDate,
                                                  appointmentTime: selectedTime,
                                                  reasonForAppointment:
                                                      bookAppointmentBloc
                                                          .reasonController.text
                                                          .trim(),
                                                ),
                                              );

                                              debugPrint(
                                                  'Reschedule completed, showing success dialog...');

                                              showRescheduleAppointmentSuccessDialog(
                                                context,
                                                appointmentUidToReschedule!,
                                                doctor,
                                              ).then((_) {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return ReviewRescheduledAppointmentScreen(
                                                        doctorDetails: doctor,
                                                        currentPatient:
                                                            currentActivePatient!,
                                                        appointmentModel:
                                                            appointmentDetailsForReschedule!,
                                                      );
                                                    },
                                                  ),
                                                );
                                              }).whenComplete(() {
                                                isRescheduleMode = false;
                                                debugPrint(
                                                    'isRescheduleMode set to false');
                                              });
                                            }
                                          },
                                          child: Text(
                                            'Reschedule Appointment',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    // Modified Book Appointment button logic
                                    return BlocBuilder<BookAppointmentBloc,
                                        BookAppointmentState>(
                                      builder: (context, state) {
                                        // Check if we have all the required selections
                                        final hasDate = bookAppointmentBloc
                                            .dateController.text.isNotEmpty;
                                        final hasTime = bookAppointmentBloc
                                                .selectedTimeIndex !=
                                            -1;
                                        final hasMode = bookAppointmentBloc
                                                .selectedModeofAppointmentIndex !=
                                            -1;

                                        // Button is enabled only if all selections are made
                                        final isButtonEnabled =
                                            hasDate && hasTime && hasMode;

                                        return FilledButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              isButtonEnabled
                                                  ? GinaAppTheme
                                                      .lightTertiaryContainer
                                                  : GinaAppTheme
                                                      .lightSurfaceVariant,
                                            ),
                                          ),
                                          onPressed: isButtonEnabled
                                              ? () {
                                                  final currentState =
                                                      bookAppointmentBloc.state;
                                                  if (currentState
                                                      is GetDoctorAvailabilityLoaded) {
                                                    final selectedIndex =
                                                        currentState
                                                            .selectedTimeIndex!;
                                                    final selectedTime =
                                                        '${doctorAvailabilityModel.startTimes[selectedIndex]} - ${doctorAvailabilityModel.endTimes[selectedIndex]}';

                                                    final selectedModeIndex =
                                                        selectedModeOfAppointmentIndex;

                                                    debugPrint(
                                                        'Selected mode index: $selectedModeIndex');

                                                    final platformFeePercentage =
                                                        selectedModeIndex == 0
                                                            ? onlinePlatformFeePercentage
                                                            : f2fPlatformFeePercentage;

                                                    debugPrint(
                                                        'Booking new appointment...');
                                                    debugPrint(
                                                        'Selected mode: ${selectedModeIndex == 0 ? "Online" : "Face-to-Face"}');
                                                    debugPrint(
                                                        'Using platform fee: ${(platformFeePercentage * 100).toInt()}%');
                                                    final tempAppointmentId =
                                                        bookAppointmentBloc
                                                            .tempAppointmentId;
                                                    debugPrint(
                                                        'Using tempAppointmentId for booking: $tempAppointmentId');

                                                    bookAppointmentBloc.add(
                                                      BookForAnAppointmentEvent(
                                                        doctorId: doctor.uid,
                                                        doctorName: doctor.name,
                                                        doctorClinicAddress:
                                                            doctor
                                                                .officeAddress,
                                                        appointmentDate:
                                                            bookAppointmentBloc
                                                                .selectedFormattedDate,
                                                        appointmentTime:
                                                            selectedTime,
                                                        appointmentId:
                                                            tempAppointmentId!,
                                                        reasonForAppointment:
                                                            bookAppointmentBloc
                                                                .reasonController
                                                                .text
                                                                .trim(),
                                                        platformFeePercentage:
                                                            platformFeePercentage,
                                                      ),
                                                    );
                                                  }
                                                }
                                              : null,
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
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
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
