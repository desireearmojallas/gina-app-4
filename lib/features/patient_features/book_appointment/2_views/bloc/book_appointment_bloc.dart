import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/1_controllers/appointment_controller.dart';
import 'package:gina_app_4/features/patient_features/doctor_availability/0_model/doctor_availability_model.dart';
import 'package:gina_app_4/features/patient_features/doctor_availability/1_controller/doctor_availability_controller.dart';
import 'package:gina_app_4/features/patient_features/doctor_availability/2_views/bloc/doctor_availability_bloc.dart';
import 'package:gina_app_4/features/patient_features/profile/1_controllers/profile_controller.dart';
import 'package:intl/intl.dart';

part 'book_appointment_event.dart';
part 'book_appointment_state.dart';

DoctorAvailabilityModel? bookDoctorAvailabilityModel;
UserModel? currentActivePatient;
AppointmentModel? currentAppointmentModel;

class BookAppointmentBloc
    extends Bloc<BookAppointmentEvent, BookAppointmentState> {
  final DoctorAvailabilityController doctorAvailabilityController;
  final AppointmentController appointmentController;
  final ProfileController profileController;
  int selectedTimeIndex = -1;
  int selectedModeofAppointmentIndex = -1;
  TextEditingController dateController = TextEditingController();

  BookAppointmentBloc({
    required this.doctorAvailabilityController,
    required this.appointmentController,
    required this.profileController,
  }) : super(BookAppointmentInitial()) {
    on<NavigateToReviewAppointmentEvent>(navigateToReviewAppointmentEvent);
    on<GetDoctorAvailabilityEvent>(getDoctorAvailabilityEvent);
    on<BookForAnAppointmentEvent>(bookForAnAppointmentEvent);
    on<SelectTimeEvent>(selectTimeEvent);
    on<SelectedModeOfAppointmentEvent>(selectModeOfAppointmentEvent);
  }

  FutureOr<void> navigateToReviewAppointmentEvent(
      NavigateToReviewAppointmentEvent event,
      Emitter<BookAppointmentState> emit) {
    // emit(ReviewAppointmentState());
  }

  FutureOr<void> getDoctorAvailabilityEvent(GetDoctorAvailabilityEvent event,
      Emitter<BookAppointmentState> emit) async {
    emit(GetDoctorAvailabilityLoading());

    final getProfileData = await profileController.getPatientProfile();

    getProfileData.fold(
      (failure) {},
      (patientData) {
        currentActivePatient = patientData;
      },
    );

    final result = await doctorAvailabilityController.getDoctorAvailability(
        doctorId: event.doctorId);

    result.fold(
      (failure) {
        emit(GetDoctorAvailabilityError(errorMessage: failure.toString()));
      },
      (doctorAvailabilityModel) {
        bookDoctorAvailabilityModel = doctorAvailabilityModel;
        emit(GetDoctorAvailabilityLoaded(
          doctorAvailabilityModel: doctorAvailabilityModel,
          selectedTimeIndex: null,
          selectedModeofAppointmentIndex: null,
          appointmentId: currentAppointmentModel?.appointmentUid,
          doctorName: currentAppointmentModel?.doctorName,
          consultationType: currentAppointmentModel?.consultationType,
          amount: currentAppointmentModel?.amount,
          appointmentDate: currentAppointmentModel?.appointmentDate != null 
              ? DateFormat('EEEE, d of MMMM y').parse(currentAppointmentModel!.appointmentDate!)
              : null,
        ));
      },
    );
  }

  FutureOr<void> bookForAnAppointmentEvent(BookForAnAppointmentEvent event,
      Emitter<BookAppointmentState> emit) async {
    emit(BookAppointmentRequestLoading());

    debugPrint('BookForAnAppointmentEvent triggered');

    String dateString = dateController.text;
    DateTime parsedDate = DateFormat('EEEE, d of MMMM y').parse(dateString);
    String reformattedDate = DateFormat('MMMM d, yyyy').format(parsedDate);

    debugPrint('datestring: $dateString');
    debugPrint('parsedDate: $parsedDate');
    debugPrint('reformattedDate: $reformattedDate');

    try {
      final result = await appointmentController.requestAnAppointment(
        doctorId: event.doctorId,
        doctorName: event.doctorName,
        doctorClinicAddress: event.doctorClinicAddress,
        appointmentDate: reformattedDate,
        appointmentTime: event.appointmentTime,
        modeOfAppointment: selectedModeofAppointmentIndex,
      );

      debugPrint('result: $result');

      result.fold(
        (failure) {
          debugPrint('Booking failed: $failure');
          emit(BookAppointmentError(errorMessage: failure.toString()));
        },
        (snapId) {
          currentAppointmentModel = AppointmentModel(
            appointmentUid: snapId,
            doctorUid: event.doctorId,
            doctorName: event.doctorName,
            doctorClinicAddress: event.doctorClinicAddress,
            appointmentDate: dateString,
            appointmentTime: event.appointmentTime,
            modeOfAppointment: selectedModeofAppointmentIndex,
          );
          debugPrint('Booking successful: $snapId');

          emit(
            ReviewAppointmentState(
              appointmentModel: AppointmentModel(
                appointmentUid: snapId,
                doctorUid: event.doctorId,
                doctorName: event.doctorName,
                doctorClinicAddress: event.doctorClinicAddress,
                appointmentDate: dateString,
                appointmentTime: event.appointmentTime,
                modeOfAppointment: selectedModeofAppointmentIndex,
              ),
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('Exception occurred: $e');
      emit(BookAppointmentError(errorMessage: e.toString()));
    }
  }

  FutureOr<void> selectTimeEvent(
      SelectTimeEvent event, Emitter<BookAppointmentState> emit) {
    emit(SelectTimeState(
      index: event.index,
      startingTime: event.startingTime,
      endingTime: event.endingTime,
    ));

    selectedTimeIndex = event.index;

    emit(GetDoctorAvailabilityLoaded(
      doctorAvailabilityModel: bookDoctorAvailabilityModel!,
      selectedTimeIndex: event.index,
      selectedModeofAppointmentIndex: selectedModeofAppointmentIndex,
      appointmentId: currentAppointmentModel?.appointmentUid,
      doctorName: currentAppointmentModel?.doctorName,
      consultationType: currentAppointmentModel?.consultationType,
      amount: currentAppointmentModel?.amount,
      appointmentDate: currentAppointmentModel?.appointmentDate != null 
          ? DateFormat('EEEE, d of MMMM y').parse(currentAppointmentModel!.appointmentDate!)
          : null,
    ));
  }

  FutureOr<void> selectModeOfAppointmentEvent(
      SelectedModeOfAppointmentEvent event,
      Emitter<BookAppointmentState> emit) {
    emit(SelectedModeOfAppointmentState(
      index: event.index,
      modeOfAppointment: modeOfAppointment[event.index],
    ));

    selectedModeofAppointmentIndex = event.index;

    emit(GetDoctorAvailabilityLoaded(
      doctorAvailabilityModel: bookDoctorAvailabilityModel!,
      selectedTimeIndex: selectedTimeIndex,
      selectedModeofAppointmentIndex: event.index,
      appointmentId: currentAppointmentModel?.appointmentUid,
      doctorName: currentAppointmentModel?.doctorName,
      consultationType: currentAppointmentModel?.consultationType,
      amount: currentAppointmentModel?.amount,
      appointmentDate: currentAppointmentModel?.appointmentDate != null 
          ? DateFormat('EEEE, d of MMMM y').parse(currentAppointmentModel!.appointmentDate!)
          : null,
    ));
  }

  String getDoctorAvailability(
      DoctorAvailabilityModel doctorAvailabilityModel) {
    if (doctorAvailabilityModel.days.isEmpty) {
      return 'Doctor is not available';
    }

    final String firstDay = dayNames[doctorAvailabilityModel.days.first];
    final String lastDay = dayNames[doctorAvailabilityModel.days.last];

    return '$firstDay to $lastDay';
  }

  List<String> getModeOfAppointment(
      DoctorAvailabilityModel doctorAvailabilityModel) {
    final List<String> modeOfAppointmentList = [];

    for (final mode in doctorAvailabilityModel.modeOfAppointment) {
      ModeOfAppointmentId modeOfAppointmentId =
          ModeOfAppointmentId.values[mode];
      switch (modeOfAppointmentId) {
        case ModeOfAppointmentId.onlineConsultation:
          modeOfAppointmentList.add('Online Consultation');
          break;
        case ModeOfAppointmentId.faceToFaceConsultation:
          modeOfAppointmentList.add('Face-to-Face');
          break;
        default:
          modeOfAppointmentList.add('Unknown');
      }
    }

    // Ensure the list is ordered correctly
    modeOfAppointmentList.sort((a, b) {
      if (a == 'Online Consultation') return -1;
      if (b == 'Online Consultation') return 1;
      return 0;
    });

    // Debugging: Print the mode of appointment list
    debugPrint('Mode of Appointment List: $modeOfAppointmentList');

    return modeOfAppointmentList;
  }

  int calculateAge(String dateOfBirth) {
    final birthDate = DateFormat('MMMM dd, yyyy').parse(dateOfBirth);
    int age = DateTime.now().year - birthDate.year;

    // If the birthday hasn't occurred yet this year, subtract one from age
    if (DateTime.now().month < birthDate.month ||
        (DateTime.now().month == birthDate.month &&
            DateTime.now().day < birthDate.day)) {
      age--;
    }

    return age;
  }
}
