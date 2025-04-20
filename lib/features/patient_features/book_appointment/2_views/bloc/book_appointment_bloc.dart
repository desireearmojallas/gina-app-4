import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:gina_app_4/features/patient_features/payment_feature/3_services/patient_payment_service.dart';
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
  final TextEditingController reasonController = TextEditingController();
  int selectedTimeIndex = -1;
  int selectedModeofAppointmentIndex = -1;
  String selectedFormattedDate = '';
  TextEditingController dateController = TextEditingController();
  String? currentInvoiceUrl;
  String? tempAppointmentId;
  bool isBookAppointmentClicked = false;

  BookAppointmentBloc({
    required this.doctorAvailabilityController,
    required this.appointmentController,
    required this.profileController,
  }) : super(BookAppointmentInitial()) {
    // Generate temporary appointment ID when bloc is created
    tempAppointmentId = 'temp-${DateTime.now().millisecondsSinceEpoch}';
    debugPrint('Generated temporary appointment ID: $tempAppointmentId');

    on<NavigateToReviewAppointmentEvent>(navigateToReviewAppointmentEvent);
    on<GetDoctorAvailabilityEvent>(getDoctorAvailabilityEvent);
    on<BookForAnAppointmentEvent>(bookForAnAppointmentEvent);
    on<SelectTimeEvent>(selectTimeEvent);
    on<SelectedModeOfAppointmentEvent>(selectModeOfAppointmentEvent);
  }

  @override
  Future<void> close() {
    reasonController.dispose();
    // Dispose other controllers
    return super.close();
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
          appointmentId: currentAppointmentModel?.appointmentUid ??
              'temp-${DateTime.now().millisecondsSinceEpoch}',
          doctorName: currentAppointmentModel?.doctorName!,
          consultationType: currentAppointmentModel?.consultationType,
          amount: currentAppointmentModel?.amount,
          appointmentDate: currentAppointmentModel?.appointmentDate != null
              ? DateFormat('EEEE, d of MMMM y')
                  .parse(currentAppointmentModel!.appointmentDate!)
              : null,
        ));
      },
    );
  }

  Future<String> _checkPaymentStatus(String tempAppointmentId) async {
    try {
      debugPrint('=== Checking Payment Status ===');
      debugPrint('Temp Appointment ID: $tempAppointmentId');
      debugPrint('Current Invoice URL: $currentInvoiceUrl');

      debugPrint('Fetching payment document from Firestore...');
      final paymentDoc = await FirebaseFirestore.instance
          .collection('pending_payments')
          .doc(tempAppointmentId)
          .get();

      if (!paymentDoc.exists) {
        debugPrint('Payment document not found in pending_payments');
        return 'not_found';
      }

      final paymentData = paymentDoc.data()!;
      final invoiceId = paymentData['invoiceId'] as String;
      final currentStatus = paymentData['status'] as String? ?? 'pending';
      final lastCheckedAt = paymentData['lastCheckedAt'] as Timestamp?;
      final updatedAt = paymentData['updatedAt'] as Timestamp?;

      debugPrint('Payment Document Details:');
      debugPrint('Invoice ID: $invoiceId');
      debugPrint('Current Status in Firestore: $currentStatus');
      debugPrint('Last Checked At: ${lastCheckedAt?.toDate()}');
      debugPrint('Last Updated At: ${updatedAt?.toDate()}');

      if (currentStatus.toLowerCase() == 'paid') {
        debugPrint('Payment is marked as paid in Firestore');
        return 'paid';
      }

      debugPrint('Verifying with Xendit...');
      final paymentService = PatientPaymentService();
      final xenditStatus =
          await paymentService.checkXenditPaymentStatus(invoiceId);

      debugPrint('Xendit Payment Status: $xenditStatus');

      if (xenditStatus.toLowerCase() != currentStatus.toLowerCase()) {
        debugPrint(
            'Updating payment status in Firestore from $currentStatus to $xenditStatus');
        await FirebaseFirestore.instance
            .collection('pending_payments')
            .doc(tempAppointmentId)
            .update({
          'status': xenditStatus.toLowerCase(),
          'updatedAt': FieldValue.serverTimestamp(),
          'lastCheckedAt': FieldValue.serverTimestamp(),
        });
        debugPrint('Successfully updated payment status in Firestore');
      } else {
        debugPrint('Payment status unchanged in Firestore');
      }

      return xenditStatus.toLowerCase();
    } catch (e) {
      debugPrint('Error checking payment status: $e');
      throw Exception('Failed to check payment status: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchPendingPayment(
      String appointmentId) async {
    try {
      debugPrint('=== Fetching Pending Payment ===');
      debugPrint('Appointment ID: $appointmentId');

      // First, check the payments subcollection to get the tempAppointmentId
      final paymentsSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .collection('payments')
          .get();

      if (paymentsSnapshot.docs.isEmpty) {
        debugPrint('No payment documents found in subcollection');
        return null;
      }

      // Get the first payment document (assuming there's only one)
      final paymentDoc = paymentsSnapshot.docs.first;
      final paymentData = paymentDoc.data();
      final tempAppointmentId = paymentData['appointmentId'] as String?;

      if (tempAppointmentId == null) {
        debugPrint('No tempAppointmentId found in payment document');
        return null;
      }

      debugPrint('Found tempAppointmentId: $tempAppointmentId');

      // Now fetch the pending payment using the tempAppointmentId
      final pendingPaymentDoc = await FirebaseFirestore.instance
          .collection('pending_payments')
          .doc(tempAppointmentId)
          .get();

      if (!pendingPaymentDoc.exists) {
        debugPrint(
            'No pending payment found for tempAppointmentId: $tempAppointmentId');
        return null;
      }

      final pendingPaymentData = pendingPaymentDoc.data();
      debugPrint(
          'Found pending payment with status: ${pendingPaymentData?['status']}');
      return pendingPaymentData;
    } catch (e) {
      debugPrint('Error fetching pending payment: $e');
      return null;
    }
  }

  Future<void> bookForAnAppointmentEvent(
    BookForAnAppointmentEvent event,
    Emitter<BookAppointmentState> emit,
  ) async {
    try {
      emit(BookAppointmentLoading());
      isBookAppointmentClicked = true;
      debugPrint('Book Appointment button clicked');
      debugPrint('Event appointment ID: ${event.appointmentId}');

      //TODO: move this after doctor approval later
      // debugPrint('Current temp appointment ID: $tempAppointmentId');
      // debugPrint('Current invoice URL: $currentInvoiceUrl');

      // debugPrint('Checking payment status...');
      // final paymentStatus = await _checkPaymentStatus(event.appointmentId);
      // debugPrint('Payment status check result: $paymentStatus');

      // if (paymentStatus != 'paid') {
      //   debugPrint('Payment not completed. Status: $paymentStatus');
      //   emit(BookAppointmentError(
      //     errorMessage: paymentStatus == 'expired'
      //         ? 'Payment has expired. Please try again.'
      //         : 'Please complete the payment before booking the appointment.',
      //   ));
      //   return;
      // }

      // debugPrint('Payment verified as paid, proceeding with booking...');
      String dateString = dateController.text;
      DateTime parsedDate = DateFormat('EEEE, d of MMMM y').parse(dateString);
      String reformattedDate = DateFormat('MMMM d, yyyy').format(parsedDate);
      final newDateFormat = DateFormat('EEEE, d \'of\' MMMM y');
      DateTime? newParsedDate;
      newParsedDate = newDateFormat.parse(dateString);
      debugPrint('Parsed new date: $newParsedDate');

      debugPrint('Creating appointment with:');
      debugPrint('Doctor ID: ${event.doctorId}');
      debugPrint('Doctor Name: ${event.doctorName}');
      debugPrint('Date: $reformattedDate');
      debugPrint('Time: ${event.appointmentTime}');
      debugPrint('Mode: $selectedModeofAppointmentIndex');

      // Get doctor details to calculate amount
      final doctorDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(event.doctorId)
          .get();
      final doctorData = doctorDoc.data();

      // Calculate amount based on mode of appointment
      final amount = selectedModeofAppointmentIndex == 0
          ? (doctorData != null
              ? doctorData['olInitialConsultationPrice'] ?? 0.0
              : 0.0)
          : (doctorData != null
              ? doctorData['f2fInitialConsultationPrice'] ?? 0.0
              : 0.0);

      debugPrint('Calculated amount: $amount');

      final result = await appointmentController.requestAnAppointment(
        doctorId: event.doctorId,
        doctorName: event.doctorName,
        doctorClinicAddress: event.doctorClinicAddress,
        appointmentDate: reformattedDate,
        appointmentTime: event.appointmentTime,
        modeOfAppointment: selectedModeofAppointmentIndex,
        amount: amount,
        reasonForAppointment: event.reasonForAppointment,
      );

      if (result.isRight()) {
        final appointmentId = result.fold(
          (error) => '',
          (id) => id,
        );

        // final paymentService = PatientPaymentService();
        // await paymentService.linkPaymentToAppointment(
        //     event.appointmentId, appointmentId,
        //     doctorId: event.doctorId);

        // debugPrint('Appointment created and payment linked successfully');

        emit(GetDoctorAvailabilityLoaded(
          doctorAvailabilityModel: bookDoctorAvailabilityModel!,
          appointmentId: appointmentId,
          doctorName: event.doctorName,
          appointmentDate: newParsedDate,
          selectedTimeIndex: selectedTimeIndex,
          selectedModeofAppointmentIndex: selectedModeofAppointmentIndex,
        ));

        final appointmentModel = AppointmentModel(
          appointmentUid: appointmentId,
          doctorUid: event.doctorId,
          doctorName: event.doctorName,
          doctorClinicAddress: event.doctorClinicAddress,
          appointmentDate: reformattedDate,
          appointmentTime: event.appointmentTime,
          modeOfAppointment: selectedModeofAppointmentIndex,
          amount: amount,
          reasonForAppointment: event.reasonForAppointment,
        );

        emit(BookForAnAppointmentReview(
          appointmentModel: appointmentModel,
        ));
      } else {
        emit(BookAppointmentError(
          errorMessage: result.fold(
            (error) => error.toString(),
            (_) => 'Failed to book appointment',
          ),
        ));
      }
    } catch (e) {
      debugPrint('Error in bookForAnAppointmentEvent: $e');
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

    DateTime? selectedDate;
    if (dateController.text.isNotEmpty) {
      selectedDate = DateFormat('EEEE, d of MMMM y').parse(dateController.text);
    }

    emit(GetDoctorAvailabilityLoaded(
      doctorAvailabilityModel: bookDoctorAvailabilityModel!,
      selectedTimeIndex: event.index,
      selectedModeofAppointmentIndex: selectedModeofAppointmentIndex,
      appointmentId: currentAppointmentModel?.appointmentUid!,
      doctorName: currentAppointmentModel?.doctorName!,
      consultationType: currentAppointmentModel?.consultationType,
      amount: currentAppointmentModel?.amount,
      appointmentDate: selectedDate,
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

    DateTime? selectedDate;
    if (dateController.text.isNotEmpty) {
      selectedDate = DateFormat('EEEE, d of MMMM y').parse(dateController.text);
    }

    emit(GetDoctorAvailabilityLoaded(
      doctorAvailabilityModel: bookDoctorAvailabilityModel!,
      selectedTimeIndex: selectedTimeIndex,
      selectedModeofAppointmentIndex: event.index,
      appointmentId: currentAppointmentModel?.appointmentUid ??
          'temp-${DateTime.now().millisecondsSinceEpoch}',
      doctorName: currentAppointmentModel?.doctorName!,
      consultationType: currentAppointmentModel?.consultationType,
      amount: currentAppointmentModel?.amount,
      appointmentDate: selectedDate,
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

    modeOfAppointmentList.sort((a, b) {
      if (a == 'Online Consultation') return -1;
      if (b == 'Online Consultation') return 1;
      return 0;
    });

    debugPrint('Mode of Appointment List: $modeOfAppointmentList');

    return modeOfAppointmentList;
  }

  int calculateAge(String dateOfBirth) {
    final birthDate = DateFormat('MMMM dd, yyyy').parse(dateOfBirth);
    int age = DateTime.now().year - birthDate.year;

    if (DateTime.now().month < birthDate.month ||
        (DateTime.now().month == birthDate.month &&
            DateTime.now().day < birthDate.day)) {
      age--;
    }

    return age;
  }
}
