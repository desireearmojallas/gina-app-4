import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_update_event.dart';
part 'profile_update_state.dart';

class ProfileUpdateBloc extends Bloc<ProfileUpdateEvent, ProfileUpdateState> {
  ProfileUpdateBloc() : super(ProfileUpdateInitial()) {
    on<ProfileUpdateEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
