import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/cancelled_appointments/cancelled_appointments_list.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/completed_appointments/consultation_history_list.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/declined_appointments/declined_appointments_list.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/missed_appointments/missed_appointments_list.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/on_going_appointments/on_going_appointments_list.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/pending_appointments/pending_appointments_list.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/0_model/chat_message_model.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AppointmentsTabView extends StatelessWidget {
  final List<AppointmentModel> missedAppointments;
  final List<AppointmentModel> completedAppointments;
  final List<AppointmentModel> cancelledAppointments;
  final List<AppointmentModel> declinedAppointments;
  final List<AppointmentModel> pendingAppointments;
  final List<AppointmentModel> ongoingAppointments;
  final List<ChatMessageModel> chatRooms;
  final int initialIndex;

  const AppointmentsTabView({
    super.key,
    required this.missedAppointments,
    required this.completedAppointments,
    required this.cancelledAppointments,
    required this.declinedAppointments,
    required this.pendingAppointments,
    required this.ongoingAppointments,
    required this.initialIndex,
    required this.chatRooms,
  });

  Stream<bool> _hasNewItemsStream(List<AppointmentModel> appointments) {
    if (appointments.isEmpty) return Stream.value(false);

    // Split appointments into chunks of 30
    final chunks = <List<String>>[];
    final appointmentIds = appointments
        .map((a) => a.appointmentUid)
        .whereType<String>() // Filter out null values
        .toList();

    for (var i = 0; i < appointmentIds.length; i += 30) {
      final end =
          (i + 30 < appointmentIds.length) ? i + 30 : appointmentIds.length;
      chunks.add(appointmentIds.sublist(i, end));
    }

    // Create a stream for each chunk and combine them
    final streams = chunks.map((chunk) {
      return FirebaseFirestore.instance
          .collection('appointments')
          .where(FieldPath.documentId, whereIn: chunk)
          .snapshots()
          .map((snapshot) {
        final now = DateTime.now();
        final twentyFourHoursAgo = now.subtract(const Duration(hours: 24));

        return snapshot.docs.any((doc) {
          final appointment = AppointmentModel.fromJson(doc.data());
          return !appointment.isViewed &&
              appointment.lastUpdatedAt != null &&
              appointment.lastUpdatedAt!.isAfter(twentyFourHoursAgo);
        });
      });
    });

    // Combine all streams and return true if any chunk has new items
    return Rx.combineLatest<bool, bool>(
      streams,
      (List<bool> values) => values.any((value) => value),
    );
  }

  Future<void> _markAppointmentsAsViewed(
      List<AppointmentModel> appointments) async {
    final batch = FirebaseFirestore.instance.batch();

    for (var appointment in appointments) {
      if (!appointment.isViewed) {
        final docRef = FirebaseFirestore.instance
            .collection('appointments')
            .doc(appointment.appointmentUid);
        batch.update(docRef, {'isViewed': true});
      }
    }

    await batch.commit();
  }

  Widget _buildTabWithNotification({
    required IconData icon,
    required String label,
    required Stream<bool> hasNewItemsStream,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0, top: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18.0),
              const Gap(5),
              Text(label),
            ],
          ),
        ),
        StreamBuilder<bool>(
          stream: hasNewItemsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              return Positioned(
                right: -3,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: GinaAppTheme.lightTertiaryContainer,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;

    final List<TabData> tabs = [
      TabData(
        index: 0,
        title: Tab(
          child: _buildTabWithNotification(
            icon: Icons.do_not_disturb_on,
            label: 'CANCELLED',
            hasNewItemsStream: _hasNewItemsStream(cancelledAppointments),
          ),
        ),
        content: CancelledAppointmentsList(appointments: cancelledAppointments),
      ),
      TabData(
        index: 1,
        title: Tab(
          child: _buildTabWithNotification(
            icon: Icons.cancel,
            label: 'MISSED',
            hasNewItemsStream: _hasNewItemsStream(missedAppointments),
          ),
        ),
        content: MissedAppointmentsList(appointments: missedAppointments),
      ),
      TabData(
        index: 2,
        title: Tab(
          child: _buildTabWithNotification(
            icon: Icons.access_time_filled_rounded,
            label: 'PENDING',
            hasNewItemsStream: _hasNewItemsStream(pendingAppointments),
          ),
        ),
        content: PendingAppointmentsList(appointments: pendingAppointments),
      ),
      TabData(
        index: 3,
        title: Tab(
          child: _buildTabWithNotification(
            icon: MingCute.chat_2_fill,
            label: 'ON-GOING',
            hasNewItemsStream: _hasNewItemsStream(ongoingAppointments),
          ),
        ),
        content: OnGoingAppointmentsList(
          appointments: ongoingAppointments,
          chatRooms: chatRooms,
        ),
      ),
      TabData(
        index: 4,
        title: Tab(
          child: _buildTabWithNotification(
            icon: Icons.check_circle_rounded,
            label: 'COMPLETED',
            hasNewItemsStream: _hasNewItemsStream(completedAppointments),
          ),
        ),
        content: ConsultationHistoryList(appointments: completedAppointments),
      ),
      TabData(
        index: 5,
        title: Tab(
          child: _buildTabWithNotification(
            icon: Icons.thumb_down,
            label: 'DECLINED',
            hasNewItemsStream: _hasNewItemsStream(declinedAppointments),
          ),
        ),
        content: DeclinedAppointmentsList(appointments: declinedAppointments),
      ),
    ];

    return Expanded(
      child: DynamicTabBarWidget(
        physicsTabBarView: const BouncingScrollPhysics(),
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        isScrollable: true,
        showBackIcon: false,
        showNextIcon: false,
        leading: null,
        trailing: null,
        dynamicTabs: tabs,
        enableFeedback: true,
        splashBorderRadius: BorderRadius.circular(10.0),
        splashFactory: InkSparkle.splashFactory,
        indicatorColor: GinaAppTheme.lightTertiaryContainer,
        labelColor: GinaAppTheme.lightTertiaryContainer,
        labelStyle: ginaTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
        unselectedLabelStyle: ginaTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 11.5,
        ),
        unselectedLabelColor: GinaAppTheme.lightOutline.withAlpha(204),
        labelPadding: const EdgeInsets.symmetric(horizontal: 15.0),
        indicatorPadding: EdgeInsets.zero,
        onTabControllerUpdated: (controller) {
          controller.index = initialIndex;
        },
        onTabChanged: (index) async {
          HapticFeedback.heavyImpact();
          debugPrint('Tab changed to: $index');

          // Mark appointments as viewed when tab is selected
          List<AppointmentModel> appointmentsToMark;
          switch (index) {
            case 0:
              appointmentsToMark = cancelledAppointments;
              break;
            case 1:
              appointmentsToMark = missedAppointments;
              break;
            case 2:
              appointmentsToMark = pendingAppointments;
              break;
            case 3:
              appointmentsToMark = ongoingAppointments;
              break;
            case 4:
              appointmentsToMark = completedAppointments;
              break;
            case 5:
              appointmentsToMark = declinedAppointments;
              break;
            default:
              appointmentsToMark = [];
          }

          await _markAppointmentsAsViewed(appointmentsToMark);
        },
      ),
    );
  }
}
