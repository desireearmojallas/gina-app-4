
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctor_forum_badge_event.dart';
part 'doctor_forum_badge_state.dart';

class DoctorForumBadgeBloc extends Bloc<DoctorForumBadgeEvent, DoctorForumBadgeState> {
  DoctorForumBadgeBloc() : super(DoctorForumBadgeInitial()) {
    on<DoctorForumBadgeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
