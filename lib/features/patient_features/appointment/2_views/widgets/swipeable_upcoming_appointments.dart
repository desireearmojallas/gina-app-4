import 'package:flutter/material.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/upcoming_appointments_container_2.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';


// TODO : GOTTA MAKE THIS WORK
class SwipeableUpcomingAppointments extends StatelessWidget {
  final List<UpcomingAppointmentsContainer2> initialCards;
  UpcomingAppointmentsContainer2 Function()? onCardSwipedCallback;
  SwipeableUpcomingAppointments({
    super.key,
    required this.initialCards,
    this.onCardSwipedCallback,
  });

  @override
  Widget build(BuildContext context) {
    SwipeableCardSectionController _cardController =
        SwipeableCardSectionController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SwipeableCardsSection(
          cardController: _cardController,
          context: context,
          items: initialCards,
          onCardSwiped: (dir, index, widget) {
            _cardController.addItem(onCardSwipedCallback!());
          },
          enableSwipeUp: true,
          enableSwipeDown: false,
        ),
      ],
    );
  }
}
