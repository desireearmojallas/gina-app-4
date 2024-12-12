import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/bloc/pending_request_state_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:intl/intl.dart';

class PendingRequestStateScreenLoaded extends StatelessWidget {
  final Map<DateTime, List<AppointmentModel>> pendingRequests;
  const PendingRequestStateScreenLoaded({
    super.key,
    required this.pendingRequests,
  });

  @override
  Widget build(BuildContext context) {
    final pendingRequestStateBloc = context.read<PendingRequestStateBloc>();
    var dates = pendingRequests.keys.toList();
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);

    // Debugging: Print the pending requests data
    debugPrint('Pending Requests: $pendingRequests');

    return RefreshIndicator(
      onRefresh: () {
        pendingRequestStateBloc.add(
          PendingRequestStateInitialEvent(),
        );
        return Future.value();
      },
      child: ScrollbarCustom(
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 10.0),
          physics: const BouncingScrollPhysics(),
          itemCount: pendingRequests.length,
          itemBuilder: (context, index) {
            final date = dates[index];
            final requestsOnDate = pendingRequests[date]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    DateFormat('MMMM d, EEEE').format(date),
                    style: const TextStyle(
                      color: GinaAppTheme.lightOutline,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: "SF UI Display",
                    ),
                  ),
                ),
                ...requestsOnDate.map(
                  (request) {
                    // Debugging: Print the appointment time
                    debugPrint('Appointment Time: ${request.appointmentTime}');
                    return GestureDetector(
                      onTap: () {
                        pendingRequestStateBloc.add(
                          NavigateToPendingRequestDetailEvent(
                            appointment: request,
                          ),
                        );
                      },
                      child: Container(
                        height: size.height * 0.11,
                        width: size.width / 1.05,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: GinaAppTheme.lightOnTertiary,
                          boxShadow: [
                            GinaAppTheme.defaultBoxShadow,
                          ],
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: CircleAvatar(
                                radius: 37,
                                backgroundImage: AssetImage(
                                  Images.patientProfileIcon,
                                ),
                                backgroundColor: Colors.white,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request.patientName ?? "",
                                  style:
                                      ginaTheme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Gap(5),
                                Text(
                                  request.modeOfAppointment ==
                                          ModeOfAppointmentId
                                              .onlineConsultation.index
                                      ? 'Online Consultation'.toUpperCase()
                                      : 'Face-to-face Consultation'
                                          .toUpperCase(),
                                  style:
                                      ginaTheme.textTheme.labelSmall?.copyWith(
                                    color: GinaAppTheme.lightTertiaryContainer,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(5),
                                Text(
                                  '${request.appointmentDate}\n${request.appointmentTime}',
                                  style:
                                      ginaTheme.textTheme.labelMedium?.copyWith(
                                    color: GinaAppTheme.lightOutline,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 30.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppointmentStatusContainer(
                                    appointmentStatus:
                                        request.appointmentStatus,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
